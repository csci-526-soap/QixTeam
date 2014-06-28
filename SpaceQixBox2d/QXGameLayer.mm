//
//  QXGameLayer.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXGameLayer.h"
#import "CCJoyStick.h"
#import "cocos2d.h"
#import "QXSceneManager.h"
#import "AppDelegate.h"
#import "QXMap.h"
#import "CCRenderTexture+Percentage.h"
#import "CCParticleEffectGenerator.h"
#import "CCShake.h"
#import "Timer.h"
#import "CDAudioManager.h"
#import "QXLevel.h"
#import "QXMonsterAttribute.h"

#include <stdlib.h>

@implementation QXGameLayer

+(id) scene
{
	CCScene *scene = [CCScene node];
	QXGameLayer *layer = [QXGameLayer node];
	[scene addChild: layer];
	return scene;
}

#pragma mark configuration

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) configLayer:(int) levevlId
{
    QXLevel *level = [[QXLevelMananger sharedLevelManager] findLevelById:levevlId];
    NSArray *qixAttributes = [level qixs];
    NSArray *armorAttributes = [level armors];
    QXBaseAttribute *playerAttribtue = [level playerAttribute];
    
    NSMutableArray *qixBoss = [[NSMutableArray alloc] init];
    NSMutableArray *qixs = [[NSMutableArray alloc] init];
    NSMutableArray *armors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [qixAttributes count]; i++) {
        QXMonsterAttribute *attr = [qixAttributes objectAtIndex:i];
        switch ([attr qixType]) {
            case Qix: {
                QXQix *qix = [[QXQix alloc] init];
                [qix build:attr];
                [qixBoss addObject:attr];
            }
                break;
            case Snake: {
                QXSnake *snake = [[QXSnake alloc] init];
                [snake build:attr];
                [qixBoss addObject:attr];
            }
                break;
            case Guard: {
                QXGuard *guard = [[QXGuard alloc] init];
                [guard build:attr];
                [qixs addObject:attr];
            }
                break;
            case Walker: {
                QXWalker *walker = [[QXWalker alloc] init];
                [walker build:attr];
                [qixs addObject:attr];
            }
                break;
            default:
                break;
        }
    }
    
    [[QXPlayers sharedPlayers] build:playerAttribtue];
    
    for (int i = 0; i <[armorAttributes count]; i++) {
        
    }
    
    
    
}

#pragma mark init

-(id) init
{
    if( (self=[super init] )) {
        
        NSLog(@"initialize the game layer");
        
        [self hideStatusBar];
        
        [self setupGame];
        
//        [[CDAudioManager sharedManager] playBackgroundMusic:@"goonBG.mp3" loop:YES];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        mapWidth = size.width;
        mapHeight = size.height;
        
        [self initAssets];
        
        [self initSpeedButton];
        
        [self initPhysicalWorld];
        
        [self initPlayers];
        
        [self initMonsters];
        
        [self scheduleUpdate];
        
        self.touchEnabled = YES;
        
        [Timer instance];
	}
	return self;
}

- (void) hideStatusBar
{
    NSLog(@"hide status bar");
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        NSLog(@"hide statuc bar success");
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

-(void) reset
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];
    
    CCSprite *layerUp = [CCSprite spriteWithFile:[self backgroundImagePath]];
    
    layerUp.position = ccp( size.width * 0.5f , size.height * 0.5f );
    
    [scratchableImage begin];
    [layerUp visit];
    [scratchableImage end];
    
}

- (void) setupGame
{
    score = 0;
    mapWidth = 0;
    mapHeight = 0;
    [[QXGamePlay sharedGamePlay] setup];
    prevDirection = NODIR;
    
    explosion = [[QXExplosion alloc] init];
    [explosion setup];
}

-(void)initAssets
{
    // initialize joy sticks
    myjoysitck=[CCJoyStick initWithBallRadius:70 MoveAreaRadius:80 isFollowTouch:NO isCanVisible:YES isAutoHide:NO hasAnimation:YES];
    [myjoysitck setBallTexture:@"hand_d_in.png"];
    [myjoysitck setDockTexture:@"hand_bottomd.png"];
    [myjoysitck setStickTexture:@"wall.png"];
    [myjoysitck setHitAreaWithRadius:50];
    myjoysitck.position=ccp(50,50);
    myjoysitck.delegate=self;
    [self addChild:myjoysitck];
    
    // Create a background image
    CCSprite *layerBottom = [CCSprite spriteWithFile:[self revealedImagePath]];
    
    // position the label on the center of the screen
    layerBottom.position =  ccp( mapWidth * 0.5f , mapHeight * 0.5f );

    // add the label as a child to this Layer
    [self addChild: layerBottom z:-2];
    
    CCRenderTexture *scratchableImage = [CCRenderTexture renderTextureWithWidth:mapWidth height:mapHeight];
    scratchableImage.position = ccp( mapWidth * 0.5f , mapHeight * 0.5f );
    [self addChild:scratchableImage z:-1 tag:SCRATCHABLE_IMAGE];
    [[scratchableImage sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
    
    // Source image
    [self reset];
    
    revealSprite = [CCSprite spriteWithFile:@"wall_c.png"];
    revealSprite.scale = 2.0;
    revealSprite.position = ccp( -10000, 0);
    [revealSprite setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [revealSprite retain];
    
    labelScore = [CCLabelTTF labelWithString:@"Score:0.000%" fontName:@"Verdana" fontSize:14];
    labelScore.anchorPoint = ccp(0.5,0.5);
    labelScore.position = ccp(420,300);
    [self addChild:labelScore z: 5];
    
    lifeIcons = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [[QXGamePlay sharedGamePlay] remainingLife]; i++) {
        CCSprite *lifeIcon = [CCSprite spriteWithFile:@"planeLife.png"];
        lifeIcon.position = ccp(480 + i*20, 300);
        lifeIcon.scale = 0.3f;
        [self addChild:lifeIcon z: 5];
        [lifeIcons addObject:lifeIcon];
    }
}

- (void) initPhysicalWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    _world = new b2World(gravity);
    
    _contactListener = new MyContactListener();
    _world->SetContactListener(_contactListener);
    
    // Create edges around the entire screen
    b2BodyDef boundaryBodyDef;
    boundaryBodyDef.position.Set(0, 0);
    boundaryBodyDef.userData = BODY_WORLD;
    
    b2Body *boundaryBody = _world->CreateBody(&boundaryBodyDef);
    b2EdgeShape boundaryEdge;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &boundaryEdge;
    
    NSArray *boundaries = [[QXMap sharedMap] boundary];
    
    // boundary definitions
    for (int i = 0; i < [boundaries count]; i++) {
        CGPoint p = [[boundaries objectAtIndex:i] CGPointValue];
        CGPoint q = [[boundaries objectAtIndex:(i+1)%[boundaries count]] CGPointValue];
        boundaryEdge.Set(b2Vec2(p.x/PTM_RATIO, p.y/PTM_RATIO), b2Vec2(q.x/PTM_RATIO, q.y/PTM_RATIO));
        boundaryBody->CreateFixture(&boxShapeDef);
    }
}

#pragma mark player

- (void) initPlayers
{
    [[QXPlayers sharedPlayers] setup:self physicalWorld:_world userData:BODY_PLAYER];
    prevDirection = NODIR;
    pspeed = ccp(1.0, 0);
    CGPoint p =  [[QXPlayers sharedPlayers] mainPlayerPosition];
    NSLog(@"players position: %f, %f", p.x, p.y);
}

- (void) movePlayer:(ccTime) delta
{
    int dir = [self pcontrol:[[QXPlayers sharedPlayers] velocity]];
    
    [self onPlayerMovingState:dir frameDuration:delta];
    
}

- (void) initSpeedButton
{
    int px = mapWidth * 0.8;
    int py = mapHeight * 0.2;
    int width=80;
    int height=80;
    CGRect buttonSpace=CGRectMake(px-width/2,mapHeight - py-height/2, width, height);
    progressBar = [[DACircularProgressView alloc] initAsNetrogenBar:buttonSpace];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTabSpeedButton:)];
    [progressBar addGestureRecognizer:tapGesture];
    [[[CCDirector sharedDirector] openGLView] addSubview:progressBar];
}

- (void) onTabSpeedButton:(id) sender
{
    [[QXMedalSystem sharedMedalSystem] invokeOnUsingNitrogen:^(enum QXMedalType, QXMedal *) {
        ;
    }];
    [progressBar highSpeedKeyDown];
}

#pragma mark update

- (void) updatePhysicalWorld
{
    for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            NSString *value = (NSString *) b->GetUserData();
            if ([value  isEqual: BODY_WORLD]) {
                _world->DestroyBody(b);
                break;
            }
        }
    }
    
    b2BodyDef boundaryBodyDef;
    boundaryBodyDef.position.Set(0, 0);
    boundaryBodyDef.userData = BODY_WORLD;
    
    b2Body *boundaryBody = _world->CreateBody(&boundaryBodyDef);
    b2EdgeShape boundaryEdge;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &boundaryEdge;
    
    NSArray *boundaries = [[QXMap sharedMap] boundary];
    
    // boundary definitions
    for (int i = 0; i < [boundaries count]; i++) {
        CGPoint p = [[boundaries objectAtIndex:i] CGPointValue];
        CGPoint q = [[boundaries objectAtIndex:(i+1)%[boundaries count]] CGPointValue];
        boundaryEdge.Set(b2Vec2(p.x/PTM_RATIO, p.y/PTM_RATIO), b2Vec2(q.x/PTM_RATIO, q.y/PTM_RATIO));
        boundaryBody->CreateFixture(&boxShapeDef);
    }
}


- (void) b2update:(ccTime)delta
{
    _world->Step(delta, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            [self onCocosAndBoxPositionUpdate:b];
        }
    }
    
    // Loop through all of the box2d bodies that are currently colliding, that we have
    // gathered with our custom contact listener...
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    
    for(pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        // Get the box2d bodies for each object
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();

        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            
            bool remove = [self onBox2dCollisionDetection:bodyA body2:bodyB toDestroy:toDestroy];
            
            if (remove) {
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
            }
            
        }
    }
    
    [self afterBox2dCollisionDetetion];
    
    // Loop through all of the box2d bodies we wnat to destroy...
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
//        NSLog(@"delete body");
        b2Body *body = *pos2;
        _world->DestroyBody(body);
    }
}

-(void)update:(ccTime)delta
{
    
    if(timerStart==1){
        timerStartCount = timerStartCount + 1;
        if(timerStartCount<151&&timerStartCount%30==0){
          //  [qix qixOpacityChange];
        }else if(timerStartCount==151){
         //   [Snake hitByGlacierFrozenThenShaking];
        }else if(timerStartCount>=300){
            timerStart = 0;
            timerStartCount = 0;
            [Snake hitByGlacierFrozenEnd:self];
        }
    }
    
    [[Timer instance] picturesDrivenEvent];
    
    if ([[QXGamePlay sharedGamePlay] isPlaying]) {
        
        [self movePlayer:delta];
        
        [self monsterTakeActions:delta];
        
        [self b2update:delta];
        
        if([[QXGamePlay sharedGamePlay] isLose] || [[QXMap sharedMap] isGameOver]) {
            [self displayLoseLayer];
        } else if([[QXGamePlay sharedGamePlay] isWin]) {
            [self displayWinLayer];
        }
    }
}

-(void)draw
{
    ccDrawColor4B(155, 123, 222, 255);
    
    glLineWidth(3.0f);
    
    NSArray *array = [[QXMap sharedMap] boundary];
    
    CGPoint poly[[array count]];
    
    for (int i = 0; i < [array count]; i++) {
        poly[i] = [[array objectAtIndex:i] CGPointValue];
    }
    
    ccDrawPoly(poly, [array count], YES);
    
    
    
    NSArray *trace = [[QXMap sharedMap] traces];
    
    CGPoint points[[trace count]];
    
    for (int i = 0; i < [trace count]; i++) {
        points[i] = [[trace objectAtIndex:i] CGPointValue];
    }
    
    ccDrawColor4B(255, 255, 255, 255);
    ccPointSize(1);
    ccDrawPoints(points, [trace count]);
    
}

#pragma mark joystick

- (void) onCCJoyStickUpdate:(CCNode*)sender Angle:(float)angle Direction:(CGPoint)direction Power:(float)power
{
    cgPoint = direction;
}

-(int) pcontrol:(double)playvelo
{
    int forx = (int)cgPoint.x;
    
    int fory = (int)cgPoint.y;
    
    int dir=NODIR;
    
    if(forx == -1&&fory==0)
    {
        pspeed = ccp(-1*playvelo,0);
        dir = LEFT;
    }
    else if(forx==1&&fory==0)
    {
        pspeed = ccp(1*playvelo,0);
        dir = RIGHT;
    }
    else if(forx == 0&&fory == -1)
    {
        pspeed = ccp(0,-1*playvelo);
        dir = DOWN;
    }
    else if(forx == 0&&fory == 1)
    {
        pspeed = ccp(0,1*playvelo);
        dir = UP;
    }
    
    return dir;
}

- (void) onCCJoyStickActivated:(CCNode*)sender
{
	if (sender==myjoysitck) {
		[myjoysitck setBallTexture:@"hand_in.png"];
		[myjoysitck setDockTexture:@"hand_bottom.png"];
	}
}
- (void) onCCJoyStickDeactivated:(CCNode*)sender
{
	if (sender==myjoysitck) {
		[myjoysitck setBallTexture:@"hand_d_in.png"];
		[myjoysitck setDockTexture:@"hand_bottomd.png"];
	}
}

#pragma mark game play

- (void) displayLoseLayer
{
    [[QXMedalSystem sharedMedalSystem] onGameLevelEnd:^(NSArray *medals) {
        for (QXMedal *medal in medals) {
        
        }
    }];
    
    [[QXMap sharedMap] clearArea];
    
    CCSprite *marklabel = [CCSprite spriteWithFile:@"alertGameover.png"];
    
    marklabel.position = ccp(280,200);
    
    [self addChild:marklabel];
    
    CCMenuItemFont *backItem = [CCMenuItemImage itemWithNormalImage:@"alertBack.png" selectedImage:@"alertBack.png" target:self selector: @selector(back:)];
    
    CCMenu *bmenu = [CCMenu menuWithItems:backItem, nil];
    
    bmenu.position = ccp(280,100);
    
    [self addChild: bmenu];
    
    CCMenuItemFont *again = [CCMenuItemImage itemWithNormalImage:@"alertRetry.png" selectedImage:@"alertRetry.png" target:self selector: @selector(again:)];
    
    CCMenu *amenu = [CCMenu menuWithItems:again, nil];
    
    amenu.position = ccp(280,150);
    
    [self addChild: amenu];
    
    [self unscheduleUpdate];
}

- (void) displayWinLayer
{
    [[QXMedalSystem sharedMedalSystem] onGameLevelEnd:^(NSArray *medals) {
        for (QXMedal *medal in medals) {
            
        }
    }];
    
    [[QXMap sharedMap] clearArea];
    
    CCSprite *marklabel = [CCSprite spriteWithFile:@"youwin.png"];
    
    marklabel.position = ccp(280,200);
    
    [self addChild:marklabel];
    
    CCMenuItemFont *backItem = [CCMenuItemImage itemWithNormalImage:@"alertBack.png" selectedImage:@"alertBack.png" target:self selector: @selector(back:)];
    
    CCMenu *bmenu = [CCMenu menuWithItems:backItem, nil];
    
    bmenu.position = ccp(280,100);
    
    [self addChild: bmenu];
    
    CCMenuItemFont *nextlevel = [CCMenuItemImage itemWithNormalImage:@"nextlevel.png" selectedImage:@"nextlevel.png" target:self selector: @selector(nextlevel:)];
    
    CCMenu *nmenu = [CCMenu menuWithItems:nextlevel, nil];
    
    nmenu.position = ccp(280,150);
    
    [self addChild: nmenu];
    [self unscheduleUpdate];
}

-(void) back: (id) sender{

    
    /*****************************/
    timerStart = 0;
    timerStartCount=0;
    /*****************************/
    
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
    [[QXGamePlay sharedGamePlay] reset];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QXMenuLayer scene] ]];
    [QXSceneManager goMenu];
}




-(void) nextlevel: (id) sender{
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
    [[QXGamePlay sharedGamePlay] reset];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QXMenuLayer scene] ]];
    if ([[QXGamePlay sharedGamePlay] unlockedLevel] >= [[QXGamePlay sharedGamePlay] totalLevel]) {
        [QXSceneManager goRandomLevel:[[QXGamePlay sharedGamePlay] totalLevel] currentLevel:levelId];
    } else {
        [QXSceneManager goLevel:levelId + 1];
    }
}


-(void) again: (id) sender{
    

    /*****************************/
    timerStart = 0;
    timerStartCount=0;
    /*****************************/
    
	delete _world;
    _world = NULL;
    
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
    [[QXGamePlay sharedGamePlay] reset];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QXMenuLayer scene] ]];
    [QXSceneManager goLevel:levelId];
}



#pragma abstract methods

- (void) initMonsters
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"walker.plist"];
    CCSprite *blue = [CCSprite spriteWithSpriteFrameName:@"walker0.png"];
    //    blue.scaleX = -blue.scaleX;
    blue.rotation = 0;
    blue.scaleY = -blue.scaleY;
    blue.tag = 1;
    CCSpriteBatchNode * batchNodeBlue = [CCSpriteBatchNode batchNodeWithFile:@"walker.png"];
    [batchNodeBlue addChild:blue];
    
    NSMutableArray * animFrames1 = [NSMutableArray array];
    
    for(int i =0; i < 12; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walker%d.png", i]];
        [animFrames1 addObject:frame];
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames1 delay:0.05f];
    [blue runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    blue.position = CGPointMake(mapWidth/2, mapHeight);
    
    nwWalker = [[QXWalker alloc] init];
    [nwWalker setup:blue Layer:self runDirection:LEFT runClockwise:false position:blue.position userData:BODY_WALKER_NW physicalWorld:_world];
    
    [self addChild:batchNodeBlue];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"walker.plist"];
    CCSprite *red = [CCSprite spriteWithSpriteFrameName:@"walker0.png"];
    red.rotation = 0;
    CCSpriteBatchNode * batchNodeRed = [CCSpriteBatchNode batchNodeWithFile:@"walker.png"];
    [batchNodeRed addChild:red];
    
    NSMutableArray * animFrames2 = [NSMutableArray array];
    
    for(int i =0; i < 12; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walker%d.png", i]];
        [animFrames2 addObject:frame];
        
    }
    
    CCAnimation * animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.05f];
    [red runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation2]]];
    
    
    red.tag = 2;
    red.position = CGPointMake(mapWidth, 0);
    nsWalker = [[QXWalker alloc] init];
    
    [nsWalker setup:red Layer:self runDirection:LEFT runClockwise:true position:red.position userData:BODY_WALKER_NS physicalWorld:_world];
    
    [self addChild:batchNodeRed];

}

- (void) monsterTakeActions:(ccTime) frameDuration
{
    if ([nwWalker isActive]) {
        [nwWalker takeAction:frameDuration];
    }
    if ([nsWalker isActive]) {
        [nsWalker takeAction:frameDuration];
    }
}

- (CGPoint) qixPosition
{
    return ccp(100, 200);
}

- (void) onPlayerMovingState:(int) dir  frameDuration:(ccTime)frameDuration
{
    int xposp = [[QXPlayers sharedPlayers] mainPlayerPosition].x;
    int yposp = [[QXPlayers sharedPlayers] mainPlayerPosition].y;
    
        int moveSteps = 0;
        
        // get the movedSteps;
        switch (dir) {
            case UP:
                moveSteps = fabs(pspeed.y);
                break;
            case DOWN:
                moveSteps = fabs(pspeed.y);
                break;
            case LEFT:
                moveSteps = fabs(pspeed.x);
                break;
            case RIGHT:
                moveSteps = fabs(pspeed.x);
                break;
            default:
                break;
                [progressBar nitrogenAdd:0.1];
        }
        
        int moves = 0;
        int currentX = xposp;
        int currentY = yposp;
        
        // determine how far can the character move from current location.
        while (moves < moveSteps) {
            if (![[QXMap sharedMap] canMovetoPosition:currentX y:currentY direction:dir]) {
                break;
            }
            switch (dir) {
                case UP:
                    [[QXMap sharedMap] moveFrom:CGPointMake(currentX, currentY) to:CGPointMake(currentX, currentY+1) direction:dir];
                    currentY += 1;
                    break;
                case DOWN:
                    [[QXMap sharedMap] moveFrom:CGPointMake(currentX, currentY) to:CGPointMake(currentX, currentY-1)  direction:dir];
                    currentY -= 1;
                    break;
                case LEFT:
                    [[QXMap sharedMap] moveFrom:CGPointMake(currentX, currentY) to:CGPointMake(currentX-1, currentY)  direction:dir];
                    currentX -= 1;
                    break;
                case RIGHT:
                    [[QXMap sharedMap] moveFrom:CGPointMake(currentX, currentY) to:CGPointMake(currentX+1, currentY)  direction:dir];
                    currentX += 1;
                    break;
                default:
                    break;
            }
            [[QXMap sharedMap] takeAction:nil qix:[self qixPosition] completion:^(bool fill, NSArray *collision, QXTraceState state) {
                
                switch (state) {
                    case START:
                        ;
                        break;
                    case GO:
                        ;
                        break;
                    case OVER:
                        break;
                    case STOP:
                        [self onClaimAreaState];
                        [self getArmor];
                        break;
                    default:
                        break;
                }
            } fillCallback:^(int x, int y) {
                CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];
                // Update the render texture
                [scratchableImage begin];
                
                // Limit drawing to the alpha channel
                glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
                revealSprite.position = ccp(x, y);
                [revealSprite visit];
                // Reset color mask
                glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
                [scratchableImage end];
                
                
                ;
            }];
            moves++;
        }
        
        CGPoint from = [[QXPlayers sharedPlayers] mainPlayerPosition];
        CGPoint to = from;
        
        // move the player with calculated moves.
        switch (dir) {
            case UP:
                to = ccpAdd([[QXPlayers sharedPlayers] mainPlayerPosition], CGPointMake(0, moves));
                break;
            case DOWN:
                to = ccpAdd([[QXPlayers sharedPlayers] mainPlayerPosition], CGPointMake(0, -moves));
                break;
            case LEFT:
                to = ccpAdd([[QXPlayers sharedPlayers] mainPlayerPosition], CGPointMake(-moves, 0));
                break;
            case RIGHT:
                to = ccpAdd([[QXPlayers sharedPlayers] mainPlayerPosition], CGPointMake(moves, 0));
                break;
            default:
                break;
        }
        
//        if (moves != 0) {
            [[QXPlayers sharedPlayers] moveFrom:frameDuration from:from to:to prevDirection:prevDirection direction:dir];
            prevDirection = dir;
//        }
}


- (void) getArmor
{
    
    /*
    if ((withArm1 == NO) && [[QXMap sharedMap] isFill:CGPointMake(frozenArmor.position.x, frozenArmor.position.y)]) {
        NSLog(@"武器1被围住！！");
        [frozenArmor removeFromParentAndCleanup:YES];
        withArm = YES;
        withArm1 = YES;
    //    [[QXPlayers sharedPlayers] fireFrozenMissile:self qixPosition:[qix qixSprite].position qixSize:[qix qixSprite].contentSize];
        //    [qix hitByArmor:GuidedMissile from:[QXPlayers sharedPlayers].mainPlayerPosition time:0];
    }
    */
    
    /*
    if((withArm2 == NO)&&[[QXMap sharedMap] isFill:CGPointMake(projectile2.position.x, projectile2.position.y)]) {
        
        //    NSLog(@"武器2被围住！！");
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCMenuItemImage *weapon2 = [CCMenuItemImage itemWithNormalImage:@"projectile.png" selectedImage:@"projectile.png" target:self selector:@selector(pressWeapon2:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems:weapon2, nil];
        menu.position = ccp(size.width-projectile2.contentSize.width - 10, size.height-projectile2.contentSize.height*2 - 10 - 280);
        [self addChild: menu z:3];
        [self removeChild: projectile2];
        
        withArm = YES;
        withArm2 = YES;
        
    }
     */
}
 



- (void) onClaimAreaState
{
    double percentage = (double)[[QXMap sharedMap] filledArea]  / (double)[[QXMap sharedMap] entireArea];
    double p = (double) [[QXMap sharedMap] newlyFilledArea] / (double) [[QXMap sharedMap] entireArea];
    [[QXMedalSystem sharedMedalSystem] invokeOnClaimingArea:p rewardCallback:^(enum QXMedalType, QXMedal *medal) {
        [medal displayMedal:self];
    }];
    [progressBar nitrogenAdd:(double)[[QXMap sharedMap] newlyFilledArea]  / (double)[[QXMap sharedMap] filledArea] ];
    score = percentage * 100;
    NSLog(@"score: %f", score);
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.###"];
    [labelScore setString:[NSString stringWithFormat:@"Score: %@%%", [fmt stringFromNumber:[NSNumber numberWithDouble:score]]]];
    id scaleL = [CCScaleTo actionWithDuration:0.4f scale:1.5f];
    id scaleB = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
    [labelScore runAction:[CCSequence actions:scaleL,scaleB, nil]];
    [self updatePhysicalWorld];
    [[QXGamePlay sharedGamePlay] win];
}

- (void) onCocosAndBoxPositionUpdate:(b2Body *)body
{
    NSString *value = (NSString *)body->GetUserData();
    
    if ([value isEqualToString:BODY_PLAYER]) {
        CGPoint point = [[QXPlayers sharedPlayers] mainPlayerPosition];
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                   point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([[QXPlayers sharedPlayers] mainPlayerRotation]);
        body->SetTransform(b2Position, b2Angle);
    } else if ([value isEqualToString:BODY_WALKER_NW]) {
        if ([nwWalker isActive]) {
            CGPoint point = [nwWalker qixSprite].position;
            
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([nwWalker qixSprite].rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([value isEqualToString:BODY_WALKER_NS]) {
        if ([nsWalker isActive]) {
            CGPoint point = [nsWalker qixSprite].position;
            
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([nsWalker qixSprite].rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    }
}

- (bool) onBox2dCollisionDetection:(b2Body *)body1 body2:(b2Body *)body2 toDestroy:(std::vector<b2Body *>)toDestroy
{
    NSString *valueA = (NSString *) body1->GetUserData();
    NSString *valueB = (NSString *) body2->GetUserData();
    
    if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_WALKER_NS]) || ([valueA isEqualToString:BODY_WALKER_NS] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with ns walker");
        playerCollideWithWalkerNS = true;
        return true;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_WALKER_NW]) || ([valueA isEqualToString:BODY_WALKER_NW] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with nw walker");
        playerCollideWithWalkerNW = true;
        return true;
    }
    return false;
}

- (void) afterBox2dCollisionDetetion
{
    if (playerCollideWithWalkerNS && playerCollideWithWalkerNW) {
        [[QXMedalSystem sharedMedalSystem] invokeOnKillWalker:2 rewardCallback:^(enum QXMedalType, QXMedal *medal) {
            [medal displayMedal:self];
            ;
        }];
    } else if (playerCollideWithWalkerNS || playerCollideWithWalkerNW) {
        [[QXMedalSystem sharedMedalSystem] invokeOnKillWalker:1 rewardCallback:^(enum QXMedalType, QXMedal *) {
            ;
        }];
    }
}

- (void) respawn
{
    [[QXTimerEffect sharedTimerEffect] displayCountDownTimer:CD_THREE layer:self position:ccp(mapWidth/2, mapHeight/2) onCompletion:^{
        NSLog(@"start respawning");
        [[QXPlayers sharedPlayers] reSpawn];
    }];
}

- (void) lose
{
    if (![[QXPlayers sharedPlayers] isInvincible]) {
        [[QXExplosion sharedExplosion] explode:EPLAYER layer:self position:[[QXPlayers sharedPlayers] mainPlayerPosition]];
        [[QXGamePlay sharedGamePlay] lose:^(bool isOver, int life) {
            [[QXMedalSystem sharedMedalSystem] invokeOnLoseLife:^(enum QXMedalType, QXMedal *medal) {
                [medal displayMedal:self];
            }];
            [self updateLifeIcons];
            if (!isOver) {
                [self respawn];
            }
        }];
    }
}

- (void) updateLifeIcons
{
    CCSprite *sprite = [lifeIcons objectAtIndex:[lifeIcons count] - 1];
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.5f],vanishAction,nil];
    [sprite runAction:sequence];
    [lifeIcons removeObjectAtIndex:[lifeIcons count] - 1];
}

- (void) displaySprite:(id) sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    NSLog(@"display sprite");
    bgSprite.opacity = 255;
}

-(void)removeSprite:(id)sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
}


- (NSString *)backgroundImagePath
{
    return @"sky.png";
}

- (NSString *)revealedImagePath
{
    return @"ground.png";
}

- (void) onDealloc
{
    delete _world;
    _world = NULL;
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
	// don't forget to call "super dealloc"
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
}

- (void) dealloc
{
    [self onDealloc];
    [super dealloc];
}

@end

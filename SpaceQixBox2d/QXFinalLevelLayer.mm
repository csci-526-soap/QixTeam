//
//  NewGameLayer.m
//  Cocos2dTest
//
//  Created by 李 彦霏 on 14-2-2.
//  Copyright 2014年 Xin ZHANG. All rights reserved.
//

#import "QXFinalLevelLayer.h"
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
#import "AppDelegate.h"
#include <stdlib.h>

NSMutableArray *missileTags;


/**************************/
int oneTimeCollisionListen = 0;
static int timerStart = 0;
static int timerStartCount=0;
/**************************/

const double fireDelayDuration = 2.0f;

const double weaponAttackDistance = 60.0f;

@implementation QXFinalLevelLayer

int prevDirection = NODIR;
// @synthesize beetle;
@synthesize myjoysitck;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QXFinalLevelLayer *layer = [QXFinalLevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark init

-(id) init
{
    if( (self=[super init] )) {
        
        
        NSLog(@"initialize the new game layer class");
        
        [self initVariables];
        
        [[CDAudioManager sharedManager] playBackgroundMusic:@"goonBG.mp3" loop:YES];

		CGSize size = [[CCDirector sharedDirector] winSize];
        mapWidth = size.width;
        mapHeight = size.height;

        withArm = NO;
        
        [self initAssets];
        
        [self initSpeedButton];
        
        [self initPhysicalWorld];
        
        [self initWalker];
        
        [self initPlayers];
        
        [self scheduleUpdate];
        
        self.touchEnabled = YES;
        
        [Timer instance];
	}
	return self;
}

-(void)reset
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];
    
    CCSprite *layerUp = [CCSprite spriteWithFile:@"sky.png"];

    layerUp.position = ccp( size.width * 0.5f , size.height * 0.5f );

    [scratchableImage begin];
    [layerUp visit];
    [scratchableImage end];
    
}

- (void) initVariables
{
    withArm1 = NO;
    withArm2 = NO;
    
    score = 0;
     mapWidth = 0;
     mapHeight = 0;
    
    [[QXGamePlay sharedGamePlay] setup];
    
    prevDirection = NODIR;
     t = 0;
     hit = 0;
     delay = 0;
     armtag = 0;
}

-(void)initAssets
{
    // initialize joy sticks
    myjoysitck=[CCJoyStick initWithBallRadius:25 MoveAreaRadius:40 isFollowTouch:NO isCanVisible:YES isAutoHide:NO hasAnimation:YES];
    [myjoysitck setBallTexture:@"hand_d_in.png"];
    [myjoysitck setDockTexture:@"hand_bottomd.png"];
    [myjoysitck setStickTexture:@"wall.png"];
    [myjoysitck setHitAreaWithRadius:50];
    myjoysitck.position=ccp(50,50);
    myjoysitck.delegate=self;
    [self addChild:myjoysitck];
    
    // initialize players
    pspeed = ccp(0,1);
    
    // Create a background image
    CCSprite *layerBottom = [CCSprite spriteWithFile:@"ground.png"];
    
    // position the label on the center of the screen
    layerBottom.position =  ccp( mapWidth * 0.5f , mapHeight * 0.5f );
    //layerBottom.rotation =90;
    // add the label as a child to this Layer
    [self addChild: layerBottom z:-2];
    
    CCRenderTexture *scratchableImage = [CCRenderTexture renderTextureWithWidth:mapWidth height:mapHeight];
    scratchableImage.position = ccp( mapWidth * 0.5f , mapHeight * 0.5f );
    [self addChild:scratchableImage z:-1 tag:SCRATCHABLE_IMAGE];
    [[scratchableImage sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
    
    // Source image
    [self reset];
    
    //Set up the burn sprite that will "knock out" parts of the darkness layer depending on the
    //alpha value of the pixels in the image.
    revealSprite = [CCSprite spriteWithFile:@"wall_c.png"];
    revealSprite.scale = 2.0;
    revealSprite.position = ccp( -10000, 0);
    [revealSprite setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [revealSprite retain];

    // weapons setup
    //projectile1 = [CCSprite spriteWithFile:@"projectile.png"];
    projectile2 = [CCSprite spriteWithFile:@"fireIcon.png"];
    [projectile2 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2 angle:360]]];
    
    
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"battery.plist"];
//    projectile1 = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
//    //sprite.anchorPoint = ccp(0,0);
//    projectile1.position = ccp(0,0);
//    CCSpriteBatchNode * batchNodeProjectile1 = [CCSpriteBatchNode batchNodeWithFile:@"battery.png"];
//    [batchNodeProjectile1 addChild:projectile1];
//    NSMutableArray * animFrames = [NSMutableArray array];
//    for(int i =0; i < 12; i++) {
//        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"battery%d.png", i]];
//        [animFrames addObject:frame];
//        
//    }
//    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
//    [projectile1 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    projectile1 = [CCSprite spriteWithFile:@"iceberg.png"];
    projectile1.scale = 0.7;
    projectile1.anchorPoint = ccp(0.5, 0);
//    projectile1 = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
    projectile1.position = ccp(mapWidth/2-projectile1.contentSize.width -80, mapHeight-projectile1.contentSize.height - 100);
    projectile2.position = ccp(mapWidth/2-projectile2.contentSize.width +200, mapHeight-projectile2.contentSize.height*2 - 200);
    [projectile1 runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCRotateTo actionWithDuration:1 angle:30] two:[CCRotateTo actionWithDuration:1 angle:-30]]]];
    
    [self addChild:projectile1];
    [self addChild:projectile2];
    
    
//    _monsters = [[NSMutableArray alloc] init];
    _weaponParticle = [[NSMutableArray alloc] init];

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
    
    explosion = [[QXExplosion alloc] init];
    [explosion setup];
}

- (void) initPhysicalWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f); //设置初始重力向量
    _world = new b2World(gravity);      //新建world对象
    
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
    
    [self addMonster];
}

- (void) initPlayers
{
    [[QXPlayers sharedPlayers] setup:self physicalWorld:_world userData:BODY_PLAYER];
    prevDirection = NODIR;
    CGPoint p =    [[QXPlayers sharedPlayers] mainPlayerPosition];
    NSLog(@"players position: %f, %f", p.x, p.y);
}

- (void) initWalker
{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"walker.plist"];
    CCSprite *blue = [CCSprite spriteWithSpriteFrameName:@"walker0.png"];
//    blue.scaleX = -blue.scaleX;
//    blue.rotation = 90;
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
    [progressBar highSpeedKeyDown];
}

-(void) revealMap
{
    CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];
    
    // Update the render texture
    [scratchableImage begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    //NSLog(@"glcolorMask");
    // Draw
    int (*arr)[960][640] = [[QXMap sharedMap] map];
    for (int i=0; i<mapWidth; i++) {
        for (int j=0; j<mapHeight; j++) {
            if ((*arr)[i][j] == 2) {
                revealSprite.position = ccp(i, j);
                [revealSprite visit];
                
            }
            
        }
    }
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    [scratchableImage end];
}

#pragma mark monster

- (void) addMonster {
    qix = [[QXQix alloc] init];
    [qix setUp:self physicalWorld:_world userData:BODY_QIX];
    guardQix1 = [[QXGuard alloc] init];
    [guardQix1 setup:ccp(100, 250) layer:self physicalWorld:_world userData:BODY_GUARD_1];
    guardQix2 = [[QXGuard alloc] init];
    [guardQix2 setup:ccp(400,150) layer:self physicalWorld:_world userData:BODY_GUARD_2];
    guardQix3 = [[QXGuard alloc] init];
    [guardQix3 setup:ccp(200, 80) layer:self physicalWorld:_world userData:BODY_GUARD_3];
    
    
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
            // update the sprite position to be consistency with box body location
            NSString *value = (NSString *)b->GetUserData();
            NSString *missileTag = @"";
            
            NSString *quickAutoMissileTag = @"";
            if( value.length > BODY_FIRE_ARMOR.length){
                quickAutoMissileTag = [value substringToIndex:BODY_FIRE_ARMOR.length];
            }
            if (value.length > BODY_SCATTERED_MISSILE_TAG.length) {
                missileTag = [value substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
            }
            
            if ([value isEqualToString:BODY_WORLD]) {
                
            } else if([value isEqualToString:BODY_QIX]) {
                CGPoint point = [qix qixSprite].position;
                
                b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([qix qixSprite].rotation);
                // Update the Box2D position/rotation to match the Cocos2D position/rotation
                b->SetTransform(b2Position, b2Angle);
                
            } else if ([value isEqualToString:BODY_PLAYER]) {
                CGPoint point = [[[QXPlayers sharedPlayers] mainPlayer] currentPoint];
                
                // Convert the Cocos2D position/rotation of the sprite to the Box2D position/rotation
                b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                           point.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([[[QXPlayers sharedPlayers] mainPlayer] image].rotation);
                
                // Update the Box2D position/rotation to match the Cocos2D position/rotation
                b->SetTransform(b2Position, b2Angle);
                
            } else if ([value isEqualToString:BODY_WALKER_NW]) {
                if ([nwWalker isActive]) {
                    CGPoint point = [nwWalker qixSprite].position;
                    
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([nwWalker qixSprite].rotation);
                    
                    b->SetTransform(b2Position, b2Angle);
                }
            } else if ([value isEqualToString:BODY_WALKER_NS]) {
                if ([nsWalker isActive]) {
                    CGPoint point = [nsWalker qixSprite].position;
                    
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([nsWalker qixSprite].rotation);
                    
                    b->SetTransform(b2Position, b2Angle);
                }
            } else if ([value isEqualToString:BODY_GUARD_1]) {
                if ([guardQix1 isActive]) {
                    CGPoint point = [guardQix1 qixSprite].position;
                    
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix1 qixSprite].rotation);
                    
                    b->SetTransform(b2Position, b2Angle);
                }
            } else if ([value isEqualToString:BODY_GUARD_2]) {
                if ([guardQix2 isActive]) {
                    CGPoint point = [guardQix2 qixSprite].position;
                    
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix2 qixSprite].rotation);
                    b->SetTransform(b2Position, b2Angle);
                }
            } else if ([value isEqualToString:BODY_GUARD_3]) {
                if ([guardQix3 isActive]) {
                    CGPoint point = [guardQix3 qixSprite].position;
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix3 qixSprite].rotation);
                    
                    b->SetTransform(b2Position, b2Angle);
                }
            } else if ([missileTag isEqualToString:BODY_SCATTERED_MISSILE_TAG]) {
                int index = [[value substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length] intValue];
                CCSprite *sprite = [[qix missile] missile:index];
                if (sprite != nil) {
                    CGPoint point = sprite.position;
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
                    b->SetTransform(b2Position, b2Angle);
                }
            } else if( [quickAutoMissileTag isEqualToString:BODY_FIRE_ARMOR] ){
                int index = [[value substringFromIndex:BODY_FIRE_ARMOR.length] intValue];
                CCSprite *sprite = [[[QXPlayers sharedPlayers] fireArmor] missile:index];
                if (sprite != nil) {
                    CGPoint point = sprite.position;
                    b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                               point.y/PTM_RATIO);
                    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
                    b->SetTransform(b2Position, b2Angle);
                }
            }

        }
    }
    
    // Loop through all of the box2d bodies that are currently colliding, that we have
    // gathered with our custom contact listener...
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    
    bool playerNSMonster = false;
    bool playerNWMonster = false;
    bool playerQix = false;
    bool playerSimpleQix1 = false;
    bool playerSimpleQix2 = false;
    bool playerSimpleQix3 = false;
    bool playerMissile = false;

    bool playQuickAutoMissileQix3 = false;
    bool playQuickAutoMissileQix2 = false;
    bool playQuickAutoMissileQix1 = false;
    bool playQuickAutoMissileQix = false;
    bool playerQuickAutoMissileNSMonster = false;
    bool playerQuickAutoMissileNWMonster = false;
    bool playerQuickAutoMissileQixMissile = false;
    
    for(pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        // Get the box2d bodies for each object
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        
        if (oneTimeCollisionListen == 0 && bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            NSString *valueA = (NSString *) bodyA->GetUserData();
            NSString *valueB = (NSString *) bodyB->GetUserData();
            NSString *mValueA = @"";
            NSString *mValueB = @"";

            NSString *nValueA = @"";
            NSString *nValueB = @"";
            
            if( valueA.length > BODY_FIRE_ARMOR.length){
                nValueA = [valueA substringToIndex:BODY_FIRE_ARMOR.length];
            }
            if( valueB.length > BODY_FIRE_ARMOR.length){
                nValueB = [valueB substringToIndex:BODY_FIRE_ARMOR.length];
            }
            
            if (valueA.length > BODY_SCATTERED_MISSILE_TAG.length) {
                mValueA = [valueA substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
            }
            if (valueB.length > BODY_SCATTERED_MISSILE_TAG.length) {
                mValueB = [valueB substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
            }
            
            if ((valueB.length > BODY_FIRE_ARMOR.length && [valueA isEqualToString:BODY_QIX] && [nValueB isEqualToString:BODY_FIRE_ARMOR]) || (valueA.length > BODY_FIRE_ARMOR.length && [nValueA isEqualToString:BODY_FIRE_ARMOR] && [valueB isEqualToString:BODY_QIX])) {
                playQuickAutoMissileQix = true;
                NSLog(@"quickAutoMissile collide with QIX");
            } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_WALKER_NS]) || ([valueA isEqualToString:BODY_WALKER_NS] && [valueB isEqualToString:BODY_PLAYER])) {
                NSLog(@"player collide with ns walker");
                oneTimeCollisionListen = 1;
                playerNSMonster = true;
            } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_WALKER_NW]) || ([valueA isEqualToString:BODY_WALKER_NW] && [valueB isEqualToString:BODY_PLAYER])) {
                NSLog(@"player collide with nw walker");
                oneTimeCollisionListen = 1;
                playerNWMonster = true;
            } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_QIX]) || ([valueA isEqualToString:BODY_QIX] && [valueB isEqualToString:BODY_PLAYER])) {
                NSLog(@"player collide with qix");
                oneTimeCollisionListen = 1;
                playerQix = true;
            } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_1]) || ([valueA isEqualToString:BODY_GUARD_1] && [valueB isEqualToString:BODY_PLAYER])) {
                NSLog(@"player collide with guard qix 1");
                oneTimeCollisionListen = 1;
                playerSimpleQix1 = true;
            } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_2]) || ([valueA isEqualToString:BODY_GUARD_2] && [valueB isEqualToString:BODY_PLAYER])) {
                NSLog(@"player collide with guard qix 2");
                oneTimeCollisionListen = 1;
                playerSimpleQix2 = true;
            } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_3]) || ([valueA isEqualToString:BODY_GUARD_3] && [valueB isEqualToString:BODY_PLAYER])) {
                NSLog(@"player collide with guard qix 3");
                oneTimeCollisionListen = 1;
                playerSimpleQix3= true;
            } else if (([valueA isEqualToString:BODY_WORLD] && [valueB isEqualToString:BODY_QIX]) || ([valueA isEqualToString:BODY_QIX] && [valueB isEqualToString:BODY_WORLD])) {
//                NSLog(@"qix collide with world");
//                if ([valueA isEqualToString:QIX]) {
//                    [qix stopAction];
//                } else if ([valueB isEqualToString:QIX]) {
//                    [qix stopAction];
//                }
            } else if (([valueA isEqualToString:BODY_PLAYER] && [mValueB isEqualToString:BODY_SCATTERED_MISSILE_TAG]) || ([mValueA isEqualToString:BODY_SCATTERED_MISSILE_TAG] && [valueB isEqualToString:BODY_PLAYER])) {
                playerMissile = true;
                oneTimeCollisionListen = 1;
//                toDestroy.push_back(bodyA);
//                toDestroy.push_back(bodyB);
            } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_GUARD_3] && [nValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([nValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_GUARD_3]) ) ) ){
                oneTimeCollisionListen = 1;
                playQuickAutoMissileQix3 = true;
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
                
                if(valueA.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                }else if(valueB.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                }
                
            } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_GUARD_2] && [nValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([nValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_GUARD_2]) ) ) ){
                oneTimeCollisionListen = 1;
                playQuickAutoMissileQix2= true;
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
                
                if(valueA.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                    
                }else if(valueB.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                }

            } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_GUARD_1] && [nValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([nValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_GUARD_1]) ) ) ){
                oneTimeCollisionListen = 1;
                playQuickAutoMissileQix1 = true;
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
                
                if(valueA.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    NSLog(@"collide with quickAutoMissile %d",temp2);
                   [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                
                } else if(valueB.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                }
     
            } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_WALKER_NS] && [nValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([nValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_WALKER_NS]) ) ) ){
                oneTimeCollisionListen = 1;
                playerQuickAutoMissileNSMonster = true;
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
                NSLog(@"quickAutoMissile collide with NSMonster");
                if(valueA.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                } else if(valueB.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                }
            }else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_WALKER_NW] && [nValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([nValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_WALKER_NW]) ) ) ){
                oneTimeCollisionListen = 1;
                playerQuickAutoMissileNWMonster = true;
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
                NSLog(@"quickAutoMissile collide with NWMonster");
                if(valueA.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                } else if(valueB.length > BODY_FIRE_ARMOR.length){
                    NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                }
            } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([mValueB isEqualToString:BODY_SCATTERED_MISSILE_TAG] && [nValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([nValueB isEqualToString:BODY_FIRE_ARMOR] && [mValueA isEqualToString:BODY_SCATTERED_MISSILE_TAG]) ) ) ){
                
                oneTimeCollisionListen = 1;
                playerQuickAutoMissileQixMissile = true;
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);
                if([nValueA isEqualToString:BODY_FIRE_ARMOR]){
                    int temp2 = [[valueA substringFromIndex:BODY_FIRE_ARMOR.length] intValue];
                    NSLog(@"A   collide with quickAutoMissile %d",temp2);
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                    temp2 = [[valueB substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length] intValue];
                    NSLog(@"A   collide with QixMissile %d",temp2);
                    [[qix missile] cleanUpSpecificMissile:temp2];
                } else if([nValueB isEqualToString:BODY_FIRE_ARMOR]){
                    NSString *temp1 = [valueB substringFromIndex:BODY_FIRE_ARMOR.length];
                    int temp2 = [temp1 intValue];
                    [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
                    temp1 = [valueA substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length];
                    temp2 = [temp1 intValue];
                    [[qix missile] cleanUpSpecificMissile:temp2];
                }
            }
        }
    }

    int killedGuards = 0;
    if (playerSimpleQix1) {
        killedGuards++;
    }
    if (playerSimpleQix2) {
        killedGuards++;
    }
    if (playerSimpleQix3) {
        killedGuards++;
    }

    if (killedGuards) {
        [[QXMedalSystem sharedMedalSystem] invokeOnKillGuardQix:killedGuards rewardCallback:^(enum QXMedalType, QXMedal *) {
            ;
        }];
    }
    
    if (playerSimpleQix2 || playerSimpleQix1 || playerQix || playerNWMonster || playerNSMonster || playerSimpleQix3 || playerMissile) {
            [self lose];
    }
    /************************************************************************************/
    
    if(playQuickAutoMissileQix1){
        [guardQix1 explosion];
    } else if(playQuickAutoMissileQix2){
        [guardQix2 explosion];
    } else if(playQuickAutoMissileQix3){
        [guardQix3 explosion];
    } else if(playerQuickAutoMissileNSMonster){
        [nsWalker explosion];
    } else if(playerQuickAutoMissileNWMonster){
        [nwWalker explosion];
    } else if(playerQuickAutoMissileQixMissile){
        [[[QXPlayers sharedPlayers] fireArmor] explode];
    }
    /************************************************************************************/
    
    
    // Loop through all of the box2d bodies we wnat to destroy...
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        _world->DestroyBody(body);
    }
    oneTimeCollisionListen = 0;
}

-(void)weaponParticleControl {
    
    double weaponVelo = 10.0;;
    double xposWeapon = sun.position.x;
    double yposWeapon = sun.position.y;
    double sx = [qix qixSprite].position.x - xposWeapon;
    double sy = [qix qixSprite].position.y - yposWeapon;
    double mode = sqrt(sx*sx + sy*sy);
    
    sx = sx/mode;
    sy = sy/mode;
    
    weaponParticleSpeed = ccp(sx*weaponVelo,sy*weaponVelo);
}

-(void)update:(ccTime)delta
{
    
    if(timerStart==1){
        timerStartCount = timerStartCount + 1;
        if(timerStartCount<151&&timerStartCount%30==0){
            [qix qixOpacityChange];
        }else if(timerStartCount==151){
            [qix hitByGlacierFrozenThenShaking];
        }else if(timerStartCount>=300){
            timerStart = 0;
            timerStartCount = 0;
            [qix hitByGlacierFrozenEnd:self];
        }
    }
    
    [[Timer instance] picturesDrivenEvent];

    if ([[QXGamePlay sharedGamePlay] isPlaying]) {
        
     
        
        double distancePlayerBtwMons = [QXMap distance:[QXPlayers sharedPlayers].mainPlayerPosition q:[qix qixSprite].position];
       
        if ([nwWalker isActive]) {
            [nwWalker takeAction:delta];
        }
        if ([nsWalker isActive]) {
            [nsWalker takeAction:delta];
        }
        if ([guardQix1 isActive]) {
            [guardQix1 takeAction:delta];
        }
        if ([guardQix2 isActive]) {
            [guardQix2 takeAction:delta];
        }
        if ([guardQix3 isActive]) {
            [guardQix3 takeAction:delta];
        }
        
        __block bool hitByArmor = false;
        
        if ([qix isActive]) {
            [qix takeAction:delta spawnMissile:^(bool isSpawning, bool startSpawning, int tag) {
                if (startSpawning) {
                    [[QXMedalSystem sharedMedalSystem] invokeOnQixEmitMissiles:^(enum QXMedalType, QXMedal *) {
                        ;
                    }];
                    // [missileTags removeAllObjects];
                    [[qix missile] cleanUpMissiles];
                }
                if (isSpawning) {
                    [qix fire:delta];
                }
            }];
        } else {
            [qix hitByArmor:GuidedMissile from:CGPointMake(-1, -1) time:delta];
        }
        
        // move player
        int xposp = [[QXPlayers sharedPlayers] mainPlayerPosition].x;
        int yposp = [[QXPlayers sharedPlayers] mainPlayerPosition].y;
    
        int dir = [self pcontrol:[[QXPlayers sharedPlayers] velocity]];
    
        /***********************************************************************************/
        if(dir!=NODIR && withArm2 == YES){
            [[QXPlayers sharedPlayers] fire:delta dir:prevDirection];
        }
        else{
            [[[QXPlayers sharedPlayers] fireArmor] cleanUpMissilesOutOfScreen];
            [[[QXPlayers sharedPlayers] fireArmor] cleanUpMissiles];
        }
        /***********************************************************************************/
        
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
                [[QXMap sharedMap] takeAction:nil qix:[qix qixSprite].position completion:^(bool fill, NSArray *collision, QXTraceState state) {
                    double newlyFilledArea = [[QXMap sharedMap] newlyFilledArea];
                    double entireArea = [[QXMap sharedMap] entireArea];
                    double filledArea = [[QXMap sharedMap] filledArea];
                    
                    switch (state) {
                        case START:
                            ;
                            break;
                        case GO:
                            ;
                            break;
                        case OVER:
                            break;
                        case STOP: {
                            [progressBar nitrogenAdd:newlyFilledArea/filledArea];
                            score = (filledArea/entireArea) * 100;
                            double p = newlyFilledArea / entireArea;
                            [[QXMedalSystem sharedMedalSystem] invokeOnClaimingArea:p rewardCallback:^(enum QXMedalType, QXMedal *medal) {
                                [medal displayMedal:self];
                            }];
                            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                            [fmt setPositiveFormat:@"0.###"];
                            [labelScore setString:[NSString stringWithFormat:@"Score: %@%%", [fmt stringFromNumber:[NSNumber numberWithDouble:score]]]];
                            id scaleL = [CCScaleTo actionWithDuration:0.4f scale:1.5f];
                            id scaleB = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
                            [labelScore runAction:[CCSequence actions:scaleL,scaleB, nil]];
                            [self getArmor];
                            [self updatePhysicalWorld];
                            [[QXGamePlay sharedGamePlay] win];
                        }
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
            
//            if (moves != 0) {
                [[QXPlayers sharedPlayers] moveFrom:delta from:from to:to prevDirection:prevDirection direction:dir];
                prevDirection = dir;
//            }
    
        [self b2update:delta];
        
        if (hitByArmor) {
            [self lose];
        }
        
        if([[QXGamePlay sharedGamePlay] isLose] || [[QXMap sharedMap] isGameOver]) {
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
            
            [qix clear];
        } else if([[QXGamePlay sharedGamePlay] isWin]) {
             [[QXMap sharedMap]clearArea];
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
        } else {
            
            for(CCNode * weapon in _weaponParticle) {
                if (distancePlayerBtwMons < weaponAttackDistance) {
                    hit = 1;
                    armtag = weapon.tag;
                    NSLog(@"arm tag %d", weapon.tag);
                }
            }

            if(hit == 1) {
                if(armtag == 2 && delay < 1) {
                    NSLog(@"hit by sun");
                    sun = [[CCParticleSun alloc] init];
                    [self addChild:sun];
                    sun.tag = 2;
                    sun.position = ccp([QXPlayers sharedPlayers].mainPlayerPosition.x, [QXPlayers sharedPlayers].mainPlayerPosition.y);
                  //  sun.emissionRate = 10;
                  /*  [sun runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.5f position:[qix qixSprite].position], [CCCallFuncN actionWithTarget:self selector:@selector(removeFire:)],nil]];
                   */
                    delay = fireDelayDuration;
                } else if(armtag == 1 && delay < 1){
                    delay = fireDelayDuration;
                }
                hit = 0;
                delay -= delta;
            }
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


- (void) lose
{
    if (![[QXPlayers sharedPlayers] isInvincible]) {
        [[QXExplosion sharedExplosion] explode:EPLAYER layer:self position:[[QXPlayers sharedPlayers] mainPlayerPosition]];
        [self updateLifeIcons];
        [[QXGamePlay sharedGamePlay] lose:^(bool isOver, int life) {
            [[QXMedalSystem sharedMedalSystem] invokeOnLoseLife:^(enum QXMedalType, QXMedal *medal) {
                [medal displayMedal:self];
            }];
            if (!isOver) {
                [self respawn];
            }
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

- (void) fillPolygon:(NSArray *)poly
{
    
    CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];
    
    // Update the render texture
    [scratchableImage begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempFillArray = [[NSMutableArray alloc] init];
    
    // scan line
    for (int h = 0; h < mapHeight; h++) {
        
        // find intersection points of polygon at line h
        for (int i = 0; i < [poly count]; i++) {
            CGPoint p = [[poly objectAtIndex:i] CGPointValue];
            if (p.y == h) {
                [tempFillArray addObject:[poly objectAtIndex:i]];
            }
        }
        
        // adjust the filled array for polygon
        fillArray = [[QXMap sharedMap] haoyu:fillArray tempFilledSpace:tempFillArray];
        
        // update area
        for (int i = 0; i < [fillArray count]; i+=2) {
            CGPoint p = [[fillArray objectAtIndex:i] CGPointValue];
            CGPoint q = [[fillArray objectAtIndex:i+1] CGPointValue];
            p.y = h;
            q.y = h;
            for (int x =p.x; x <= q.x; x++) {
                
            }

        }
        // clean
        [tempFillArray removeAllObjects];
    }
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    [scratchableImage end];
}

#pragma mark - explosion effect

- (void) runEffectAtPosition:(CGPoint)position
{
	CCEmitterNode *effectEmitter;
	switch(effectIndex) {
            
		case 0:
			effectEmitter = [CCParticleEffectGenerator getExperimentEffectEmitter];
			break;
        case 1:
			effectEmitter = [CCParticleEffectGenerator getFlareEffectEmitter];
			break;
        defaule:
			NSAssert(NO, @"Invalid effect index.");
			break;
	}
	NSAssert(effectEmitter != nil, @"CCEmitterNode is nil.");
    effectEmitter.position = position;
	[self addChild:effectEmitter z:1];
}


- (void) runShakeScreenEffect
{
    [self runAction:[CCShake actionWithDuration:2.0f
                                      amplitude:ccp(5 + CCRANDOM_0_1() * 5, 5 + CCRANDOM_0_1() * 5)
                                      dampening:YES]];
}

#pragma mark armor




- (void) getArmor
{
    if ((withArm1 == NO) && [[QXMap sharedMap] isFill:CGPointMake(projectile1.position.x, projectile1.position.y)]) {
        NSLog(@"武器1被围住！！");
        [projectile1 removeFromParentAndCleanup:YES];
        withArm = YES;
        withArm1 = YES;
        [[QXPlayers sharedPlayers] fireFrozenMissile:self qixPosition:[qix qixSprite].position qixSize:[qix qixSprite].contentSize];
    //    [qix hitByArmor:GuidedMissile from:[QXPlayers sharedPlayers].mainPlayerPosition time:0];
    }

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
}

#pragma mark joystick

- (void) onCCJoyStickUpdate:(CCNode*)sender Angle:(float)angle Direction:(CGPoint)direction Power:(float)power
{
    cgPoint = direction;
}

-(int)pcontrol:(double)playvelo
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

-(void) back: (id) sender{
    
    /*****************************/
    oneTimeCollisionListen = 0;
    timerStart = 0;
    timerStartCount=0;
    /*****************************/
    [[QXGamePlay sharedGamePlay] reset];
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QXMenuLayer scene] ]];
    [QXSceneManager goMenu];
}

-(void) nextlevel: (id) sender{
    [[QXGamePlay sharedGamePlay] reset];
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QXMenuLayer scene] ]];
    [QXSceneManager goLevel1];
}


-(void) again: (id) sender {
    /*****************************/
    oneTimeCollisionListen = 0;
    timerStart = 0;
    timerStartCount=0;
    /*****************************/
    [[QXGamePlay sharedGamePlay] reset];
    _weaponParticle = nil;
    [_weaponParticle release];
	delete _world;
    _world = NULL;
    [qix clear];
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QXMenuLayer scene] ]];
    [QXSceneManager goNewGame];
}






/*************** sender is from QXPlayers.mm function ****************/

-(void)removeGlacierFrozen:(id)sender
{
   
    [self generateUnderDust];
    [self runShakeScreenEffect];
    [qix hitByGlacierFrozen];
    timerStart = 1;
    NSLog(@"timer START!");
    
    if([qix isActive]){
        NSLog(@"QIX is active");
    }else{
        NSLog(@"QIX is not active");
    }
}

- (void) generateUnderDust
{
 
    
    [[CDAudioManager sharedManager].soundEngine playSound:SND_DRP
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    //*******************underDust*********************
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dustUnder.plist"];
    
    CCSprite *dustUnder = [CCSprite spriteWithSpriteFrameName:@"dust0.png"];
    
    dustUnder.anchorPoint = ccp(0.1,0.2);
    
    dustUnder.position = ccpAdd([qix qixSprite].position, ccp(-6, -10));
    
    CCSpriteBatchNode * batchNodeDustUnder = [CCSpriteBatchNode batchNodeWithFile:@"dustUnder.png"];
    
    [batchNodeDustUnder addChild:dustUnder];
    
    [self addChild:batchNodeDustUnder];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 11; i++) {
        
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dust%d.png", i]];
        
        [animFrames addObject:frame];
        
        
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    
    [dustUnder runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
    
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeDustUnder:)];
    
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
    
    [dustUnder runAction:sequence];
    //*************************************************
}

- (void) updateLifeIcons
{
    CCSprite *sprite = [lifeIcons objectAtIndex:[lifeIcons count] - 1];
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeDustUnder:)];
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.5f],vanishAction,nil];
    [sprite runAction:sequence];
    [lifeIcons removeObjectAtIndex:[lifeIcons count] - 1];
}

-(void)removeDustUnder:(id)sender

{
    
    CCSprite *bgSprite = (CCSprite *)sender;
    
    [bgSprite removeFromParentAndCleanup:YES];
    
}


- (void) removeFire:(id)sender
{
    CCParticleSun *fire = (CCParticleSun *)sender;
    [fire removeFromParentAndCleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    _weaponParticle = nil;
    [_weaponParticle release];
	 delete _world;
    _world = NULL;
        [qix clear];
    if (progressBar) {
        [progressBar removeFromSuperview];
    }
	// don't forget to call "super dealloc"
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
	[super dealloc];
}



@end

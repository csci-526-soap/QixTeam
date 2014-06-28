//
//  HelloWorldLayer.m
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright Xin ZHANG 2014. All rights reserved.
//


// Import the interfaces
#import "QXMenuLayer.h"
#import "QXSceneManager.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "CCScrollLayer.h"
#import "CCScrollLayerTestLayer.h"
#import "QXlayer_x.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"


#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation QXMenuLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QXMenuLayer *layer = [QXMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    
    self = [super init];
    
    self.isTouchEnabled = YES;
    
    rotateAngel = 0;
    [[QXGamePlay sharedGamePlay] readConfig];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
//    [[CDAudioManager sharedManager] playBackgroundMusic:@"bgmusic.mp3" loop:YES];
    
    // ---------------- node on layer1 -----------------
    layer1 = [CCLayer node];
    
    // Create a background image
    layerBack = [CCSprite spriteWithFile:@"space.png"];
    layerBack.anchorPoint = ccp(0,0.05);
    
    // layerBack.position =  ccp( size.width * 0.5f , size.height * 0.5f );
    [layer1 addChild: layerBack]; //---------> selfToLayer
    
    
    CCMenuItemImage *startNew = [CCMenuItemImage itemWithNormalImage:@"star0.png" selectedImage:@"star0.png" disabledImage:@"star0bw.png" target:self selector:@selector(Level1:)];
    startNew.position = ccp(120,200);
    
 //   CCParticleFlower *sun = [[CCParticleFlower alloc]init];
    
   // [layer1 addChild:sun];
  //  sun.scale = 1;
  //  sun.position = ccp(120,200);
   // sun.emissionRate = 40;
    
   // CCParticleFlower *sun1 = [[CCParticleFlower alloc]init];
    
   // [layer1 addChild:sun1];
   // sun1.scale = 1.5;
  //  sun1.position = ccp(300,100);
  //  sun1.emissionRate = 40;
    
  //  CCParticleFlower *sun2 = [[CCParticleFlower alloc]init];
    
   // [layer1 addChild:sun2];
   // sun2.scale = 1;
   // sun2.position = ccp(480,210);
  //  sun2.emissionRate = 40;
    
    
  //  CCParticleFlower *sun3 = [[CCParticleFlower alloc]init];
    
   // [layer1 addChild:sun3];
   // sun3.scale = 1;
   // sun3.position = ccp(700,160);
  //  sun3.emissionRate = 40;
    
    CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"star1.png" selectedImage:@"star1.png" disabledImage:@"star1bw.png" target:self selector:@selector(Level2:)];
    level1.position = ccp(300,100);
    if ([[QXGamePlay sharedGamePlay] unlockedLevel] < 2) {
        [level1 setIsEnabled:false];
    }
    CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"star2.png" selectedImage:@"star2.png" disabledImage:@"star2bw.png" target:self selector:@selector(Level3:)];
    level2.position = ccp(480,210);
    if ([[QXGamePlay sharedGamePlay] unlockedLevel] < 3) {
        [level2 setIsEnabled:false];
    }
    
    CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"star3.png" selectedImage:@"star3.png" disabledImage:@"star3bw.png" target:self selector:@selector(Level4:)];
    level3.position = ccp(700,160);
    level3.rotation = 20;
    if ([[QXGamePlay sharedGamePlay] unlockedLevel] < 4) {
        [level3 setIsEnabled:false];
    }

    specialAngle = 0;
    CCMenu *menu = [CCMenu menuWithItems:startNew, level1, level2, level3, Nil];
    menu.position = CGPointZero;
    
    airplane = [CCSprite spriteWithFile:@"NBplane0.png"];
    airplane.scale = 0.1;
    airplane.position = ccp(200,200);
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"drillPlane.plist"];
    airplane2 = [CCSprite spriteWithSpriteFrameName:@"drillPlane0.png"];
    //sprite.anchorPoint = ccp(0,0);
    airplane2.position = ccp(200,200);
    airplane2.scale = 0.8;
    CCSpriteBatchNode * batchNodeProjectile1 = [CCSpriteBatchNode batchNodeWithFile:@"drillPlane.png"];
    [batchNodeProjectile1 addChild:airplane2];
    NSMutableArray * animFrames = [NSMutableArray array];
    for(int i =0; i < 96; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"drillPlane%d.png", i]];
        [animFrames addObject:frame];
        
    }
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [airplane2 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    //airplane2 = [CCSprite spriteWithFile:@"NBplane0.png"];
    //airplane2.scale = 0.1;
    //airplane2.position = ccp(200,200);
    [layer1 addChild:batchNodeProjectile1];
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"plane.plist"];
    airplane3 = [CCSprite spriteWithSpriteFrameName:@"plane0.png"];
    //sprite.anchorPoint = ccp(0,0);
    airplane3.position = ccp(200,200);
    airplane3.scale = 0.3;
    CCSpriteBatchNode * batchNodeProjectile = [CCSpriteBatchNode batchNodeWithFile:@"plane.png"];
    [batchNodeProjectile addChild:airplane3];
    NSMutableArray * animFrames1 = [NSMutableArray array];
    for(int i =0; i < 2; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"plane%d.png", i]];
        [animFrames addObject:frame];
        
    }
    CCAnimation * animation1 = [CCAnimation animationWithSpriteFrames:animFrames1 delay:0.05f];
    [airplane2 runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation1]]];
    
    //airplane3 = [CCSprite spriteWithFile:@"plane.png"];
    //airplane3.scale = 0.5;
    //airplane3.position = ccp(200,200);
    [layer1 addChild:batchNodeProjectile];
    
    [layer1 addChild:menu];
    [layer1 addChild:airplane];
    [self scheduleUpdate];
    
    // ---------------- node on layer1 -----------------
    layer2 = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
    
    CCSprite *shopimg = [CCSprite spriteWithFile:@"back.png"];
    CCSprite *shopsimg = [CCSprite spriteWithFile:@"backpress.png"];
    CCSprite *shopdimg = [CCSprite spriteWithFile:@"back.png"];
    
    CCSprite *titleCenterTop = [CCSprite spriteWithFile:@"qixmustdie.png"];
    titleCenterTop.position = ccp(280, 280);
    
    CCMenuItemSprite *shopZone = [CCMenuItemSprite itemWithNormalSprite:shopimg selectedSprite:shopsimg disabledSprite:shopdimg target:self selector:@selector(goShopping:)];
    
    CCMenu *setmenu = [CCMenu menuWithItems:shopZone, Nil];
    setmenu.position = ccp(530, 20);

    [layer2 addChild: titleCenterTop];
    [layer2 addChild: setmenu];
    
    // ---------------- add layers -----------------
    [self addChild: layer1 z:0];
    [self addChild:layer2 z:2];
    
    return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}
-(void) update:(ccTime)delta{
    
    airplane.position = ccp(120+70*sin(rotateAngel),200+70*cos(rotateAngel));
    airplane.rotation =   rotateAngel*180/3.14 -90;
    
    airplane2.position = ccp(300+100*cos(rotateAngel),100+110*sin(rotateAngel));
    airplane2.rotation = -rotateAngel*180/3.14;
   
    
    if(specialAngle<360){
        
        airplane3.position = ccp(480+70*cos(CC_DEGREES_TO_RADIANS(specialAngle)),210+70*sin(CC_DEGREES_TO_RADIANS(specialAngle)));
        airplane3.rotation = -specialAngle ;
        specialAngle++;
    }
    else if(specialAngle==360){
        NSLog(@"get into move");
        [airplane3 runAction: [CCMoveTo actionWithDuration:3.0f position:ccp(700+110*sin(CC_DEGREES_TO_RADIANS(specialAngle)),160+110*cos(CC_DEGREES_TO_RADIANS(specialAngle)))]];
        
    }
    else if(specialAngle>360 && specialAngle<720){
        
        airplane3.position = ccp(700+110*sin(CC_DEGREES_TO_RADIANS(specialAngle)),160+110*cos(CC_DEGREES_TO_RADIANS(specialAngle)));
        airplane3.rotation = specialAngle+90;
        
        specialAngle++;
        //NSLog(@"%f",specialAngle);
    }
    else if(specialAngle > 720){
        
        specialAngle = 0;
    }
    
   
    
    
    
    specialAngle +=0.01;
     rotateAngel+=0.01;
    
    
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onNewGame:(id)sender{

    [[CDAudioManager sharedManager] stopBackgroundMusic];
    
    [QXSceneManager goNewGame];
    
}

//-(void)onXlayer:(id)sender{
//    
//    [[CDAudioManager sharedManager] stopBackgroundMusic];
//    
//    [QXSceneManager xLayer];
//    
//}

-(void)goShopping:(id)sender{
    
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    
    [QXSceneManager goMainLayer];
    
}

- (CGPoint)boundLayerPos:(CGPoint)newPos{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -layerBack.contentSize.width+winSize.width+120);
    retval.y = layer1.position.y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint newPos = ccpAdd(layer1.position, translation);
    layer1.position = [self boundLayerPos:newPos];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [layer1 convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [layer1 convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

-(void)Level1:(id)sender
{
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goLevel1];
}

-(void)Level2:(id) sender
{
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goLevel2];
}

-(void)Level3:(id) sender
{
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goLevel3];
}

-(void)Level4:(id) sender{
    
   [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goLevel4];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [self unscheduleUpdate];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
	[super dealloc];
}



@end

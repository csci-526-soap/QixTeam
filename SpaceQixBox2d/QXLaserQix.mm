//

//  QXLaserQix.m

//  SpaceQix

//

//  Created by Student on 4/6/14.

//  Copyright (c) 2014 HaoyuHuang. All rights reserved.

//



#import "QXLaserQix.h"
#import "QXMap.h"
#import "QXPlayers.h"
#import "QXMonster.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"

@implementation QXLaserQix

int startRotation = 0;

int durationTime = 0;

double angel = 0;

// change behavior interval
const double changeBehaviorInterval = 2.0f;

//// move duration
const double moveDuration = 2.0f;


//// maximum move step
const int maxStep = 100;
const int interval = 10;

//// upper-right, bottom-right, bottom-left, upper-left
const int diagonalX[] = {1,1,-1,-1};
const int diagonalY[] = {1,-1,-1,1};
CGPoint laTarget = ccp(-1,-1);

NSMutableArray * animFrames3;
CCAnimation * animation3;


- (void) config:(QXBaseAttribute *)attribute
{
    QXQixAttribute *attr = (QXQixAttribute *)attribute;
}


- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data :(CCLayer *) GameScene
{
   [super setUp:layer physicalWorld:world];

    mainScene = GameScene;
    type = Qix;
    changeBehaviorIntervalStep = 0;
    missleFireStep = 0;
    moveIntervalStep = 0;
    alertMoveStep = 0;
    isActive = true;
    startSpawning = false;
    isSpawning = false;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"jellyFish.plist"];
    _qixMonster = [CCSprite spriteWithSpriteFrameName:@"jellyFish1.png"];
    //sprite.anchorPoint = ccp(0,0);
    _qixMonster.position = ccp(280,160);
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"jellyFish.png"];
    [batchNode addChild:_qixMonster];
    [layer addChild:batchNode];
    animFrames3 = [[NSMutableArray alloc] init] ;
    
    
    for(int i =1; i < 19; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"jellyFish%d.png", i]];
        [animFrames3 addObject:frame];
    }

    animation3 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.05f];
    [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation3]]];
    
    NSLog(@"qix size %f %f", _qixMonster.position.x, _qixMonster.position.y);
    
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"jellyFishBody.plist"];
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"beamBox.plist"]; 
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(_qixMonster.position.x/PTM_RATIO, _qixMonster.position.y/PTM_RATIO);
    bodyDef.userData = data;
    _qixMonsterBody = world->CreateBody(&bodyDef);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_qixMonsterBody forShapeName:@"jellyFishBody"];
    [_qixMonster setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"jellyFishBody"]];
    
    laser = [[QXLaser alloc] init];
    [laser setup:layer physicalWorld:world];
}

- (void) takeAction:(ccTime)time spawnMissile:(void (^)(bool, bool, int))spawnMissile
{
    changeBehaviorIntervalStep += time;
    moveIntervalStep += time;
    
    if ((changeBehaviorIntervalStep >= changeBehaviorInterval)) {
        isSpawning = true;
        if (spawnMissile) {
            spawnMissile(true, startSpawning, -1);
        }
        if (startSpawning) {
            startSpawning = false;
        }
        return;
    }
    startSpawning = true;
//    isSpawning = false;
    if ((moveIntervalStep >= moveDuration)) {
        moveIntervalStep = 0;
        CGPoint nextMove = [self nextMove:_qixMonster.position targetPosition:laTarget];
        laTarget = nextMove;
        moveAction = [CCMoveTo actionWithDuration:moveDuration position:laTarget];
        [_qixMonster runAction:moveAction];
    }
}

- (CGPoint) nextMove:(CGPoint) currentPosition targetPosition:(CGPoint) target
{
    int step = 0;
    int x = currentPosition.x;
    int y = currentPosition.y;
    
    int totoalTrial = 100;
    int trial = 0;
    
    while (step == 0 && trial < totoalTrial) {
        trial++;
        int randomDirection = arc4random() % 4;
        x = diagonalX[randomDirection];
        y = diagonalY[randomDirection];
        for (step = maxStep; step > 0; step -= interval) {
            CGPoint p = CGPointMake(currentPosition.x + x*step - [_qixMonster boundingBox].size.width/2, currentPosition.y + y*step - [_qixMonster boundingBox].size.height/2);
            if ([[QXMap sharedMap] isSpace:p] || [[QXMap sharedMap] isTrace:p]) {
                return p;
            }
        }
    }
    return CGPointMake(-1, -1);
}

- (double) distance:(CGPoint) p q:(CGPoint)q
{
    return sqrt((p.x-q.x)*(p.x-q.x) + (p.y - q.y)*(p.y - q.y));
}

- (CGPoint) position
{
    return _qixMonster.position;
}

- (void) fire:(ccTime)delta {
    [laser fire:delta fromPosition:ccp(-1,-1) target:ccp(-1,-1) direction:NODIR fireStop:^(int armorIndex) {
        changeBehaviorIntervalStep = 0;
        isActive = true;
        isSpawning = false;
    }];
}




/*************************************/

- (void) hitByGlacierFrozen
{
    [_qixMonster stopAllActions];
   // [_qixMonster stopAction:moveAction];
    isActive = false;
    NSLog(@"Laser should stop all actions");
}

- (void) hitByGlacierFrozenEnd:(CCLayer*)layer
{
    _layer = layer;
    [[[QXPlayers sharedPlayers] frozenMissileSprite ] removeFromParentAndCleanup:YES];
    isActive = true;
    
   // animation3 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.05f];
   // [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation3]]];
    
    [self iceExplode:layer];
    
}


-(void)iceExplode:(CCLayer*)layer
{

    [[CDAudioManager sharedManager].soundEngine playSound:SND_BRK
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"iceExplode.plist"];
    
    CCSprite *dustUnder = [CCSprite spriteWithSpriteFrameName:@"iceExplode0.png"];
    
    dustUnder.anchorPoint = ccp(0.5,0.5);
    dustUnder.scale = 4;
    
    dustUnder.position = ccpAdd(_qixMonster.position, ccp(45, 35));
    
    CCSpriteBatchNode * batchNodeDustUnder = [CCSpriteBatchNode batchNodeWithFile:@"iceExplode.png"];
    
    [batchNodeDustUnder addChild:dustUnder];
    
    [layer addChild:batchNodeDustUnder];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 17; i++) {
        
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"iceExplode%d.png", i]];
        
        [animFrames addObject:frame];
        
        
        
    }
    
    CCAnimation * animation2 = [CCAnimation animationWithSpriteFrames:animFrames delay:0.09f];
    
    [dustUnder runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation2] times:1]];
    
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeIceExplode:)];
    
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
    
    [dustUnder runAction:sequence];
    
    
}

-(void)removeIceExplode:(id)sender

{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
    [_qixMonster stopAllActions];
    isActive = true;

}


- (void) qixOpacityChange
{
    [[QXPlayers sharedPlayers] frozenMissileSprite].opacity = [[QXPlayers sharedPlayers] frozenMissileSprite].opacity - 20;
}



- (QXArmor *) armor
{
    return laser;
}

- (bool) isSpawningFire
{
    return isSpawning;
}
@end

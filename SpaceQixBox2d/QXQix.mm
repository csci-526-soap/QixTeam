//
//  QXQix.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/21/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXQix.h"
#import "QXMap.h"
#import "QXPlayers.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"

@implementation QXQix

// maximum move step
const int interval = 10;

// upper-right, bottom-right, bottom-left, upper-left
const int diagonalX[] = {-1,1,1,-1};
const int diagonalY[] = {1,1,-1,-1};


CGPoint target = CGPointMake(-1, -1);
NSMutableArray * animFrames;
CCAnimation * animation;

- (void) config:(QXBaseAttribute *)attribute
{
    _attribute = (QXQixAttribute *) attribute;
    
}

- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data
{
    type = Qix;
    [super setUp:layer physicalWorld:world];
    changeBehaviorIntervalStep = 0;

    moveIntervalStep = 0;
    alertMoveStep = 0;
    isActive = true;
    startSpawning = false;
    
    _attribute = [[QXQixAttribute alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithDouble:2.0f] forKey:KEY_CRAB_MECHA_MOVE_DURATION];
    [dict setValue:[NSNumber numberWithInt:100] forKey:KEY_CRAB_MECHA_MOVE_MAX_STEP];
    [dict setValue:[NSNumber numberWithDouble:5.0f] forKey:KEY_CRAB_MECHA_FIRE_INTERVAL];
    [_attribute build:dict];
    
    missile = [[QXScatteredMissile alloc] init];
    [missile setup:_layer physicalWorld:_world];
    
    
    //*******animation*********
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"monster_1.plist"];
    _qixMonster = [CCSprite spriteWithSpriteFrameName:@"monster1.png"];
    //sprite.anchorPoint = ccp(0,0);
    _qixMonster.position = ccp(280,160);
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"monster_1.png"];
    [batchNode addChild:_qixMonster];
    [layer addChild:batchNode];
    animFrames = [[NSMutableArray alloc] init];
    
    for(int i =1; i < 30; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"monster%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    //************************
    
    target = _qixMonster.position;
    
    NSLog(@"qix size %f %f", _qixMonster.position.x, _qixMonster.position.y);
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"qixBody.plist"];
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"missileBody.plist"];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(_qixMonster.position.x/PTM_RATIO, _qixMonster.position.y/PTM_RATIO);
    bodyDef.userData = data;
    _qixMonsterBody = world->CreateBody(&bodyDef);
    
    [[GB2ShapeCache sharedShapeCache]
     addFixturesToBody:_qixMonsterBody forShapeName:@"qixBody"];
    [_qixMonster setAnchorPoint:[
                            [GB2ShapeCache sharedShapeCache]
                            anchorPointForShape:@"qixBody"]];
}

- (void) takeAction:(ccTime) time spawnMissile:(void (^)(bool,bool, int))spawnMissile
{
    changeBehaviorIntervalStep += time;
    moveIntervalStep += time;
    if (changeBehaviorIntervalStep >= [_attribute fireInterval]) {
        // change behavior
        [_qixMonster stopAllActions];
       
        if (spawnMissile) {
            spawnMissile(true, startSpawning, [missile currentArmorIndex]);
            animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
            [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
        }
        if (startSpawning) {
            startSpawning = false;
        }
        return;
    }
    
    startSpawning = true;
    [missile cleanUpMissilesOutOfScreen];
    if (moveIntervalStep >= [_attribute moveDuration]) {
        moveIntervalStep = 0;
        CGPoint nextMove = [self nextMove:_qixMonster.position targetPosition:target];
        if (nextMove.x != -1 && nextMove.y != -1) {
            target = nextMove;
            moveAction = [CCMoveTo actionWithDuration:[_attribute moveDuration] position:target];
            [moveAction setTag:ACTION_RANDOM_MOVE];
            [_qixMonster runAction:moveAction];
        }
    }
}

- (void) stopAction
{
    if (moveAction) {
        [_qixMonster stopActionByTag:ACTION_RANDOM_MOVE];
        int dir = (runDirection + 2) % 4;
//        NSLog(@"change direction: %d", dir);
        CGPoint p = ccp(_qixMonster.position.x + 2*diagonalX[dir], _qixMonster.position.y + 2*diagonalY[dir]);
        _qixMonster.position = p;
//        NSLog(@"change position: %f, %f", p.x, p.y);
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
        for (step = [_attribute moveMaxStep]; step > 0; step -= interval) {
            CGPoint p = CGPointMake(currentPosition.x + x*step, currentPosition.y + y*step);
            if ([[QXMap sharedMap] isSpace:p] || [[QXMap sharedMap] isTrace:p]) {
                runDirection = randomDirection;
//                NSLog(@"run direction: %d", runDirection);
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

- (void) clear
{
    changeBehaviorIntervalStep = 0;
    moveIntervalStep = 0;
    alertMoveStep = 0;
    moveAction = nil;
    [[missile armors] removeAllObjects];
}

- (void) hitByArmor:(enum QXArmorType)type from:(CGPoint)from time:(ccTime)time
{
    isActive = false;
    hitByArmorStep += time;
    /*
    if (hitByArmorStep == 0) {
        switch (type) {
            case FireArmor:
                // hit by fire armor
                
                break;
            case ScatteredMissile:
                // hit by scattered missile
                
                break;
            case GuidedMissile: {
                // hit by guided missile
                double stepX = _qixMonster.position.x - from.x;
                double stepY = _qixMonster.position.y - from.y;
                CGPoint to = CGPointMake(_qixMonster.position.x + stepX/hitRatio, _qixMonster.position.y + stepY/hitRatio);
                [_qixMonster runAction:[CCMoveTo actionWithDuration:hitEffectDuration position:to]];
                }
                break;
            default:
                break;
        }
    } else if (hitByArmorStep > hitByArmorInterval) {
        hitByArmorStep = 0;
        isActive = true;
    }
     */
}

- (QXScatteredMissile *) missile
{
    return missile;
}

- (QXQixAttribute *)attribute
{
    return _attribute;
}

- (CGPoint) position
{
    return _qixMonster.position;
}

- (void) fire:(ccTime)delta
{
    [missile fire:delta fromPosition:ccp(_qixMonster.position.x + _qixMonster.contentSize.width/2, _qixMonster.position.y+_qixMonster.contentSize.height/2) target:ccp(-1, -1) direction:NODIR fireStop:^(int armorIndex) {
        changeBehaviorIntervalStep = 0;
    }];
}

/*************************************/
- (void) hitByGlacierFrozen
{
    [_qixMonster stopAllActions];
     isActive = false;
}

- (void) hitByGlacierFrozenEnd:(CCLayer*)layer
{
    _layer = layer;
    [[[QXPlayers sharedPlayers] frozenMissileSprite ] removeFromParentAndCleanup:YES];
    isActive = true;
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




- (void) hitByGlacierFrozenThenShaking
{

    float currentPointX;
    float currentPointY;
    currentPointX = _qixMonster.position.x;
    currentPointY = _qixMonster.position.y;
    
    id moveLeft = [CCMoveTo actionWithDuration:0.02 position:ccp(currentPointX + 2,currentPointY)];
    id moveRight = [CCMoveTo actionWithDuration:0.02 position:ccp(currentPointX - 2,currentPointY)];
    id seq = [CCSequence actions:moveLeft,moveRight,nil];
    id repeat = [CCRepeatForever actionWithAction:seq];
    [_qixMonster runAction:repeat];
}

- (void) qixOpacityChange
{
    [[QXPlayers sharedPlayers] frozenMissileSprite].opacity = [[QXPlayers sharedPlayers] frozenMissileSprite].opacity - 20;
}

/*************************************/


@end

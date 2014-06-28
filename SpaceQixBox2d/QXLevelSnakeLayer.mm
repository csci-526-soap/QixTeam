//
//  Level2Layer.m
//  Cocos2dTest
//
//  Created by 李 彦霏 on 14-2-2.
//  Copyright 2014年 Xin ZHANG. All rights reserved.
//

#import "QXLevelSnakeLayer.h"
#import "QXSceneManager.h"
#import "AppDelegate.h"
#import "cocos2d.h"
#import "QXTimeBomb.h"
#import "CCParticleEffectGenerator.h"
#import "CCShake.h"
#import "CDAudioManager.h"

@implementation QXLevelSnakeLayer


/*****************************/
static int timerStartLv4 = 0;
static int timerStartCountLv4=0;
/*****************************/


-(void) initArmor
{

    timerStartLv4 = timerStart;
    timerStartCountLv4 = timerStartCount;
    
    frozenArmor = [CCSprite spriteWithFile:@"iceberg.png"];
    frozenArmor.scale = 0.7;
    frozenArmor.anchorPoint = ccp(0.5, 0);
    //    projectile1 = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
    //projectile1.position = ccp(mapWidth/2-projectile1.contentSize.width -80, mapHeight-projectile1.contentSize.height - 100);
    //projectile2.position = ccp(mapWidth/2-projectile2.contentSize.width +200, mapHeight-projectile2.contentSize.height*2 - 200);
    [frozenArmor runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCRotateTo actionWithDuration:1 angle:30] two:[CCRotateTo actionWithDuration:1 angle:-30]]]];
    
    [self addChild:frozenArmor];

    
    //    projectile1 = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
    frozenArmor.position = ccp(mapWidth/2-frozenArmor.contentSize.width, mapHeight-frozenArmor.contentSize.height*2 - 230);
    //[self addChild:batchNodeProjectile1];
    
    [[QXTimerEffect sharedTimerEffect] display:FIVE layer:self position:ccp(100,100)];
    
}




// initialize mosnters (this method is called after the player is initilized)
- (void) initMonsters
{
    [self initArmor];
    [super initMonsters];
    levelId = LEVEL_3;
    snake = [[QXSnake alloc] init];
    [snake setup:_world layer:self];
    [self resetVariables];
}

// monster take actions (this method is called once per frame after moving the player)
- (void) monsterTakeActions:(ccTime) frameDuration
{
    [super monsterTakeActions:frameDuration];
    if ([snake isActive]) {
    [snake takeAction:frameDuration spawnMissile:^(bool isSpawning, bool start, int tag) {
        [[QXMedalSystem sharedMedalSystem] invokeOnSnakeDropItem:^(enum QXMedalType, QXMedal *) {
            ;
        }];
        [[snake armor] cleanUpSpecificMissile:tag];
        if (![[QXMap sharedMap] isBoundary:[[QXPlayers sharedPlayers] mainPlayerPosition]]) {
            [self lose];
        }
    }];
    }
    
}


-(void)update:(ccTime)delta
{
    [super update:delta];
    
    if(timerStartLv4==1){
        timerStartCountLv4 = timerStartCountLv4 + 1;
        if(timerStartCountLv4<151&&timerStartCountLv4%30==0){
            [snake qixOpacityChange];
        } else if(timerStartCountLv4==151){
           // [Snake hitByGlacierFrozenThenShaking];
        } else if(timerStartCountLv4>=300){
            timerStartLv4 = 0;
            timerStartCountLv4 = 0;
            [snake hitByGlacierFrozenEnd:self];
        }
    }

}

- (NSString *)backgroundImagePath
{
    return @"scene2.png";
}

// the revealed image path
- (NSString *) revealedImagePath
{
    return [super revealedImagePath];
}

// the position of the Qix (this method is called when the game needs to decide which area is claimed by the player)
- (CGPoint) qixPosition
{
    return [[snake attributes] position];
}


// move player by using joysticks with direction (this method is called once per frame, subclass which overrides this method should call [super onPlayerMovingState])
- (void) onPlayerMovingState:(int) direction frameDuration:(ccTime)frameDuration
{
    [super onPlayerMovingState:direction frameDuration:frameDuration];
}

// player claim area state (this method is called when the player claims an area, subclass which overrides this method should call [super onClaimAreaState])
- (void) onClaimAreaState
{
    [super onClaimAreaState];
    int count = [[snake armor] cleanUpMissilesInClaimedArea];
    NSLog(@"cleanedUp: %d", count);
}



- (void) getArmor{
    
   // [super getArmor];
    
    if ((withArm1 == NO) && [[QXMap sharedMap] isFill:CGPointMake(frozenArmor.position.x, frozenArmor.position.y)]) {
        NSLog(@"武器1 Level4 被围住！！");
        [frozenArmor removeFromParentAndCleanup:YES];
        withArm = YES;
        withArm1 = YES;
       [[QXPlayers sharedPlayers] fireFrozenMissile:self qixPosition:[snake qixSprite].position qixSize:[snake qixSprite].contentSize];
        //    [qix hitByArmor:GuidedMissile from:[QXPlayers sharedPlayers].mainPlayerPosition time:0];
    }
}

// ensure position consistency between cocos2d sprites and box2d b2Bodies. (this method is called once per frame for each b2Body in the physical world)
- (void) onCocosAndBoxPositionUpdate:(b2Body *)body
{
    [super onCocosAndBoxPositionUpdate:body];
    NSString *value = (NSString *)body->GetUserData();

    bool isBodySnakeBody = false;
    bool isBodySnakeItem = false;
    
    if (value.length > BODY_SNAKE_BODY_PREFIX.length && [[value substringToIndex:BODY_SNAKE_BODY_PREFIX.length] isEqualToString:BODY_SNAKE_BODY_PREFIX]) {
        isBodySnakeBody = true;
    }
    if (value.length > BODY_SNAKE_ITEM_PREFIX.length && [[value substringToIndex:BODY_SNAKE_ITEM_PREFIX.length] isEqualToString:BODY_SNAKE_ITEM_PREFIX]) {
        isBodySnakeItem = true;
    }
    
    if ([value isEqualToString:BODY_SNAKE_HEAD]) {
        CGPoint point = [snake qixSprite].position;
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([snake qixSprite].rotation);
        body->SetTransform(b2Position, b2Angle);
    } else if (isBodySnakeBody) {
        int bodyIndex = [[value substringFromIndex:BODY_SNAKE_BODY_PREFIX.length] intValue];
        CCSprite *sprite = [snake findQixBodyByIndex:bodyIndex];
        CGPoint point = sprite.position;
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
        body->SetTransform(b2Position, b2Angle);
    } else if (isBodySnakeItem) {
        int itemIndex = [[value substringFromIndex:BODY_SNAKE_ITEM_PREFIX.length] intValue];
        CCSprite *sprite = [[snake armor] missile:itemIndex];
        CGPoint point = sprite.position;
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
        body->SetTransform(b2Position, b2Angle);
    }
    
}

// detect object collisions (this method is called once per frame for every two objects that has collision)
- (bool) onBox2dCollisionDetection:(b2Body *)bodyA body2:(b2Body *)bodyB toDestroy:(std::vector<b2Body *>)toDestroy
{
    [super onBox2dCollisionDetection:bodyA body2:bodyB toDestroy:toDestroy];
    
    NSString *valueA = (NSString *) bodyA->GetUserData();
    NSString *valueB = (NSString *) bodyB->GetUserData();
    
    bool snakeBodyA = false;
    bool snakeBodyB = false;
    
    bool snakeItemA = false;
    bool snakeItemB = false;
    
    if (valueA.length > BODY_SNAKE_ITEM_PREFIX.length) {
        if ([[valueA substringToIndex:BODY_SNAKE_ITEM_PREFIX.length] isEqualToString:BODY_SNAKE_ITEM_PREFIX]) {
            snakeItemA = true;
        }
    }
    if (valueB.length > BODY_SNAKE_ITEM_PREFIX.length) {
        if ([[valueB substringToIndex:BODY_SNAKE_ITEM_PREFIX.length] isEqualToString:BODY_SNAKE_ITEM_PREFIX]) {
            snakeItemB = true;
        }
    }
    
    if (valueA.length > BODY_SNAKE_BODY_PREFIX.length) {
        if ([[valueA substringToIndex:BODY_SNAKE_BODY_PREFIX.length] isEqualToString:BODY_SNAKE_BODY_PREFIX]) {
            snakeBodyA = true;
        }
    }
    if (valueB.length > BODY_SNAKE_BODY_PREFIX.length) {
        if ([[valueB substringToIndex:BODY_SNAKE_BODY_PREFIX.length] isEqualToString:BODY_SNAKE_BODY_PREFIX]) {
            snakeBodyB = true;
        }
    }
    
    if (([valueA isEqualToString:BODY_SNAKE_HEAD] && [valueB isEqualToString:BODY_WORLD]) || ([valueB isEqualToString:BODY_WORLD] && [valueA isEqualToString:BODY_SNAKE_HEAD])) {
        NSLog(@"snake head collide with world");
        
    } else if ((snakeBodyA && [valueB isEqualToString:BODY_PLAYER]) || (snakeBodyB && [valueA isEqualToString:BODY_PLAYER])) {
        NSLog(@"snake body collide with player");
        snakeCollideWithPlayer = true;
        return false;
    } else if (([valueA isEqualToString:BODY_SNAKE_HEAD] && [valueB isEqualToString:BODY_PLAYER]) || ([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_SNAKE_HEAD])) {
        NSLog(@"snake head collide with player");
        snakeCollideWithPlayer = true;
        return false;
    } else if ((snakeItemA && [valueB isEqualToString:BODY_PLAYER]) || (snakeItemB && ([valueA isEqualToString:BODY_PLAYER]))) {
        NSLog(@"snake item collide with player");
        snakeItemCollideWithPlayer = true;
        return false;
    }
    return false;
}

// subclass should override this method to do follow-up actions if collisions are detected
- (void) afterBox2dCollisionDetetion
{
    if (snakeItemCollideWithPlayer || snakeCollideWithPlayer || playerCollideWithWalkerNS || playerCollideWithWalkerNW) {
        [self lose];
        timerStartCount = 0;
        timerStartCountLv4 = 0;
    }
    [self resetVariables];
}

- (void) resetVariables
{
    snakeItemCollideWithPlayer = false;
    snakeCollideWithPlayer = false;
    playerCollideWithWalkerNS = false;
    playerCollideWithWalkerNW = false;
}


/***************************************************/



/*************** sender is from QXPlayers.mm function ****************/

-(void)removeGlacierFrozen:(id)sender
{
    
    [self generateUnderDust];
    [self runShakeScreenEffect];
    [snake hitByGlacierFrozen];
    NSLog(@"timer START!");
    timerStartLv4 = 1;
    
    if([snake isActive]){
        NSLog(@"QIX is active");
    }else{
        NSLog(@"QIX is not active");
    }
    
    
}
- (void) runShakeScreenEffect
{
    [self runAction:[CCShake actionWithDuration:2.0f
                                      amplitude:ccp(5 + CCRANDOM_0_1() * 5, 5 + CCRANDOM_0_1() * 5)
                                      dampening:YES]];
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
    
    dustUnder.position = ccpAdd([snake qixSprite].position, ccp(-40, -20));
    
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

}

-(void)removeDustUnder:(id)sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
    
}

// dealloc (this method is called when the layer class is destroyed, subclass which overrides this method should call [super onDealloc])
- (void) onDealloc
{
    [super onDealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
}

@end

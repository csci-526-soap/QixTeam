//
//  Level2Layer.m
//  Cocos2dTest
//
//  Created by 李 彦霏 on 14-2-2.
//  Copyright 2014年 Xin ZHANG. All rights reserved.
//

#import "QXLevelCrabLayer.h"
#import "QXSceneManager.h"
#import "AppDelegate.h"
#import "cocos2d.h"
#import "QXTimeBomb.h"
#import "CCParticleEffectGenerator.h"
#import "CCShake.h"


static int amplitudeMiddleValue = 5;
@implementation QXLevelCrabLayer

// initialize mosnters (this method is called after the player is initilized)
- (void) initMonsters
{
    [super initMonsters];
    levelId = LEVEL_1;
    crab = [[QXCrab alloc]init];
    [crab setUp:self physicalWorld:_world];
    
    [self resetVariables];
}

// monster take actions (this method is called once per frame after moving the player)
- (void) monsterTakeActions:(ccTime) frameDuration
{
    [super monsterTakeActions:frameDuration];
    [crab takeAction:frameDuration];
}

- (NSString *)backgroundImagePath
{
    return @"scene0.png";
}

// the revealed image path
- (NSString *) revealedImagePath
{
    return [super revealedImagePath];
}

// the position of the Qix (this method is called when the game needs to decide which area is claimed by the player)
- (CGPoint) qixPosition
{
    return [crab qixSprite].position;
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
}

// ensure position consistency between cocos2d sprites and box2d b2Bodies. (this method is called once per frame for each b2Body in the physical world)
- (void) onCocosAndBoxPositionUpdate:(b2Body *)body
{
    [super onCocosAndBoxPositionUpdate:body];
    NSString *value = (NSString *)body->GetUserData();
    
    if ([value isEqualToString:BODY_CRAB]) {
        CGPoint point = [crab qixSprite].position;
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([crab qixSprite].rotation);
        body->SetTransform(b2Position, b2Angle);
    }
}

// detect object collisions (this method is called once per frame for every two objects that has collision)
- (bool) onBox2dCollisionDetection:(b2Body *)bodyA body2:(b2Body *)bodyB toDestroy:(std::vector<b2Body *>)toDestroy
{
    [super onBox2dCollisionDetection:bodyA body2:bodyB toDestroy:toDestroy];
    
    NSString *valueA = (NSString *) bodyA->GetUserData();
    NSString *valueB = (NSString *) bodyB->GetUserData();

    if (([valueA isEqualToString:BODY_CRAB] && [valueB isEqualToString:BODY_PLAYER]) || ([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_CRAB])) {
        playerCollideWithCrab = true;
        NSLog(@"player collide with crab");
    }
    return false;
}

// subclass should override this method to do follow-up actions if collisions are detected
- (void) afterBox2dCollisionDetetion
{
    [super afterBox2dCollisionDetetion];
    
    if (playerCollideWithWalkerNW || playerCollideWithWalkerNS || playerCollideWithCrab) {
        [self lose];
    }
    [self resetVariables];
}

- (void) resetVariables
{
    playerCollideWithCrab = false;
    playerCollideWithWalkerNS = false;
    playerCollideWithWalkerNW = false;
}

-(void) crabQixFire:(id)sender

{
    double distanceBtwCrabAndPlayer = 0.0f;
    double temp1;
    double temp2;
    
    temp1 = pow([[QXPlayers sharedPlayers] mainPlayerPosition].x - [crab qixSprite].position.x,2);
    temp2 = pow([[QXPlayers sharedPlayers] mainPlayerPosition].y - [crab qixSprite].position.y,2);
    distanceBtwCrabAndPlayer = sqrt(temp1+temp2);
  
    [self runShakeScreenEffect:distanceBtwCrabAndPlayer];
}

- (void) runShakeScreenEffect:(double)amplitudeMiddleValue
{
     NSLog(@"distance is %f", amplitudeMiddleValue);
    
    double factor = 0;
    amplitudeMiddleValue = pow(amplitudeMiddleValue,2);
    factor = 6 - amplitudeMiddleValue*0.00015;
    if( factor<0 ){
        factor = 0;
    }
    NSLog(@"factor is %f", factor);
    [self runAction:[CCShake actionWithDuration:1.0f
                                      amplitude:ccp(factor + CCRANDOM_0_1()*factor, factor + CCRANDOM_0_1()*factor)
                                      dampening:YES]];
}

// dealloc (this method is called when the layer class is destroyed, subclass which overrides this method should call [super onDealloc])
- (void) onDealloc
{
    [super onDealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
}

@end

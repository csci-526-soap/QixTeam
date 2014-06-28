//
//  QXLevel3Layer.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/17/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXTutorialLevel.h"
#import "QXSceneManager.h"
#import "AppDelegate.h"
#import "cocos2d.h"

@implementation QXTutorialLevel
// initialize mosnters (this method is called after the player is initilized)
- (void) initMonsters
{
    laserQix = [[QXLaserQix alloc] init];
}

// monster take actions (this method is called once per frame after moving the player)
- (void) monsterTakeActions:(ccTime) frameDuration
{
    
}

- (NSString *)backgroundImagePath
{
    return [super backgroundImagePath];
}

// the position of the Qix (this method is called when the game needs to decide which area is claimed by the player)
- (CGPoint) qixPosition
{
    return [laserQix position];
}

// move player by using joysticks with direction (this method is called once per frame, subclass which overrides this method should call [super onPlayerMovingState])
- (void) onPlayerMovingState:(int) direction frameDuration:(ccTime)frameDuration
{
//    [super onPlayerMovingState:direction frameDuration:frameDuration];
}

// player claim area state (this method is called when the player claims an area, subclass which overrides this method should call [super onClaimAreaState])
- (void) onClaimAreaState
{
    [super onClaimAreaState];
}

// ensure position consistency between cocos2d sprites and box2d b2Bodies. (this method is called once per frame for each b2Body in the physical world)
- (void) onCocosAndBoxPositionUpdate:(b2Body *)body
{
    
}

// detect object collisions (this method is called once per frame for every two objects that has collision)
- (bool) onBox2dCollisionDetection:(b2Body *)body1 body2:(b2Body *)body2 toDestroy:(std::vector<b2Body *>)toDestroy
{
    
}

// subclass should override this method to do follow-up actions if collisions are detected
- (void) afterBox2dCollisionDetetion
{
    
}

// dealloc (this method is called when the layer class is destroyed, subclass which overrides this method should call [super onDealloc])
- (void) onDealloc
{
    [super onDealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
}

@end

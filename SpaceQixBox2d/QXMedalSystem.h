//
//  QXMedalSystem.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXMedal.h"
#import "QXGamePlay.h"

#define KEY_MEDAL_LOST_LIVES_TOTAL_CNT @"medalLostLives"
#define KEY_MEDAL_HIT_BY_LASER_TOTAL_CNT @"medalHitByLaser"
#define KEY_MEDAL_HIT_BY_MISSILE_TOTAL_CNT @"medalHitByMissile"

@interface QXMedalSystem : NSObject {
    
    // the play history
    int lostLivesTotalCnt;
    int hitByLaserTotalCnt;
    int hitByMissileTotalCnt;
    
    // the player current level history
    bool useNitrogen;
    int lostLivesCnt;
    int killedWalkerCnt;
    int killedGuardCnt;
    bool isCrabVisible;
    int snakeDroppedItems;
    int missileRounds;
    
    bool isGameJourneyBegin;
    bool isGameJourneyEnd;
    bool isGameLevelBegin;
    bool isGameLevelEnd;
}

+ (QXMedalSystem *) sharedMedalSystem;

// this method should be called when the game journey begin
- (void) onGameJourneyBegin;

// this method should be called when player enters any game levels
- (void) onGameLevelBegin;

// this method should be called when player is in the game level
- (void) onGamePlaying:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player lost a life
- (void) invokeOnLoseLife:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player uses the nitrogen
- (void) invokeOnUsingNitrogen:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player is hit by laser
- (void) invokeOnHitByLaser:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player is hit by scattered missile
- (void) invokeOnHitByScatteredMissile:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player kill guard qixes
- (void) invokeOnKillGuardQix:(int)guardQixs rewardCallback:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player kill walkers
- (void) invokeOnKillWalker:(int)walkerQix rewardCallback:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when the crab is invisible
- (void) invokeOnCrabInvisible:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when crab is visible
- (void) invokeOnCrabVisible:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when snake drop items
- (void) invokeOnSnakeDropItem:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when qix emits missiles
- (void) invokeOnQixEmitMissiles:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when player is claiming an area
- (void) invokeOnClaimingArea:(double)percentage rewardCallback:(void(^)(enum QXMedalType, QXMedal *))rewardCallback;

// this method should be called when the current game level ends
- (void) onGameLevelEnd:(void(^)(NSArray *))rewardCallback;

// this method should be called when the game journey ends
- (void) onGameJourneyEnd:(void(^)(NSArray *))rewardCallback;;
@end

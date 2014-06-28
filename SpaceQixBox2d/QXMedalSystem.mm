//
//  QXMedalSystem.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMedalSystem.h"

@implementation QXMedalSystem

static dispatch_once_t QXMedalSystemPredicate;
static QXMedalSystem *sharedMedalSystem = nil;

+ (QXMedalSystem *) sharedMedalSystem {
    dispatch_once(&QXMedalSystemPredicate, ^{
        sharedMedalSystem = [[QXMedalSystem alloc] init];
    });
    return sharedMedalSystem;
}

- (id) init
{
    self = [super init];
    NSUserDefaults *user =[[NSUserDefaults alloc] init];
    lostLivesTotalCnt = [[user objectForKey:KEY_MEDAL_LOST_LIVES_TOTAL_CNT] intValue];
    hitByLaserTotalCnt = [[user objectForKey:KEY_MEDAL_HIT_BY_LASER_TOTAL_CNT] intValue];
    hitByMissileTotalCnt = [[user objectForKey:KEY_MEDAL_HIT_BY_MISSILE_TOTAL_CNT] intValue];
    return self;
}

// this method should be called when the game journey begin
- (void) onGameJourneyBegin
{
    isGameJourneyBegin = true;
}

// this method should be called when player enters any game levels
- (void) onGameLevelBegin
{
    isGameLevelBegin = true;
    [self resetVariables];
}

// this method should be called when player is in the game level
- (void) onGamePlaying:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
}

// this method should be called when player lost a life
- (void) invokeOnLoseLife:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    lostLivesCnt++;
    lostLivesTotalCnt++;
    NSUserDefaults *user =[[NSUserDefaults alloc] init];
    [user setInteger:lostLivesTotalCnt forKey:KEY_MEDAL_LOST_LIVES_TOTAL_CNT];
    if (lostLivesTotalCnt % 50 == 0) {
        if (rewardCallback) {
            QXMedal *medal = [QXMedal getMedalByType:MEDAL_DIE];
            rewardCallback(MEDAL_DIE, medal);
        }
    }
}

// this method should be called when player uses the nitrogen
- (void) invokeOnUsingNitrogen:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    useNitrogen = true;
}

// this method should be called when player is hit by laser
- (void) invokeOnHitByLaser:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    hitByLaserTotalCnt++;
    NSUserDefaults *user =[[NSUserDefaults alloc] init];
    [user setInteger:hitByLaserTotalCnt forKey:KEY_MEDAL_HIT_BY_LASER_TOTAL_CNT];
    if (hitByLaserTotalCnt % 50 == 0) {
        if (rewardCallback) {
            QXMedal *medal = [QXMedal getMedalByType:MEDAL_KILLED_BY_LASER];
            rewardCallback(MEDAL_KILLED_BY_LASER, medal);
        }
    }
}

// this method should be called when player is hit by scattered missile
- (void) invokeOnHitByScatteredMissile:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    hitByMissileTotalCnt++;
    NSUserDefaults *user =[[NSUserDefaults alloc] init];
    [user setInteger:hitByMissileTotalCnt forKey:KEY_MEDAL_HIT_BY_MISSILE_TOTAL_CNT];
    if (hitByMissileTotalCnt % 50 == 0) {
        if (rewardCallback) {
            QXMedal *medal = [QXMedal getMedalByType:MEDAL_KILLED_BY_MISSILE];
            rewardCallback(MEDAL_KILLED_BY_MISSILE, medal);
        }
    }
}

// this method should be called when player kill guard qixes
- (void) invokeOnKillGuardQix:(int)guardQixs rewardCallback:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    killedGuardCnt += guardQixs;
    if (guardQixs == 3) {
        if (rewardCallback) {
            rewardCallback(MEDAL_NULL, nil);
        }
    }
}

// this method should be called when player kill walkers
- (void) invokeOnKillWalker:(int)walkerQix rewardCallback:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    if (walkerQix == 2) {
        if (rewardCallback) {
            QXMedal *medal = [QXMedal getMedalByType:MEDAL_WALKER_DIED];
            rewardCallback(MEDAL_WALKER_DIED, medal);
        }
    }
    killedWalkerCnt+=walkerQix;
}

// this method should be called when the crab is invisible
- (void) invokeOnCrabInvisible:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    isCrabVisible = false;
}

// this method should be called when crab is visible
- (void) invokeOnCrabVisible:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    isCrabVisible = true;
}

// this method should be called when snake drop items
- (void) invokeOnSnakeDropItem:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    snakeDroppedItems++;
}

// this method should be called when qix emits missiles
- (void) invokeOnQixEmitMissiles:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    missileRounds++;
}

// this method should be called when player is claiming an area
- (void) invokeOnClaimingArea:(double)percentage rewardCallback:(void(^)(enum QXMedalType, QXMedal *))rewardCallback
{
    if (!isGameLevelBegin) {
        return;
    }
    if (percentage > 0.5) {
        if (rewardCallback) {
            QXMedal *medal = [QXMedal getMedalByType:MEDAL_CLAIM_50];
            rewardCallback(MEDAL_CLAIM_50, medal);
        }
    }
}

// this method should be called when the current game level ends
- (void) onGameLevelEnd:(void(^)(NSArray *))rewardCallback;
{
    if (!isGameLevelBegin) {
        return;
    }
    if ([[QXGamePlay sharedGamePlay] isWin]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (lostLivesCnt == 0) {
            [array addObject:[[QXMedal alloc] init]];
        }
        if (useNitrogen) {
            [array addObject:[[QXMedal alloc] init]];
        }
        if (!isCrabVisible) {
            [array addObject:[[QXMedal alloc] init]];
        }
        if (snakeDroppedItems < 5) {
            [array addObject:[[QXMedal alloc] init]];
        }
        if (missileRounds >= 20) {
            [array addObject:[[QXMedal alloc] init]];            
        }
        if (rewardCallback) {
            rewardCallback(array);
        }
    }
}

// this method should be called when the game journey ends
- (void) onGameJourneyEnd:(void(^)(NSArray *))rewardCallback;
{
    if (!isGameJourneyBegin) {
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (rewardCallback) {
        rewardCallback(array);
    }
}

- (void) resetVariables
{
    useNitrogen = false;
    lostLivesCnt = 0;
    killedWalkerCnt = 0;
    killedGuardCnt = 0;
    isCrabVisible = true;
    snakeDroppedItems = 0;
    missileRounds = 0;
}

@end

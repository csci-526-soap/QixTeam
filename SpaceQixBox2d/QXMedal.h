//
//  QXMedal.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXObject.h"
#import "cocos2d.h"

#define KEY_MEDAL_LOST_LIVES_DESCRIPTION @"You have died 50 times"
#define KEY_MEDAL_HIT_BY_LASER_DESCRIPTION @"You have been hit by laser 50 times"
#define KEY_MEDAL_HIT_BY_MISSILE_DESCRIPTION @"You have been hit by missile 50 times"
#define KEY_MEDAL_LOST_LIVES_TOTAL_CNT @"medalLostLives"
#define KEY_MEDAL_HIT_BY_LASER_TOTAL_CNT @"medalHitByLaser"
#define KEY_MEDAL_HIT_BY_MISSILE_TOTAL_CNT @"medalHitByMissile"

enum QXMedalType {MEDAL_NULL, MEDAL_DIE, MEDAL_KILLED_BY_MISSILE, MEDAL_KILLED_BY_LASER, MEDAL_WIN, MEDAL_CLAIM_50, MEDAL_WALKER_DIED};

@interface QXMedal : QXObject {
    // the medal image displayed on the medal layer
    CCSprite *_medal;
    CCSprite *_lockedMedal;
    // the medal description
    NSString *_description;
    enum QXMedalType _type;
    bool _isActive;
}

- (void) setup:(CCSprite *)medel description:(NSString *)description type:(enum QXMedalType)type isActive:(bool) isActive;

+ (QXMedal *) getMedalByType:(enum QXMedalType)type;

- (void) displayMedal:(CCLayer *)layer;

- (bool) isActive;

- (CCSprite *)medal;

- (NSString *)description;

@end

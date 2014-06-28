//
//  QXQixQixAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonsterAttribute.h"

#define KEY_MISSLE_QIX @"missleQix"

#define KEY_CRAB_MECHA_MOVE_DURATION @"crabMoveDuration"
#define KEY_CRAB_MECHA_FIRE_INTERVAL @"crabFireInterval"
#define KEY_CRAB_MECHA_MOVE_MAX_STEP @"crabMoveMaxStep"

@interface QXQixAttribute : QXMonsterAttribute {
    double moveDuration;
    int moveMaxStep;
    double fireInterval;
}

- (double) moveDuration;

- (int) moveMaxStep;

- (double) fireInterval;

@end

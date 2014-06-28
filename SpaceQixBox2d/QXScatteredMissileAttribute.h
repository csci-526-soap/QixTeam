//
//  QXScatteredMissileAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/10/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmorAttribute.h"

#define KEY_SCATTERED_MISSILE_FIRE_DURATION @"fireDuration"
#define KEY_SCATTERED_MISSILE_COUNT @"count"

@interface QXScatteredMissileAttribute : QXArmorAttribute {
    double fireDuration;
    int totalMissilecount;
}

- (double) fireDuration;

- (int) totalMissilecount;

@end

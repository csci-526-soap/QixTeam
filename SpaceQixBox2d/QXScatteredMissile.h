//
//  QXGuidedMissile.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXArmor.h"
#import "QXScatteredMissileAttribute.h"

#define BODY_SCATTERED_MISSILE_TAG @"SCATTERED_MISSILE"

@interface QXScatteredMissile : QXArmor {
    NSMutableArray *_armors;
    int armorIndex;
    
    QXScatteredMissileAttribute *attribute;
    double missleFireStep;
    int count;
    NSMutableArray *missileTags;
}

- (NSMutableArray *)armors;

- (int) currentArmorIndex;

- (QXScatteredMissileAttribute *)attribute;

@end

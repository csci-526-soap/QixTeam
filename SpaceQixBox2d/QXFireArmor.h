//
//  QXFireArmor.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXArmor.h"
//#import "QXExplosion.h"
#define KEY_ARMOR_FIRE_ARMOR @"fireArmor"
#define BODY_FIRE_ARMOR @"fireArmorBody"
#import "QXMap.h"

@interface QXFireArmor : QXArmor {
    
    NSMutableArray *_armors;
    int armorIndex;
    CGPoint specificQixMissileLocation;
    NSMutableArray *armorUserData;
}

- (NSMutableArray *)armors;
- (int) currentArmorIndex;

@end

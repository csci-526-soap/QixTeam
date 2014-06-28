//
//  QXArmorConfig.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmorConfig.h"

@implementation QXArmorConfig

- (void) setup
{
    armorArrays = [[NSMutableArray alloc] init];
}

- (void) loadArmors:(QXBaseAttribute *)attribute type:(enum QXArmorType)type
{
    
}

- (QXArmor *) getArmor:(enum QXArmorType) type
{
    switch (type) {
        case FireArmor:
            break;
        case GuidedMissile:
            break;
        case ScatteredMissile:
            break;
        default:
            break;
    }
}

- (QXBaseAttribute *) findArmorById:(int) Id
{
    for (int i = 0; i < [armorArrays count]; i++) {
        QXBaseAttribute *attr = [armorArrays objectAtIndex:i];
        if ([attr ID] == Id) {
            return attr;
        }
    }
    return nil;
}
@end

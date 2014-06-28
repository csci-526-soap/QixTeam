//
//  QXArmorConfig.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXArmor.h"
#import "QXBaseAttribute.h"

@interface QXArmorConfig : NSObject {
    NSMutableArray *armorArrays;
}

- (void) setup;

- (void) loadArmors:(QXBaseAttribute *)attribute type:(enum QXArmorType)type;

- (QXArmor *) getArmor:(enum QXArmorType) type;

- (QXBaseAttribute *) findArmorById:(int) Id;
@end

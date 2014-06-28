//
//  QXArmorAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/10/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXBaseAttribute.h"
#import "QXArmor.h"

#define KEY_ARMOR_CAN_PICK_UP @"pickup"

@interface QXArmorAttribute : QXBaseAttribute {
    enum QXArmorType _armorType;
    bool _canPickUp;
}

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description armorType:(enum QXArmorType)armorType canPickUp:(bool)canPickUp;

- (void) setArmorType:(enum QXArmorType)armorType;

- (enum QXArmorType)armorType;

- (bool) canPickUp;
@end

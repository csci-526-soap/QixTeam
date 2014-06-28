//
//  QXArmorAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/10/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmorAttribute.h"

@implementation QXArmorAttribute

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description armorType:(enum QXArmorType)armorType  canPickUp:(bool)canPickUp
{
    [super setup:name Id:ID position:position tag:tag description:description];
    _armorType = armorType;
    _canPickUp = canPickUp;
}

- (void) build:(NSDictionary *)attributeDict
{
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_ARMOR_CAN_PICK_UP]) {
            _canPickUp = [[attributeDict objectForKey:key] boolValue];
        }
    }
}

- (void) setArmorType:(enum QXArmorType)armorType
{
    _armorType = armorType;
}

- (enum QXArmorType)armorType
{
    return _armorType;
}

- (bool) canPickUp
{
    return _canPickUp;
}
@end

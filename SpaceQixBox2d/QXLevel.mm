//
//  QXLevel.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXLevel.h"

@implementation QXLevel

- (void) build:(NSDictionary *) levelAttributes
{
    for (id key in levelAttributes) {
        if ([key isEqualToString:KEY_ID]) {
            _levelId = [[levelAttributes objectForKey:key] intValue];
        } else if ([key isEqualToString:KEY_ACTIVE]) {
            _isActive = [[levelAttributes objectForKey:KEY_ACTIVE] boolValue];
        }
    }
}

- (void) setup:(int) levelId active:(bool)isActive
{
    _levelId = levelId;
    _isActive = isActive;
    qixs = [[NSMutableArray alloc] init];
    armors = [[NSMutableArray alloc] init];
    playerAttributes = [[QXPlayerAttributes alloc] init];
}

- (void) addQix:(QXBaseAttribute *) qix
{
    [qixs addObject:qix];
}

- (void) addArmor:(QXBaseAttribute *) armor
{
    [armors addObject:armor];
}

- (void) addPlayer:(QXBaseAttribute *) player
{
    playerAttributes = player;
}

- (int) levelId
{
    return _levelId;
}

- (bool) isActive
{
    return _isActive;
}

- (NSArray *) qixs
{
    return qixs;
}

- (NSArray *) armors
{
    return armors;
}

- (QXBaseAttribute *) playerAttribute
{
    return playerAttributes;
}
@end

//
//  QXScatteredMissileAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/10/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXScatteredMissileAttribute.h"

@implementation QXScatteredMissileAttribute

- (void) build:(NSDictionary *)attributeDict
{
    [super build:attributeDict];
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_SCATTERED_MISSILE_COUNT]) {
            totalMissilecount = [[attributeDict objectForKey:key] intValue];
        } else if ([key isEqualToString:KEY_SCATTERED_MISSILE_FIRE_DURATION]) {
            fireDuration = [[attributeDict objectForKey:key] doubleValue];
        }
    }
}

- (double) fireDuration
{
    return fireDuration;
}

- (int) totalMissilecount
{
    return totalMissilecount;
}
@end

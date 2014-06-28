//
//  QXQixQixAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXQixAttribute.h"

@implementation QXQixAttribute

- (void) build:(NSDictionary *)attributeDict
{
    [super build:attributeDict];
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_CRAB_MECHA_MOVE_DURATION]) {
            moveDuration = [[attributeDict objectForKey:key] doubleValue];
        } else if ([key isEqualToString:KEY_CRAB_MECHA_MOVE_MAX_STEP]) {
            moveMaxStep = [[attributeDict objectForKey:key] intValue];
        } else if ([key isEqualToString:KEY_CRAB_MECHA_FIRE_INTERVAL]) {
            fireInterval = [[attributeDict objectForKey:key] doubleValue];
        }
    }
}

- (double) moveDuration
{
    return moveDuration;
}

- (int) moveMaxStep
{
    return moveMaxStep;
}

- (double) fireInterval
{
    return fireInterval;
}
@end

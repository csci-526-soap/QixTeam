//
//  QXQixWalkerAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXWalkerAttribute.h"

@implementation QXWalkerAttribute

- (void) build:(NSDictionary *)attributeDict
{
    [super build:attributeDict];
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_CLOCKWISE]) {
            clockwise = [[attributeDict objectForKey:key] boolValue];
        } else if ([key isEqualToString:KEY_RUN_DIRECTION]) {
            runDirection = [[attributeDict objectForKey:key] intValue];
        } else if ([key isEqualToString:KEY_SPEED]) {
            speed = [[attributeDict objectForKey:key] intValue];
        }
    }
}

- (int) runDirection
{
    return runDirection;
}

- (bool) clockwise
{
    return clockwise;
}

- (int) speed
{
    return speed;
}

- (void) updateDirection:(int) direction
{
    runDirection = direction;
}
@end

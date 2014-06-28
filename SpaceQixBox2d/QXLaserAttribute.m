//
//  QXLaserAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/20/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXLaserAttribute.h"

@implementation QXLaserAttribute

- (void) build:(NSDictionary *)attributeDict
{
    [super build:attributeDict];
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_EMIT_DELAY]) {
            emitDelay = [[attributeDict objectForKey:key] doubleValue];
        } else if ([key isEqualToString:KEY_EMIT_DURATION]) {
            emitDuration = [[attributeDict objectForKey:key] doubleValue];
        }
    }
}

- (double) emitDelay
{
    return emitDelay;
}

- (double) emitDuration
{
    return emitDuration;
}

@end

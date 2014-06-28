//
//  QXTimeBombAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/19/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXTimeBombAttribute.h"

@implementation QXTimeBombAttribute

- (void) build:(NSDictionary *)attributeDict
{
    [super build:attributeDict];
    
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_TIME_BOMB_TIMER]) {
            timer = [[attributeDict objectForKey:key] doubleValue];
        }
    }
}

- (double) timer
{
    return timer;
}
@end

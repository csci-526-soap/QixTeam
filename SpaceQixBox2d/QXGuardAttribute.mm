//
//  QXQixGuardAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXGuardAttribute.h"

@implementation QXGuardAttribute

- (void) build:(NSDictionary *)attributeDict
{
    [super build:attributeDict];
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_RADIUS]) {
            radius = [[attributeDict objectForKey:key] doubleValue];
        }
    }
}

- (double) radius
{
    return radius;
}
@end

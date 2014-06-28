//
//  QXPlayerAttributes.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXPlayerAttributes.h"

@implementation QXPlayerAttributes

- (void) build:(NSDictionary *)attributes
{
    [super build:attributes];
    for (id key in attributes) {
        if ([key isEqualToString:KEY_ACCELERATE_RATE]) {
            _accelerateRate = [[attributes objectForKey:key] doubleValue];
        } else if ([key isEqualToString:KEY_DEFENCE]) {
            _defence = [[attributes objectForKey:key] integerValue];
        } else if ([key isEqualToString:KEY_DESCRIPTION]) {
            _description = [attributes objectForKey:key];
        } else if ([key isEqualToString:KEY_INIT_NITROGEN]) {
            _initialNitrogen = [[attributes objectForKey:key] doubleValue];
        } else if ([key isEqualToString:KEY_NITROGEN_ADDED_RATIO]) {
            _nitrogenAddedRatio = [[attributes objectForKey:key] doubleValue];
        } else if ([key isEqualToString:KEY_NITROGEN_COMSUMPTION_RATIO]) {
            _nitrogenConsumptionRatio = [[attributes objectForKey:key] doubleValue];
        } else if ([key isEqualToString:KEY_VELOCITY]) {
            _speed = [[attributes objectForKey:key] intValue];
        } else if ([key isEqualToString:KEY_INIT_INVINCIBLE_TIME]) {
            _invincibleTime = [[attributes objectForKey:KEY_INIT_INVINCIBLE_TIME] doubleValue];
        }
    }
    
}

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description speed:(int) speed accelerateRate:(double)accelerateRate initialNitrogen:(double)initialNitrogen nitrogenAddedRatio:(double)nitrogenAddedRatio nitrogenConsumptionRatio:(double)nitrogenConsumptionRatio defence:(int)defence
{
    [super setup:name Id:ID position:position tag:tag description:description];
    _speed = speed;
    _accelerateRate = accelerateRate;
    _initialNitrogen = initialNitrogen;
    _nitrogenAddedRatio = nitrogenAddedRatio;
    _nitrogenConsumptionRatio = nitrogenConsumptionRatio;
    _defence = defence;
}

- (int) speed
{
    return _speed;
}

- (double) accelerateRate
{
    return _accelerateRate;
}

- (double) initialNitrogen
{
    return _initialNitrogen;
}

- (double) nitrogenAddedRatio
{
    return _nitrogenAddedRatio;
}

- (double) nitrogenConsumptionRatio
{
    return _nitrogenConsumptionRatio;
}

- (int) defence
{
    return _defence;
}

- (double) invincibleTime
{
    return _invincibleTime;
}

@end

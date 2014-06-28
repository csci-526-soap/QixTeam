//
//  QXSnakeAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/8/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXSnakeAttribute.h"

@implementation QXSnakeAttribute

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description stepDuration:(float)stepDuration snakeBodyLength:(int)snakeBodyLength
{
    [super setup:name Id:ID position:position tag:tag description:description];
    _snakeBodyLength = snakeBodyLength;
    _stepDuration = stepDuration;
}

- (void) build:(NSDictionary *)attributeDict
{
    
}

- (float) stepDuration
{
    return _stepDuration;
}

- (int) snakeBodyLength
{
    return _snakeBodyLength;
}

- (bool) canDropItem
{
    return _canDropItem;
}
@end

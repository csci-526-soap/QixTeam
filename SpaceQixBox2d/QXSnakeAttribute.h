//
//  QXSnakeAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/8/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonsterAttribute.h"

#define KEY_SNAKE_STEP_DURATION @"stepDuration"
#define KEY_SNAKE_BODY_LENGTH @"bodyLength"
#define KEY_SNAKE_CAN_DROP_ITEM @"canDropItems"


@interface QXSnakeAttribute : QXMonsterAttribute {
    float _stepDuration;
    int _snakeBodyLength;
    bool _canDropItem;
}

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description stepDuration:(float)stepDuration snakeBodyLength:(int)snakeBodyLength;

- (float) stepDuration;

- (int) snakeBodyLength;

- (bool) canDropItem;

@end

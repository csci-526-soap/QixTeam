//
//  QXSnake.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/8/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXQixBoss.h"
#import "QXSnakeAttribute.h"
#import "Box2D.h"
#import "cocos2d.h"
#import "QXTimeBomb.h"

#define BODY_SNAKE_HEAD @"bodySnakeHead"
#define BODY_SNAKE_BODY_PREFIX @"bodySnakeBody"

@interface QXSnake : QXQixBoss {
    NSMutableArray *snake;
    float headAngle;
    float moveStep;
    int moveStepCount;
    CGPoint newPos;
    CGSize winSize;
    int angleChange;
    QXSnakeAttribute *attribute;
    // the snake can drop items when stop action
    QXTimeBomb *timeBomb;
    NSMutableArray *snakeBodyTags;
}

- (void) setup:(b2World *)physicalWorld layer:(CCLayer *)layer;

- (QXSnakeAttribute *) attributes;

- (void) hitByGlacierFrozen;
- (void) hitByGlacierFrozenEnd:(CCLayer*)layer;
- (void) qixOpacityChange;
@end

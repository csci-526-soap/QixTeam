//
//  QXQix.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/21/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GB2ShapeCache.h"
#import "QXQixBoss.h"
#import "QXScatteredMissile.h"
#import "QXQixAttribute.h"
#import "QXExplosion.h"

#define BODY_QIX @"bodyQix"
#define ACTION_RANDOM_MOVE 1

@interface QXQix : QXQixBoss {
    double changeBehaviorIntervalStep;

    double moveIntervalStep;
    double alertMoveStep;
    CCMoveTo *moveAction;
    double hitByArmorStep;
    int runDirection;
    
    QXScatteredMissile *missile;
    QXQixAttribute *_attribute;
}

- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data;

- (void) clear;

- (QXQixAttribute *)attribute;

- (CGPoint) position;

- (QXScatteredMissile *) missile;
- (void) hitByGlacierFrozenThenShaking;
- (void) hitByGlacierFrozen;
- (void) hitByGlacierFrozenEnd:(CCLayer*)layer;
- (void) qixOpacityChange;


@end

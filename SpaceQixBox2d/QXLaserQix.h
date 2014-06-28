//
//  QXLaserQix.h
//  SpaceQix
//
//  Created by Student on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "Box2D.h"

#import "GB2ShapeCache.h"

#import "QXQixBoss.h"

#import "QXScatteredMissile.h"

#import "QXQixAttribute.h"
#import "QXLaser.h"

#define BODY_LASER_QIX @"bodyLaserQix"

@interface QXLaserQix : QXQixBoss {
    
    double changeBehaviorIntervalStep;
    
    double missleFireStep;
    
    double moveIntervalStep;
    
    double alertMoveStep;
    
    CCMoveTo *moveAction;

    double hitByArmorStep;
    
    int count;
    
    CCLayer *mainScene;
    
    QXLaser *laser;
}

- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data :(CCLayer *) GameScene;

- (CGPoint) position;

- (void) clear;

- (CCSprite *) missile:(int)tag;

/***********************************/
- (void) hitByGlacierFrozen;
- (void) hitByGlacierFrozenEnd:(CCLayer*)layer;
- (void) qixOpacityChange;
/***********************************/

@end
//
//  QXMonster.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "QXBaseAttribute.h"
#import "GB2ShapeCache.h"
#import "QXArmor.h"
#import "QXObject.h"
#import "QXExplosion.h"


#define KEY_QIXS @"qixs"
#define KEY_QIX @"qix"

enum QXQixType {Walker, Guard, Qix, Snake};

// Base class for Qix
@interface QXMonster : QXObject {
    enum QXQixType type;
    CCSprite *_qixMonster;
    b2Body *_qixMonsterBody;
    bool isActive;
    
    b2World *_world;
    CCLayer *_layer;
    QXExplosion *explosion;
}

- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world;

- (void) build:(QXBaseAttribute *)attribute;

- (void) takeAction:(ccTime)delta;

- (bool) isActive;

- (CCSprite *) qixSprite;

- (b2Body *) qixBody;

- (void) explosion;

- (void) hitByArmor:(enum QXArmorType)type from:(CGPoint)from time:(ccTime)time;

@end

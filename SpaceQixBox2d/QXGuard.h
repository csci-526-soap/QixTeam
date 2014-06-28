//
//  QXSimpleQix.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GB2ShapeCache.h"
#import "QXPlayers.h"
#import "QXMap.h"
#import "QXMonster.h"
#import "QXExplosion.h"
#import "QXGuardAttribute.h"

#define BODY_GUARD_1 @"bodyGuard1"
#define BODY_GUARD_2 @"bodyGuard2"
#define BODY_GUARD_3 @"bodyGuard3"

#define KEY_RADIUS @"radius"

@interface QXGuard : QXMonster {

}

- (void) setup:(CGPoint) position layer:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data;

@end

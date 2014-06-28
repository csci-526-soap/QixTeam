//
//  QXSimpleMonster.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "QXMonster.h"
#import "GB2ShapeCache.h"
#import "QXWalkerAttribute.h"

#define BODY_WALKER_NW @"bodyWalkerNW"
#define BODY_WALKER_NS @"bodyWalkerNS"

@interface QXWalker : QXMonster {
    QXWalkerAttribute *attribute;
    float initRotation;
}

- (void) setup:(CCSprite *)sprite Layer:(CCLayer *)layer runDirection:(int) dir runClockwise:(bool)clockwise position:(CGPoint) position userData:(void *) data physicalWorld:(b2World *)world;

- (CGPoint) currentPosition;

- (float) speed;

@end


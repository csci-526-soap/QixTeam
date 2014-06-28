//
//  QXSurrander.h
//  SpaceQix
//
//  Created by Student on 4/7/14.
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
#import "QXLaserQix.h"

@interface QXSurrander : QXMonster {
    QXLaserQix *laser;
    int code;
    int state;
    CGPoint targetTrace;
}

- (void) setup:(CGPoint) position layer:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data Qixall:(QXLaserQix *) tempQix type:(int) typeCode;

- (void) takeAction: (CGPoint) pPosition;
- (void) collideWithExplosion;
@end
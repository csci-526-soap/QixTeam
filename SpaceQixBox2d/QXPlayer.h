//
//  QXPlayer.h
//  Cocos2dTest
//
//  Created by Haoyu Huang on 2/23/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GB2ShapeCache.h"
#import "QXObject.h"
#import "QXPlayerAttributes.h"

@interface QXPlayer : QXObject {
    b2Body *_body;
    CCSprite *_image;
    int currentDirection;
    CGPoint currentPosition;
}

- (void) setup:(CCSprite *)image physicalWorld:(b2World *) world userData:(void *)data;

- (bool) isCollided:(CGPoint) point;

- (int) currentDirection;

- (void) setDirection:(int) direction;

- (CGPoint) currentPoint;

- (CCSprite *) image;

- (b2Body *) body;

@end

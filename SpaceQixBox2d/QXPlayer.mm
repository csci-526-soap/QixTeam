//
//  QXPlayer.m
//  Cocos2dTest
//
//  Created by Haoyu Huang on 2/23/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import "QXPlayer.h"
#import "QXMap.h"

@implementation QXPlayer

- (void) config:(QXBaseAttribute *)attribute
{
    QXPlayerAttributes *attr = (QXPlayerAttributes *)attribute;
    
}

- (void) setup:(CCSprite *)image physicalWorld:(b2World *) world userData:(void *)data
{
    _image = image;
    currentPosition = [_image position];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(image.position.x/PTM_RATIO, image.position.y/PTM_RATIO);
    bodyDef.userData = data;
    _body = world->CreateBody(&bodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 8.0/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 0.5f;
    fixtureDef.restitution = 0.8f;
    _body->CreateFixture(&fixtureDef);
}

- (bool) isCollided:(CGPoint) point
{
    return currentPosition.x == point.x && currentPosition.y == point.y;
}

- (int) currentDirection
{
    return currentDirection;
}

- (void) setDirection:(int) direction
{
    currentDirection = direction;
}

- (CGPoint) currentPoint
{
    return _image.position;
}

- (CCSprite *) image
{
    return _image;
}
- (b2Body *) body
{
    return _body;
}

@end

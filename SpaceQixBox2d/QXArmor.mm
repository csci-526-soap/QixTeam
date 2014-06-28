//
//  QXArmor.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmor.h"

@implementation QXArmor

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world
{
    _layer = layer;
    _world = world;
    pickedUp = false;
}

- (void) fire:(CCLayer *) layer delta:(ccTime)delta
{

}

- (void) clear:(CCLayer *)layer delta:(ccTime)delta
{
    
}

- (CCSprite *) spawnArmor:(CCLayer *)layer
{
    return nil;
}

@end

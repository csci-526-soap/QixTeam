//
//  QXMonster.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonster.h"

@implementation QXMonster

- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world
{
    _world = world;
    _layer = layer;
    explosion = [[QXExplosion alloc] init];
}

- (void) takeAction:(ccTime)delta
{

}

- (bool) isActive
{
    return isActive;
}

- (CCSprite *) qixSprite
{
    return _qixMonster;
}

- (b2Body *) qixBody
{
    return _qixMonsterBody;
}

- (void) hitByArmor:(enum QXArmorType)type from:(CGPoint)from time:(ccTime)time
{
    
}
@end

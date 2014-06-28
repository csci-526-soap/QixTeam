//
//  QXQixBoss.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/10/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonster.h"
#import "QXArmor.h"

@interface QXQixBoss : QXMonster {
    bool startSpawning;
    bool isSpawning;
}
- (void) takeAction:(ccTime) time spawnMissile:(void (^)(bool isSpawning, bool start, int tag)) spawnMissile;

- (void) stopAction;

- (void) fire:(ccTime) delta;

- (void) clear;

- (CCSprite *) findQixBodyByIndex:(int)index;

- (QXArmor *)armor;

- (bool) isSpawningFire;

@end

//
//  QXExplosion.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "QXPlayers.h"
#import "QXMap.h"

enum QXExplosionType {EPLAYER, EGUARD, EWALKER, EQIX, EPLAYER_MISSILE_QIX_MISSILE, ETIME_BOMB};

@interface QXExplosion : NSObject {
    CCSprite *playerExplosion;
    CCSprite *simpleMonsterExplosion;
    CCSprite *simpleQixExplosion;
    CCSprite *qixExplosion;
}

+ (QXExplosion *) sharedExplosion;

- (void) setup;

- (void) explode:(NSString *)plistName spriteName:(NSString *)spriteName batchNodeName:(NSString *) batchNodeName spriteFrameName:(NSString *) spriteFrameName layer:(CCLayer *)layer position:(CGPoint)position;

- (void) explode:(enum QXExplosionType)explodeType layer:(CCLayer *)layer position:(CGPoint)position;

@end

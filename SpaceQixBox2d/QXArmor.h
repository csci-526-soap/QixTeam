//
//  QXArmor.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "QXObject.h"
#import "GB2ShapeCache.h"

#define KEY_ARMORS @"armors"
#define KEY_ARMOR @"armor"

enum QXArmorType {FireArmor, GuidedMissile, ScatteredMissile, TimeBomb, DrillArmor};

@interface QXArmor : QXObject {
    CCSprite *armor;
    b2Body *body;
    
    CCSprite *pickUpImg;
    
    CCLayer *_layer;
    b2World *_world;
    
    bool pickedUp;
}

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world;

- (void) fire:(ccTime)delta fromPosition:(CGPoint)position target:(CGPoint)target direction:(int)direction fireStop:(void (^)(int armorIndex)) fireStop;

- (CCSprite *) missile:(int)tag;

- (void) cleanUpSpecificMissile:(int)tagNum;

- (void) cleanUpMissiles;

- (void) cleanUpMissilesOutOfScreen;

// return the number of missiles claimed by the player
- (int) cleanUpMissilesInClaimedArea;

- (CCSprite *) spawnArmor:(CGPoint) position;

- (void) explode;

// return true is the armor is picked up.
- (bool) pickup;

- (CCSprite *) armorSprite;

@end

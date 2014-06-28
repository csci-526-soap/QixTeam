//
//  QXPlayers.h
//  Cocos2dTest
//
//  Created by Haoyu Huang on 2/24/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "QXPlayer.h"
#import "QXPlayerAttributes.h"
#import "QXFireArmor.h"
#import "Box2D.h"
#import "GB2ShapeCache.h"
#import "QXExplosion.h"
#import "QXShield.h"

@class QXExplosion;
static const int highestVelocity = 2;
static const int accelerateVelocity = 3;

@interface QXPlayers : NSObject {
    int headDirection;
    NSMutableArray *anglePoints;
    CCLayer *_layer;
    b2World *_world;
    ccTime accelerate;
    bool accelerateEnabled;
    int playerVelocity;
    CGPoint mainPlayerPosition;
    double mainPlayerRotation;
    NSMutableArray *players;
    
    QXFireArmor *fireArmor;
    double fireTime;
    CCSprite *glacierFrozen;
    
    QXPlayerAttributes *attribute;
    
    // the player will be invincible for a while when the game the start or when the player is respawned
    double invincibleTimeStep;
    bool isInvincible;
    bool isWaitingForRespawn;
    QXShield *shield;
}

+ (QXPlayers *)sharedPlayers;

- (void) setup:(CCLayer *) layer physicalWorld:(b2World *)world userData:(void *)data;

- (void) fireFrozenMissile: (CCLayer *)layer qixPosition: (CGPoint)position qixSize: (CGSize)size;
- (CCSprite *) frozenMissileSprite;

- (QXFireArmor *)fireArmor;
- (void) fire:(ccTime) time dir:(int) dir;

- (void) setup:(CCLayer *) layer physicalWorld:(b2World *)world userData:(void *)data playerAttribute:(QXPlayerAttributes *)attribute;

- (void) build:(QXBaseAttribute *)attribute;

- (void) moveFrom:(ccTime)time from:(CGPoint) from to:(CGPoint)to prevDirection:(int)prevDir direction:(int)direction;

- (CGPoint) mainPlayerPosition;

- (void) enableAccelerate;

- (void) disableAccelerate;

- (QXPlayer *) mainPlayer;

- (int) velocity;

- (void) setV:(int)velocity;

- (bool) isInvincible;

- (double) mainPlayerRotation;

- (void) reSpawn;

- (bool) isWaitingForRespawn;

- (void) waitingForRespawn;
@end



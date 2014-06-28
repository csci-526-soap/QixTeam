//
//  QXPlayerAttributes.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "QXBaseAttribute.h"

#define KEY_PLAYERS @"players"
#define KEY_PLAYER @"player"
#define KEY_PLAYER_HIGH_DEFENCE @"highDefence"
#define KEY_PLAYER_AGILE @"agile"
#define KEY_PLAYER_HIGH_ATTACK @"highAttack"

#define KEY_VELOCITY @"velocity"
#define KEY_ACCELERATE_RATE @"accelerateRate"
#define KEY_NITROGEN_ADDED_RATIO @"nitrogenAddedRatio"
#define KEY_NITROGEN_COMSUMPTION_RATIO @"nitrogenConsumptionRatio"
#define KEY_DEFENCE @"defence"
#define KEY_INIT_NITROGEN @"initNitrogen"

#define KEY_INIT_INVINCIBLE_TIME @"invincibleTime"

#define BODY_PLAYER @"bodyPlayer"

enum QXPlayerType {QXPlayerHighDefense, QXPlayerHighAttack, QXPlayerAgile};

@interface QXPlayerAttributes : QXBaseAttribute {
    enum QXPlayerType type;
    int _speed;
    double _accelerateRate;
    double _initialNitrogen;
    double _nitrogenAddedRatio;
    double _nitrogenConsumptionRatio;
    int _defence;
    double _invincibleTime;
//    QXArmor *armor;
    
    // the image displays in the shop
    CCSprite *shopImage;
}

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description speed:(int) speed accelerateRate:(double)accelerateRate initialNitrogen:(double)initialNitrogen nitrogenAddedRatio:(double)nitrogenAddedRatio nitrogenConsumptionRatio:(double)nitrogenConsumptionRatio defence:(int)defence;

- (int) speed;

- (double) accelerateRate;

- (double) initialNitrogen;

- (double) nitrogenAddedRatio;

- (double) nitrogenConsumptionRatio;

- (int) defence;

- (double) invincibleTime;

@end

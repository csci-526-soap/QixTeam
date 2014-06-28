//
//  QXGamePlay.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 4/4/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "QXMap.h"
#import "QXPlayerConfig.h"
#import "QXMonsterConfig.h"
#import "QXArmorConfig.h"
#import "QXLevelMananger.h"
#import "QXPlayerAttributes.h"
#import "QXWalkerAttribute.h"
#import "QXGuardAttribute.h"
#import "QXQixAttribute.h"
#import "QXBaseAttribute.h"

#define KEY_GAME @"game"
#define KEY_GAME_LIFE @"life"
#define KEY_GAME_TOTAL_LEVEL @"totalLevel"
#define KEY_GAME_UNLOCKED_LEVEL @"unlockedLevel"

@interface QXGamePlay : NSObject <NSXMLParserDelegate> {
    int isWin;
    int isPlaying;
    int isLose;
    QXPlayerConfig *playerConfig;
    QXMonsterConfig *monsterConfig;
    QXArmorConfig *armorConfig;
    bool configured;
    bool reset;
    int life;
    int totalLevel;
    int unlockedLevel;
}

+ (QXGamePlay *)sharedGamePlay;

// read game configuration file
- (void) readConfig;

// initialize the game
- (void) setup;

// player wins the game
- (void) win;

// player lose a life or lose the game
- (void) lose:(void (^)(bool isOver, int life)) callback;

// reset the game to its initial state
- (void) reset;

- (bool) isWin;

- (bool) isLose;

- (bool) isPlaying;

- (int) remainingLife;

- (void) loseLife;

- (void) winLife;

- (int) unlockedLevel;

- (void) unlockNextLevel;

- (int) totalLevel;
@end

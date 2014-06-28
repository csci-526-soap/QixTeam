//
//  QXLevelMananger.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXLevel.h"
#import "QXPlayerConfig.h"
#import "QXArmorConfig.h"
#import "QXMonsterConfig.h"
#import "QXBaseAttribute.h"
#import "QXMonster.h"
#import "QXPlayer.h"
#import "QXArmor.h"


@interface QXLevelMananger : NSObject <NSXMLParserDelegate>  {
    NSMutableArray *levels;
    QXLevel *activeLevel;
    QXArmorConfig *_armorConfig;
    QXPlayerConfig *_playerConfig;
    QXMonsterConfig *_monsterConfig;
    
    // class memebers used for reading xml
    QXLevel *_level;
    QXBaseAttribute *_armor;
    QXBaseAttribute *_qix;
    QXBaseAttribute *_player;
    NSString *currentObject;
}

+ (QXLevelMananger *) sharedLevelManager;

- (void) setup:(QXArmorConfig *)armorConfig playerConfig:(QXPlayerConfig *)playerConfig monsterConfig:(QXMonsterConfig *)monsterConfig;

// player has been played to this level
- (QXLevel *) activeLevel;

// find level object by level Id
- (QXLevel *) findLevelById:(int) Id;

// find monster by monster Id and monster type
- (QXBaseAttribute *) findMonsterById:(int) Id withType:(enum QXQixType) type;

// find player by player Id and player type
- (QXBaseAttribute *) findPlayerById:(int) Id withType:(enum QXPlayerType) type;

// find armor by armor Id and type
- (QXBaseAttribute *) findArmorById:(int) Id withType:(enum QXArmorType) type;

@end

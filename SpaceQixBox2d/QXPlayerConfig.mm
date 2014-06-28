//
//  QXPlayerConfig.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXPlayerConfig.h"

@implementation QXPlayerConfig

- (void) addPlayer:(NSDictionary *)attributes
{
    NSString *name = [attributes objectForKey:KEY_NAME];
    if ([name isEqualToString:KEY_PLAYER_AGILE]) {
        playerAgile = [[QXPlayerAttributes alloc] init];
        [playerAgile build:attributes];
    } else if ([name isEqualToString:KEY_PLAYER_HIGH_ATTACK]) {
        playerHighAttack = [[QXPlayerAttributes alloc] init];
        [playerHighAttack build:attributes];
    } else if ([name isEqualToString:KEY_PLAYER_HIGH_DEFENCE]) {
        playerHighDefense = [[QXPlayerAttributes alloc] init];
        [playerHighDefense build:attributes];
    }
}

- (void) loadPlayerType:(QXPlayerAttributes *)attribute type:(enum QXPlayerType)type
{
    // initialize high attack player, high defense player, agile player.
    switch (type) {
        case QXPlayerAgile:
            break;
        case QXPlayerHighAttack:
            break;
        case QXPlayerHighDefense:
            break;
        default:
            break;
    }
}

- (QXPlayerAttributes *) getPlayerType:(enum QXPlayerType)type
{
    switch (type) {
        case QXPlayerHighAttack:
            return playerHighAttack;
        case QXPlayerAgile:
            return playerAgile;
        case QXPlayerHighDefense:
            return playerHighDefense;
        default:
            break;
    }
}

- (QXPlayerAttributes *) findPlayerById:(int) Id
{
    if (playerHighAttack.ID == Id) {
        return playerHighAttack;
    } else if (playerAgile.ID == Id) {
        return playerAgile;
    } else if (playerHighDefense.ID == Id) {
        return playerHighDefense;
    }
    return nil;
}
@end

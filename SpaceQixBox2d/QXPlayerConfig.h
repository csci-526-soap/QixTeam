//
//  QXPlayerConfig.h
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXPlayerAttributes.h"

@interface QXPlayerConfig : NSObject {
    QXPlayerAttributes *playerHighDefense;
    QXPlayerAttributes *playerHighAttack;
    QXPlayerAttributes *playerAgile;
}

- (void) addPlayer:(NSDictionary *)attributes;

- (void) loadPlayerType:(QXPlayerAttributes *)attribute type:(enum QXPlayerType)type;

- (QXPlayerAttributes *) getPlayerType:(enum QXPlayerType)type;

- (QXPlayerAttributes *) findPlayerById:(int) Id;
@end

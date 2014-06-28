//
//  QXMonsterConfig.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXGuardAttribute.h"
#import "QXMonster.h"
#import "QXBaseAttribute.h"
#import "QXWalkerAttribute.h"
#import "QXQixAttribute.h"

@interface QXMonsterConfig : NSObject {
    NSMutableArray *walkersAttributes;
    NSMutableArray *qixAttributes;
    NSMutableArray *guardAttributes;
    NSMutableArray *snakeAttributes;
}

- (void) setup;

- (void) addMonster:(NSDictionary *)attributes;

- (void) loadMosnter:(QXBaseAttribute *)attribute qixType:(enum QXQixType)type;

- (NSMutableArray *) getMonster:(enum QXQixType) type;

- (QXWalkerAttribute *) findWalkerById:(int) Id;

- (QXQixAttribute *) findQixById:(int) Id;

- (QXGuardAttribute *) findGuardById:(int) Id;


@end

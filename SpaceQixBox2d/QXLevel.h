//
//  QXLevel.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXPlayerAttributes.h"
#import "QXBaseAttribute.h"

#define KEY_LEVELS @"levels"
#define KEY_LEVEL @"level"
#define KEY_ACTIVE @"active"

@interface QXLevel : NSObject {
    int _levelId;
    bool _isActive;
    NSMutableArray *qixs;
    NSMutableArray *armors;
    QXBaseAttribute *playerAttributes;
}

- (void) build:(NSDictionary *) levelAttributes;

- (void) setup:(int) levelId active:(bool)isActive;

- (void) addQix:(QXBaseAttribute *) qix;

- (void) addArmor:(QXBaseAttribute *) armor;

- (void) addPlayer:(QXBaseAttribute *) player;

- (int) levelId;

- (bool) isActive;

- (NSArray *) qixs;

- (NSArray *) armors;

- (QXBaseAttribute *) playerAttribute;

@end

//
//  QXDropItemArmor.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/17/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmor.h"
#import "QXTimeBombAttribute.h"
#import "QXExplosion.h"
#import "QXTimerEffect.h"

#define BODY_SNAKE_ITEM_PREFIX @"bodySnakeItemBody"

@interface QXTimeBomb : QXArmor {
    NSMutableArray *_items;
    int itemIndex;
    NSMutableArray *itemTags;
    
    QXTimeBombAttribute *attribute;
    
    NSMutableDictionary *timers;
}

- (NSMutableArray *)items;

- (int) currentItemIndex;

@end

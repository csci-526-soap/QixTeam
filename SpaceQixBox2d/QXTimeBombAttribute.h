//
//  QXTimeBombAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/19/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmorAttribute.h"

#define KEY_TIME_BOMB_TIMER @"timer"

@interface QXTimeBombAttribute : QXArmorAttribute {
    double timer;
}

- (double) timer;
@end

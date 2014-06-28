//
//  QXQixWalkerAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonsterAttribute.h"

#define KEY_CLOCKWISE @"clockwise"
#define KEY_RUN_DIRECTION @"runDirection"
#define KEY_SPEED @"speed"
#define KEY_WALKER @"walker"

@interface QXWalkerAttribute : QXMonsterAttribute {
    int runDirection;
    bool clockwise;
    int speed;
}

- (int) runDirection;

- (bool) clockwise;

- (int) speed;

- (void) updateDirection:(int) direction;

@end

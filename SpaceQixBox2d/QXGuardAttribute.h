//
//  QXQixGuardAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonsterAttribute.h"

#define KEY_GUARD @"guard"
#define KEY_RADIUS @"radius"

@interface QXGuardAttribute : QXMonsterAttribute {
    double radius;
}

- (double) radius;

@end

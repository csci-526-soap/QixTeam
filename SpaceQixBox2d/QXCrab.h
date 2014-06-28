//
//  QXCrab.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/17/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXQixBoss.h"
#import "QXCrabAttribute.h"

#define BODY_CRAB @"bodyCrab"

@interface QXCrab : QXQixBoss {
    QXCrabAttribute *attribute;
    float moveStep;
    float stepDuration;
    int headAngle;
    int angleChange;
    CGPoint newPos;
    float shadeTime;
    float shadeTimeOver;
    float shadeStep;
}

- (QXCrabAttribute *)attribute;
-(void)crabQixFire:(id)sender;
@end

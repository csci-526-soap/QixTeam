//
//  QXLaserAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/20/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXBaseAttribute.h"

#define KEY_EMIT_DELAY @"emitDelay"
#define KEY_EMIT_DURATION @"emitDuration"

@interface QXLaserAttribute : QXBaseAttribute {
    double emitDelay;
    double emitDuration;
}

- (double) emitDelay;

- (double) emitDuration;

@end

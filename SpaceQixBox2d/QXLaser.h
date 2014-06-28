//
//  QXLaser.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/20/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXArmor.h"
#import "QXLaserAttribute.h"

#define BODY_BEAM_ARMOR @"beamArmorBody"

@interface QXLaser : QXArmor {
    int preAngle;
    double delayStep;
    double emitStep;
    
    QXLaserAttribute *attribute;
}

@end

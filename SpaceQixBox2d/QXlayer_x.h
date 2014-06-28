//
//  QXlayer_x.h
//  SpaceQix
//
//  Created by Student on 4/6/14.
//  Copyright (c) 2014 Wenjiaxie. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "QXGameLayer.h"
#import "QXSnake.h"
#import "QXLaserQix.h"
#import "QXSurrander.h"

@interface QXlayer_x : QXGameLayer {
    
    QXLaserQix *qix;
    QXSurrander *guardQix1;
    QXSurrander *guardQix2;
    QXSurrander *guardQix3;
    
    bool playerCollideWithQix;
    bool playerCollideWithGuard1;
    bool playerCollideWithGuard2;
    bool playerCollideWithGuard3;
    bool qixCollideWithWorld;
    bool playerCollideWithLaser;
    
    bool playerQuickAutoMissileGuard3;
    bool playerQuickAutoMissileGuard2;
    bool playerQuickAutoMissileGuard1;
    bool playerQuickAutoMissileQix;
    
    int oneTimeCollisionListen;
}

@end
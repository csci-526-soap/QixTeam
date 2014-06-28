//
//  Level1Layer.h
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright 2014 Xin ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXGameLayer.h"
#import "QXSnake.h"

// The level has one qix surrouded by three small qixes and two walker

@interface QXLevel1Layer : QXGameLayer {
    
    QXQix *qix;
    QXGuard *guardQix1;
    QXGuard *guardQix2;
    QXGuard *guardQix3;
    
    bool playerCollideWithQix;
    bool playerCollideWithGuard1;
    bool playerCollideWithGuard2;
    bool playerCollideWithGuard3;
    bool playerCollideWithMissile;
    
    bool playerQuickAutoMissileGuard3;
    bool playerQuickAutoMissileGuard2;
    bool playerQuickAutoMissileGuard1;
    bool playerQuickAutoMissileQix;
    bool playerQuickAutoMissileNSWalker;
    bool playerQuickAutoMissileNWWalker;
    bool playerQuickAutoMissileQixMissile;
    
    bool qixCollideWithWorld;
    
    int oneTimeCollisionListen;
    
}

@end

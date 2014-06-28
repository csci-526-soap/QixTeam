//
//  Level2Layer.h
//  Cocos2dTest
//
//  Created by 李 彦霏 on 14-2-2.
//  Copyright 2014年 Xin ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"
#import "QXGameLayer.h"
#import "QXCrab.h"

// the level has one crab-like qix and two walker

@interface QXLevelCrabLayer : QXGameLayer {
    QXCrab *crab;
    
    bool playerCollideWithCrab;
}

@end

//
//  QXLevel4Layer.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/17/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXGameLayer.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "QXGameLayer.h"
#import "QXSnake.h"
#import "QXTimerEffect.h"

// the level has one snake-like qix and two walker

@interface QXLevelSnakeLayer : QXGameLayer {
    QXSnake *snake;
    
    bool snakeCollideWithPlayer;
    bool snakeItemCollideWithPlayer;
}

@end

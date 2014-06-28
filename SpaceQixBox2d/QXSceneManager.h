//
//  SceneManager.h
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXIntroLayer.h"
#import "QXMenuLayer.h"
#import "QXLevel1Layer.h"
#import "QXLevelCrabLayer.h"
#import "QXLevelSnakeLayer.h"
#import "QXFinalLevelLayer.h"
#import "CCScrollLayerTestLayer.h"
#import "CCScrollLayer.h"
#import "QXlayer_x.h"
#import "QXGameLayer.h"
#import "QXMedalSystem.h"
#import "QXMedalLayer.h"
#import "QXMainLayer.h"

#define LEVEL_1 1
#define LEVEL_2 2
#define LEVEL_3 3
#define LEVEL_4 4
#define LEVEL_5 5


@interface QXSceneManager : NSObject{
    
}

+(void) goIntro;
+(void) goMenu;
+(void) goNewGame;
+(void) goLevel1;
+(void) goLevel2;
+(void) goLevel3;
+(void) goLevel4;
+(void) goLevel5;
+(void) goMainLayer;
+(void) goShop;
+(void) xLayer;
+(void) goRandomLevel:(int)totalLevel currentLevel:(int)level;
+(void) goLevel:(int) level;
+(void) goMedalLayer;
@end

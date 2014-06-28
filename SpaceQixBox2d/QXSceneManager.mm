//
//  SceneManager.m
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import "QXSceneManager.h"
#import "cocos2d.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

@implementation QXSceneManager

+(void) goIntro{
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXIntroLayer node];
    
    [newScene addChild: layer];
    
    [director runWithScene: newScene];
}

+(void) goShop{
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [CCScrollLayerTestLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) xLayer{
    
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXlayer_x node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
    
}

+(void) goMenu{
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXMenuLayer node];
    
    [newScene addChild: layer];
    
    [[CDAudioManager sharedManager].soundEngine stopAllSounds];

   // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
    
}


+(void) goLevel1{
    
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXLevelCrabLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
    
}


+(void) goLevel2{
    
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXlayer_x node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) goLevel3
{
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXLevelSnakeLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) goLevel4
{
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXFinalLevelLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) goLevel5
{
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXFinalLevelLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) goLevel:(int) level
{
    switch (level) {
        case LEVEL_1:
            [QXSceneManager goLevel1];
            break;
        case LEVEL_2:
            [QXSceneManager goLevel2];
            break;
        case LEVEL_3:
            [QXSceneManager goLevel3];
            break;
        case LEVEL_4:
            [QXSceneManager goLevel4];
            break;
        case LEVEL_5:
            [QXSceneManager goLevel5];
            break;
        default:
            break;
    }
}

+(void) goRandomLevel:(int)totalLevel currentLevel:(int)level
{
    int randomLevel = arc4random() % totalLevel;
    randomLevel++;
    if (randomLevel == level) {
        randomLevel = (randomLevel + 1) % totalLevel;
    }
    [self goLevel:randomLevel];
}

+(void) goNewGame{
    
    [[QXMedalSystem sharedMedalSystem] onGameLevelBegin];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXFinalLevelLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) goMedalLayer
{
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXMedalLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

+(void) goMainLayer
{
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [CCScene node];
    
    CCLayer *layer = [QXMainLayer node];
    
    [newScene addChild: layer];
    
    // [director replaceScene: newScene];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: newScene]];
}

@end

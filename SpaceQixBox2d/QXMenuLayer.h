//
//  HelloWorldLayer.h
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright Xin ZHANG 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MenuLayer
//@interface MenuLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
@interface QXMenuLayer : CCLayer
{
    CCSprite *layerBack;
    CCLayer *layer1;
    CCLayer *layer2;
    
    CCSprite *airplane;
    CCSprite *airplane2;
    CCSprite *airplane3;
    
    double rotateAngel;
    double specialAngle;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

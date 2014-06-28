//
//  MyCocos2DClass.m
//  SpaceQix
//
//  Created by 李旸 on 14-4-26.
//  Copyright 2014年 HaoyuHuang. All rights reserved.
//

#import "QXMainLayer.h"

@implementation QXMainLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QXMainLayer *layer = [QXMainLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

- (id) init
{
    self = [super init];
    [self setTouchEnabled:YES];
    
    CCSprite *backGround = [CCSprite spriteWithFile:@"menu.png"];
    backGround.anchorPoint = ccp(0,0);
    
    // layerBack.position =  ccp( size.width * 0.5f , size.height * 0.5f );
    [self addChild: backGround];
    
    [[QXGamePlay sharedGamePlay] readConfig];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *title = [CCSprite spriteWithFile:@"fplabel.png"];
    title.position = ccp(winSize.width/2, 0.9 * winSize.height);
    
    CCMenuItemImage *start = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"startpress.png" disabledImage:@"" target:self selector:@selector(start:)];
    start.position = ccp(0.7 * winSize.width, 0.4 * winSize.height);
    CCMenuItemImage *selectLevel = [CCMenuItemImage itemWithNormalImage:@"selectL.png" selectedImage:@"selectLpress.png" disabledImage:@"" target:self selector:@selector(selectLevel:)];
    selectLevel.position = ccp(0.7 * winSize.width, 0.25 * winSize.height);
    CCMenuItemImage *medal = [CCMenuItemImage itemWithNormalImage:@"scoreBut.png" selectedImage:@"scoreButpress.png" disabledImage:@"" target:self selector:@selector(medal:)];
    medal.position = ccp(0.7 * winSize.width, 0.1 * winSize.height);
    CCMenu *menu = [CCMenu menuWithItems:start, selectLevel, medal, Nil];
    menu.position = CGPointZero;
    
    [self addChild:title];
    [self addChild:menu];
    return self;
}

- (void) start:(id) sender
{
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goLevel:[[QXGamePlay sharedGamePlay] unlockedLevel] - 1];
}

- (void) selectLevel:(id) sender
{
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goMenu];
}

- (void) medal:(id) sender
{
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    [QXSceneManager goMedalLayer];
}

@end

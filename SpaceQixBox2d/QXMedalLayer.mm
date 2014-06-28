//
//  QXMedalLayer.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/26/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMedalLayer.h"

@implementation QXMedalLayer

//+(CCScene *) scene
//{
//    
//    // 'scene' is an autorelease object.
//	CCScene *scene = [CCScene node];
//	
//	// 'layer' is an autorelease object.
//	QXMainLayer *layer = [QXMainLayer node];
//	
//	// add layer as a child to scene
//	[scene addChild: layer z:0];
//	
//	// return the scene
//	return scene;
//	
//	return scene;

+(CCScene*)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QXMedalLayer *layer = [QXMedalLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

- (id) init
{
    self = [super init];
    [self setTouchEnabled:YES];
    
    CCSprite *background = [CCSprite spriteWithFile:@"medalBackground.png"];
    background.anchorPoint = ccp(0,0);
    [self addChild: background];
    
    QXMedal *medal0 = [QXMedal getMedalByType:MEDAL_DIE];
    
    [medal0 medal].position = ccp(200,250);
    [medal0 medal].scale = 0.3;
    [self addChild:[medal0 medal]];
    
    QXMedal *medal1 = [QXMedal getMedalByType:MEDAL_KILLED_BY_LASER];
    
    [medal1 medal].position = ccp(200,200);
    [medal1 medal].scale = 0.3;
    [self addChild:[medal1 medal]];
    
    
    QXMedal *medal2 = [QXMedal getMedalByType:MEDAL_KILLED_BY_MISSILE];
    
    [medal2 medal].position = ccp(200,150);
    [medal2 medal].scale = 0.3;
    [self addChild:[medal2 medal]];
    
    CCLabelTTF *des0 =[CCLabelTTF labelWithString:[medal0 description] fontName:@"Helvetica"
                                         fontSize:12] ;
    
    CCLabelTTF *des1 =[CCLabelTTF labelWithString:[medal1 description] fontName:@"Helvetica"
                                         fontSize:12] ;
    
    CCLabelTTF *des2 =[CCLabelTTF labelWithString:[medal2 description] fontName:@"Helvetica"
                                         fontSize:12] ;
    
    des0.position = ccp(310,250);
    des1.position = ccp(310,200);
    des2.position = ccp(310,150);
    
    
    
    CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"backpress.png" disabledImage:@"" target:self selector:@selector(goBack:)];
    
    CCMenu *backMenu = [CCMenu menuWithItems:goBack, nil];
    backMenu.position = ccp(530, 30);
    
    [self addChild:des0];
    [self addChild:des1];
    [self addChild:des2];
    [self addChild:backMenu];
    return self;
}

- (void) goBack:(id) sender
{
    [QXSceneManager goMainLayer];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
	[super dealloc];
}

@end

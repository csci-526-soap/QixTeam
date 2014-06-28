//
//  IntroLayer.m
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright Xin ZHANG 2014. All rights reserved.
//


// Import the interfaces
#import "QXIntroLayer.h"
#import "QXMenuLayer.h"
#import "QXMainLayer.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation QXIntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QXIntroLayer *layer = [QXIntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
    
        
        background = [CCSprite spriteWithFile:@"introBackground.png"];
//        background.rotation = 90;
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    [QXSceneManager goMainLayer];
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[QXMainLayer scene] ]];
}
@end

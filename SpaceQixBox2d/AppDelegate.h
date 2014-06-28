//
//  AppDelegate.h
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright Xin ZHANG 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#define CGROUP_BG       kASC_Left    // Channel for background music
#define CGROUP_EFFECTS  kASC_Right   // Channel for sound effects
#define SND_BG_LOOP 0     // Identifier for background music audio
#define SND_BOMB    1     // Identifier for click sound effect
#define SND_MSL     2     // Identifier for misile sound effect
#define SND_ELE     3     // electrical
#define SND_PLA     4     // player missile
#define SND_DRP     5
#define SND_BRK     6
#define SND_STP     7
#define SND_INV     8
// Helper macro for playing sound effects
//#define playEffect(__ID__)      [[CDAudioManager sharedManager].soundEngine playSound:__ID__ sourceGroupId:CGROUP_EFFECTS pitch:1.0f pan:0.0f gain:1.0f loop:NO]

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
//	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
//@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end

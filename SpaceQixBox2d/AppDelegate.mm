//
//  AppDelegate.m
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright Xin ZHANG 2014. All rights reserved.
//

#import "cocos2d.h"
#import "QXSceneManager.h"
#import "AppDelegate.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"


@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	//if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskLandscape;
}

@end


@implementation AppController

//@synthesize window=window_, navController=navController_, director=director_;
@synthesize window=window_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
    
	//[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
    
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPhone HD: "-hd"
    
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
		
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	
    
	// set the Navigation Controller as the root view controller
	//[window_ setRootViewController:navController_];
    [window_ setRootViewController:director_];
    
    
	// make main window visible
	[window_ makeKeyAndVisible];
    
    [QXSceneManager goIntro];
    
    CDSoundEngine *sse = [CDAudioManager sharedManager].soundEngine; // preload of sound files
    NSArray *sourceGroups = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:31], nil];
    [sse defineSourceGroups:sourceGroups]; // 32 sound channels
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio]; //Initializes the engine asynchronously with a mode
    NSMutableArray *loadRequests = [[[NSMutableArray alloc] init] autorelease];//Load sound buffers asynchrounously 异步加载声音缓存
    
    /**
     定义了一组声音文件准备加载
     每一个CDBufferLoadRequest都使用一个integer去标识一个声音文件的路径（file path）以后可以使用这个整型数去调用声音文件
    */
    
    //注意所载入的音效不可以超过32个
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_BG_LOOP filePath:@"bgmusic.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_BOMB filePath:@"bomb.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_MSL filePath:@"missile.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_ELE filePath:@"electrical.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_PLA filePath:@"player missile.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_DRP filePath:@"icebergDrop.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_BRK filePath:@"icebergBrake.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_STP filePath:@"creature_footstep_large.mp3"]];
    [loadRequests addObject:[[CDBufferLoadRequest alloc] init:SND_INV filePath:@"player_invisible.mp3"]];
    
    
    //异步加载这些声音
    [[CDAudioManager sharedManager].soundEngine loadBuffersAsynchronously:loadRequests];
    
	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	//if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];	
	//if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	//if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	//if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	//[navController_ release];
	[[CCDirector sharedDirector] release];
	[super dealloc];
}
@end


#import "CCScrollLayerTestLayer.h"
#import "CCScrollLayer.h"

@implementation CCScrollLayerTestLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CCScrollLayerTestLayer *layer = [CCScrollLayerTestLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        screenSize = [CCDirector sharedDirector].winSize;
        startPage = 0;
        
        CCSprite *backgroundImage;
        backgroundImage = [CCSprite spriteWithFile:@"sky.png"];
        backgroundImage.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:backgroundImage z:-1000 tag:0];
        
        // Do initial positioning & create scrollLayer.
        
		CCScrollLayer *scrollLayer = (CCScrollLayer *)[self getChildByTag:100];
        scrollLayer = [self scrollLayer];
        [self addChild: scrollLayer z: 0 tag:100];
        [scrollLayer selectPage: 1];
        scrollLayer.delegate = self;
        
        [self startPage];
        
	}
	return self;
}

#pragma mark ScrollLayer Creation

// Returns array of CCLayers - pages for ScrollLayer.
- (NSArray *) scrollLayerPages
{
    // PAGE 0 - Simple Label in the center.
	CCLayer *pageZero = [CCLayer node];
	CCLabelTTF *label0 = [CCLabelTTF labelWithString:@"PLANE1" fontName:@"Arial Rounded MT Bold" fontSize:40];
	label0.position =  ccp( screenSize.width /2 , screenSize.height/2 );
	[pageZero addChild:label0];

	// PAGE 1 - Simple Label in the center.
	CCLayer *pageOne = [CCLayer node];
	CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"PLANE2" fontName:@"Arial Rounded MT Bold" fontSize:40];
	label1.position =  ccp( screenSize.width /2 , screenSize.height/2 );
	[pageOne addChild:label1];
    
    // PAGE 2 - Simple Label in the center.
	CCLayer *pageTwo = [CCLayer node];
	CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"PLANE3" fontName:@"Arial Rounded MT Bold" fontSize:40];
	label2.position =  ccp( screenSize.width /2 , screenSize.height/2 );
	[pageTwo addChild:label2];
    
    // PAGE 3 - Simple Label in the center.
	CCLayer *pageThree = [CCLayer node];
	CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"PLANE4" fontName:@"Arial Rounded MT Bold" fontSize:40];
	label3.position =  ccp( screenSize.width /2 , screenSize.height/2 );
	[pageThree addChild:label3];
	
	return [NSArray arrayWithObjects: pageZero,pageOne,pageTwo,pageThree,nil];
}

// Creates new Scroll Layer with pages returned from scrollLayerPages.
- (CCScrollLayer *) scrollLayer
{
	// Create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages).
	CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0.52f * screenSize.width ];
	scroller.pagesIndicatorPosition = ccp(screenSize.width * 0.5f, 30.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
    scroller.marginOffset = 0.5f * screenSize.width;
	
	return scroller;
}

#pragma mark Callbacks

- (void) startPage
{
	CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:100];
	[scroller moveToPage: startPage];
}

#pragma mark Scroll Layer Callbacks

- (void) scrollLayerScrollingStarted:(CCScrollLayer *) sender
{
	//NSLog(@"Scrolling started");
}

- (void) scrollLayer: (CCScrollLayer *) sender scrolledToPageNumber: (int) page
{
	//NSLog(@"Scrolled To Page Number: %d", page);
}

@end



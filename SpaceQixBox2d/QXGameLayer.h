//
//  QXGameLayer.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCJoyStick.h"
#import "Box2D.h"
#import "QXPlayers.h"
#import "QXPlayer.h"
#import "QXWalker.h"
#import "DACircularProgressView.h"
#import "MyContactListener.h"
#import "QXQix.h"
#import "QXGuard.h"
#import "QXExplosion.h"
#import "QXArmor.h"
#import "QXGamePlay.h"
#import "QXLevelMananger.h"
#import "QXLaserQix.h"
#import "QXTimerEffect.h"
#import "QXMedalSystem.h"

#define PTM_RATIO 32.0
#define SCRATCHABLE_IMAGE   10
#define LABEL_TEXT          20
#define BODY_WORLD @"world"

@interface QXGameLayer : CCLayer<CCJoyStickDelegate> {
    
    int levelId;
    
    // score
    CCLabelTTF *labelScore;
    double score;
    NSMutableArray *lifeIcons;
    
    //explosion
    QXExplosion *explosion;
    
    QXWalker *nwWalker;
    QXWalker *nsWalker;
    
    bool playerCollideWithWalkerNS;
    bool playerCollideWithWalkerNW;
    
    // reveal sprites
    CCSprite *revealSprite;
    CCTexture2D *background;
    
    // physical world
    b2World *_world;
    MyContactListener *_contactListener;
    
	CCJoyStick *myjoysitck;
    CCSprite *back;
    CGPoint cgPoint;
    CGPoint pspeed;
    int prevDirection;
    
    int mapWidth;
    int mapHeight;
    DACircularProgressView* progressBar;
    
    /******************/
    CCSprite *frozenArmor;
    BOOL withArm;
    BOOL withArm1;
    BOOL withArm2;
    /**************************/
     int timerStart ;
     int timerStartCount;
    /**************************/
     
}

// the following methods are optional for subclasses to override

// the backgroun image path
- (NSString *)backgroundImagePath;

// the revealed image path
- (NSString *) revealedImagePath;

// initialize mosnters (this method is called after the player is initilized)
- (void) initMonsters;

// monster take actions (this method is called once per frame after moving the player)
- (void) monsterTakeActions:(ccTime) frameDuration;

// the position of the Qix (this method is called when the game needs to decide which area is claimed by the player)
- (CGPoint) qixPosition;

// move player by using joysticks with direction (this method is called once per frame, subclass which overrides this method should call [super onPlayerMovingState])
- (void) onPlayerMovingState:(int) direction frameDuration:(ccTime)frameDuration;

// player claim area state (this method is called when the player claims an area, subclass which overrides this method should call [super onClaimAreaState])
- (void) onClaimAreaState;

// ensure position consistency between cocos2d sprites and box2d b2Bodies. (this method is called once per frame for each b2Body in the physical world, subclass which overrides this method should call [super onCocosAndBoxPositionUpdate] to update the player's position)
- (void) onCocosAndBoxPositionUpdate:(b2Body *)body;

// detect object collisions (this method is called once per frame for every two objects that has collision)
- (bool) onBox2dCollisionDetection:(b2Body *)body1 body2:(b2Body *)body2 toDestroy:(std::vector<b2Body *>)toDestroy;

// subclass should override this method to do follow-up actions if collisions are detected
- (void) afterBox2dCollisionDetetion;

// dealloc (this method is called when the layer class is destroyed, subclass which overrides this method should call [super onDealloc])
- (void) onDealloc;

// respawn the player
- (void) respawn;

- (void) lose;
@end

//
//  NewGameLayer.h
//  Cocos2dTest
//
//  Created by 李 彦霏 on 14-2-2.
//  Copyright 2014年 Xin ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  cocos2d;
#import "CCJoyStick.h"
@class  AppDelegate;
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

#define PTM_RATIO 32.0
#define SCRATCHABLE_IMAGE   10
#define LABEL_TEXT          20

// the level has one qix armored with scattered missile, three guard qixes and two walker

@interface QXFinalLevelLayer : CCLayer<CCJoyStickDelegate> {
    
    /***********记分变量**************/
    
    CCLabelTTF *labelScore;
    /*************************/
    NSMutableArray *lifeIcons;
    
    
    /**************************/
    int effectIndex;
    CCParticleSun * sun;
    CCParticleMeteor * moon;
    /**************************/
    
    NSMutableArray * _weaponParticle;
    
    QXWalker *nwWalker;
    QXWalker *nsWalker;
    QXQix *qix;
    QXGuard *guardQix1;
    QXGuard *guardQix2;
    QXGuard *guardQix3;
    
    QXExplosion *explosion;
    
    CCSprite *revealSprite;
    
    // physical world
    b2World *_world;
    
    MyContactListener *_contactListener;

    CCSprite *arm;
    CCSprite *projectile1;
    CCSprite *projectile2;
    
    CGPoint location;
    BOOL withArm;
    
    CCSprite *bouncingBall;
    b2Body *bouncingBallBody;
    
    CGPoint mspeed;
    CGPoint pspeed;
    CGPoint weaponSpeed;
    CGPoint weaponParticleSpeed;
    
    CCTexture2D *background;
    
    CCSprite *back;

	CCJoyStick *myjoysitck; // 遥感
    
    double score; // 用于显示分数
    
    //NSMutableArray *projectilesToDelete;
    NSMutableArray *monstersToDelete;
    NSMutableArray *weaponParticleToDelete;
    
    BOOL withArm1;
    BOOL withArm2;
    
    CGPoint cgPoint;
    
    int mapWidth;
    int mapHeight;
    
    int t;
    int hit;
    double delay;
    int armtag ;
    

    DACircularProgressView* progressBar;
}

@property(nonatomic,readonly)CCJoyStick *myjoysitck;
// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) back: (id) sender;

@end

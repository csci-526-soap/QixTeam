//
//  QXPlayers.m
//  Cocos2dTest
//
//  Created by Haoyu Huang on 2/24/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import "QXPlayers.h"
#import "QXMap.h"
#import "QXPlayer.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"

@implementation QXPlayers

const int normalVelocity = 1;
const double rotationDuration = 0.01f;

static dispatch_once_t QXPlayersPredicate;
static QXPlayers *sharedPlayers = nil;

/*********************/
const double fireInterval = 0.2f;
/*********************/

+ (QXPlayers *)sharedPlayers {
    dispatch_once(&QXPlayersPredicate, ^{
        sharedPlayers = [[QXPlayers alloc] init];
    });
    return sharedPlayers;
}

- (void) build:(QXBaseAttribute *)attribute
{
    
}

- (void) setup:(CCLayer *) layer physicalWorld:(b2World *)world userData:(void *)data
{
    _layer = layer;
    _world = world;
    players = [[NSMutableArray alloc] init];
    accelerate = 0.5f;
    accelerateEnabled = false;
    
    playerVelocity = normalVelocity;
    QXPlayer *mainPlayer = [[QXPlayer alloc] init];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"plane.plist"];
    CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"plane0.png"];
    
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"plane.png"];
    [batchNode addChild:sprite];

    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 2; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"plane%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    sprite.scale = 0.5;
    
    sprite.position = [[QXMap sharedMap] generateStartPoint];
    
    [mainPlayer setup:sprite physicalWorld:world userData:data];
    
    [_layer addChild:batchNode];
    
    [players addObject:mainPlayer];
    
    mainPlayerPosition = sprite.position;
    mainPlayerRotation = sprite.rotation;
    
    fireArmor = [[QXFireArmor alloc] init];
    [fireArmor setup:layer physicalWorld:world];
    fireTime = 0.0;
    
    attribute = [[QXPlayerAttributes alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:3.0f] forKey:KEY_INIT_INVINCIBLE_TIME];
    [attribute build:dict];
    isInvincible = true;
    invincibleTimeStep = 0.0f;
    isWaitingForRespawn = false;
    
    shield = [[QXShield alloc] init];
    [shield setup:layer physicalWorld:world];
}

- (void) reSpawn
{
    isWaitingForRespawn = false;
    CGPoint p = [[QXMap sharedMap] respawn];
    if (p.x == -1 && p.y == -1) {
        p = mainPlayerPosition;
    }
    
    if ([[QXMap sharedMap] isTrace:p]) {
//        switch (headDirection) {
//            case NODIR:
//                break;
//            case UP:
//                NSLog(@"UP, %f, %f, %f, %f", p.x, p.y, p.x, p.y+1);
//                p = ccp(p.x, p.y + 1);
//                break;
//            case RIGHT:
//                NSLog(@"RIGHT, %f, %f, %f, %f", p.x, p.y, p.x+1, p.y);
//                p = ccp(p.x + 1, p.y);
//                break;
//            case DOWN:
//                NSLog(@"DOWN, %f, %f, %f, %f", p.x, p.y, p.x, p.y-1);
//                p = ccp(p.x, p.y - 1);
//                break;
//            case LEFT:
//                NSLog(@"LEFT, %f, %f, %f, %f", p.x, p.y, p.x-1, p.y);
//                p = ccp(p.x - 1, p.y);
//                break;
//            default:
//                break;
//        }
        NSLog(@"player position");
    }
    
    players = [[NSMutableArray alloc] init];
    accelerate = 0.5f;
    accelerateEnabled = false;
    
    playerVelocity = normalVelocity;
    
    QXPlayer *mainPlayer = [[QXPlayer alloc] init];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"plane.plist"];
    CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"plane0.png"];
    
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"plane.png"];
    [batchNode addChild:sprite];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 2; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"plane%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    sprite.scale = 0.5;
    
    sprite.position = p;
    
    [mainPlayer setup:sprite physicalWorld:_world userData:BODY_PLAYER];
    
    [_layer addChild:batchNode];
    
    [players addObject:mainPlayer];
    
    mainPlayerPosition = sprite.position;
    mainPlayerRotation = sprite.rotation;
    
    fireArmor = [[QXFireArmor alloc] init];
    [fireArmor setup:_layer physicalWorld:_world];
    fireTime = 0.0;
    
    attribute = [[QXPlayerAttributes alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:3.0f] forKey:KEY_INIT_INVINCIBLE_TIME];
    [attribute build:dict];
    isInvincible = true;
    invincibleTimeStep = 0.0f;
    
    shield = [[QXShield alloc] init];
    [shield setup:_layer physicalWorld:_world];
}

- (void) fireFrozenMissile: (CCLayer *)layer qixPosition: (CGPoint)position qixSize:(CGSize)size
{
    CGPoint targetLocation;

    glacierFrozen = [CCSprite spriteWithFile:@"iceblock.png"];
    glacierFrozen.position = ccp(position.x + size.width/2 ,position.y + 100);
    [_layer addChild:glacierFrozen];
    glacierFrozen.scaleX = 1;
    glacierFrozen.scaleY = 1;
    targetLocation = ccp(position.x + size.width/2, position.y + size.height/2);
    glacierFrozen.opacity = 255;
    
    [glacierFrozen runAction: [CCSequence actions:[CCMoveTo actionWithDuration:0.1f position:targetLocation],[CCCallFuncN actionWithTarget:layer selector:@selector(removeGlacierFrozen:)],nil]];
}

- (CCSprite *) frozenMissileSprite{
    //- (CCParticleGalaxy *) frozenMissileParticle{
    return glacierFrozen;
}

- (void) fire:(ccTime) time dir:(int) dir
{
    fireTime += time;
    
    if (fireTime > fireInterval) {
        
        fireTime = 0;
        
        CGPoint target;
        
        switch (dir) {
            case UP:
                target = ccp(mainPlayerPosition.x, mainPlayerPosition.y + 1000);
                break;
            case DOWN:
                target = ccp(mainPlayerPosition.x, mainPlayerPosition.y - 1000);
                break;
            case LEFT:
                target = ccp(mainPlayerPosition.x - 1000, mainPlayerPosition.y);
                break;
            case RIGHT:
                target = ccp(mainPlayerPosition.x + 1000, mainPlayerPosition.y);
                break;
            default:
                break;
        }
        [fireArmor fire:time fromPosition:mainPlayerPosition target:target direction:dir fireStop:^(int) {
            ;
        }];
    }
    
    [fireArmor cleanUpMissilesOutOfScreen];
    
}


- (void) setup:(CCLayer *) layer physicalWorld:(b2World *)world userData:(void *)data playerAttribute:(QXPlayerAttributes *)attribute
{
    // setup the player with designated player attribute
}

- (void) moveFrom:(ccTime)time from:(CGPoint) from to:(CGPoint)to prevDirection:(int)prevDir direction:(int)direction
{
    if (invincibleTimeStep == 0) {
        QXPlayer* mainPlayer = [players objectAtIndex:0];
        [shield spawnArmor:mainPlayer.image.position];
    }
    invincibleTimeStep += time;
    if (invincibleTimeStep >= [attribute invincibleTime]) {
        if (isInvincible) {
            [shield cleanUpMissiles];
        }
        isInvincible = false;
        invincibleTimeStep = [attribute invincibleTime];
    } else if (direction != NODIR){
        [shield fire:time fromPosition:to target:ccp(-1, -1) direction:NODIR fireStop:nil];
    } else {
        QXPlayer* mainPlayer = [players objectAtIndex:0];
        [shield fire:time fromPosition:mainPlayer.image.position target:ccp(-1, -1) direction:NODIR fireStop:nil];
    }
    
    if (isWaitingForRespawn || direction == NODIR || ((from.x == to.x) && (from.y == to.y))) {
//        NSLog(@"waiting for respawn");
        return;
    }
    
    QXPlayer* mainPlayer = [players objectAtIndex:0];
    mainPlayer.image.position = to;
    mainPlayerPosition = to;
    headDirection = direction;
    double rotation = 0.0f;
    
//    if (prevDir == NODIR) {
//        switch (direction) {
//            case NODIR:
//                rotation = 0.0f;
//                break;
//            case UP:
//                break;
//            case DOWN:
//                rotation = 180.0f;
//                break;
//            case RIGHT:
//                rotation = 90.0f;
//                break;
//            case LEFT:
//                rotation = 270.0f;
//                break;
//            default:
//                break;
//        }
//        
//    } else {
//        if (direction != NODIR) {
//            rotation = 90.0f;
//            int rotationStep = direction - prevDir;
//            if (rotationStep == 3) {
//                rotationStep = -1;
//            } else if (rotationStep == -3) {
//                rotationStep = 1;
//            }
//            rotation *= rotationStep;
//        }
//    }
//    
//    if (prevDir != direction) {
//        NSLog(@"rotation: %f", rotation);
////        [[[QXPlayers sharedPlayers] mainPlayer].image runAction:[CCRotateBy actionWithDuration:rotationDuration angle:rotation]];
//        [[QXPlayers sharedPlayers] mainPlayer].image.rotation = rotation;
//    }
    
    switch (direction) {
        case NODIR:
            rotation = 0.0f;
            break;
        case UP:
            rotation = 0.0f;
            break;
        case DOWN:
            rotation = 180.0f;
            break;
        case RIGHT:
            rotation = 90.0f;
            break;
        case LEFT:
            rotation = 270.0f;
            break;
        default:
            break;
    }
    
    [[QXPlayers sharedPlayers] mainPlayer].image.rotation = rotation;
    mainPlayerRotation = rotation;
        if (accelerateEnabled) {
            rotation = 0.0f;
            switch (direction) {
                case UP:
                    break;
                case DOWN:
                    rotation = 180.0f;
                    break;
                case LEFT:
                    rotation = -90.0f;
                    break;
                case RIGHT:
                    rotation = 90.0f;
                    break;
                case NODIR:
                    break;
                default:
                    break;
            }

            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"plane.plist"];
            CCSprite* light = [CCSprite spriteWithSpriteFrameName:@"plane0.png"];
            //sprite.anchorPoint = ccp(0,0);
            light.position = ccp(0,0);
            CCSpriteBatchNode * batchNode_light = [CCSpriteBatchNode batchNodeWithFile:@"plane.png"];
            [batchNode_light addChild:light];
            //[layer addChild:batchNode];
            NSMutableArray * animFrames = [NSMutableArray array];
            
            for(int i =0; i < 2; i++) {
                CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"plane%d.png", i]];
                [animFrames addObject:frame];
                
            }
            
            CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
            [light runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
            light.scale = 0.3;
            
            light.position = to;
            [_layer addChild:batchNode_light z:0];
            
            if (rotation != 0) {
                light.rotation = rotation;
//                [light runAction:[CCRotateBy actionWithDuration:rotationDuration angle:rotation]];
            }
            
            CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:accelerate],vanishAction,nil];
            [light runAction:sequence];
        }
//    }
}
    
-(void)removeSprite:(id)sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
}

- (CGPoint) mainPlayerPosition
{
    return mainPlayerPosition;
}

- (double) mainPlayerRotation
{
    return mainPlayerRotation;
}

- (QXPlayer *)mainPlayer
{
    return [players objectAtIndex:0];
}

- (void) enableAccelerate
{
    accelerateEnabled = true;
}

- (void) disableAccelerate
{
    accelerateEnabled = false;
}

- (int) velocity
{
    return playerVelocity;
}

- (void) setV:(int)velocity
{
    if (velocity > highestVelocity) {
        playerVelocity = highestVelocity;
    } else {
        playerVelocity = velocity;
    }
}

- (QXFireArmor *)fireArmor
{
    return fireArmor;
}

- (bool) isInvincible
{
    return isInvincible;
}

- (bool) isWaitingForRespawn
{
    return isWaitingForRespawn;
}

- (void) waitingForRespawn
{
    isWaitingForRespawn = true;
    QXPlayer* mainPlayer = [players objectAtIndex:0];
    [[mainPlayer image] removeFromParentAndCleanup:YES];
    _world->DestroyBody([mainPlayer body]);
}

@end

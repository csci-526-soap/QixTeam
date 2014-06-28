//
//  Level1Layer.m
//  Cocos2dTest
//
//  Created by Student on 1/31/14.
//  Copyright 2014 Xin ZHANG. All rights reserved.
//

#import "QXSceneManager.h"
#import "QXLevel1Layer.h"
#import "AppDelegate.h"

@implementation QXLevel1Layer

// initialize mosnters (this method is called after the player is initilized)
- (void) initMonsters
{
    oneTimeCollisionListen = 0;
    levelId = LEVEL_1;
    [super initMonsters];
    
    qix = [[QXQix alloc] init];
    [qix setUp:self physicalWorld:_world userData:BODY_QIX];
    guardQix1 = [[QXGuard alloc] init];
    [guardQix1 setup:ccp(100, 250) layer:self physicalWorld:_world userData:BODY_GUARD_1];
    guardQix2 = [[QXGuard alloc] init];
    [guardQix2 setup:ccp(400,150) layer:self physicalWorld:_world userData:BODY_GUARD_2];
    guardQix3 = [[QXGuard alloc] init];
    [guardQix3 setup:ccp(200, 80) layer:self physicalWorld:_world userData:BODY_GUARD_3];
     
    [self resetCollisionDetectionVariables];
}

// monster take actions (this method is called once per frame after moving the player)
- (void) monsterTakeActions:(ccTime) frameDuration
{
    [super monsterTakeActions:frameDuration];
    
    if ([guardQix1 isActive]) {
        [guardQix1 takeAction:frameDuration];
    }
    if ([guardQix2 isActive]) {
        [guardQix2 takeAction:frameDuration];
    }
    if ([guardQix3 isActive]) {
        [guardQix3 takeAction:frameDuration];
    }
    
    if ([qix isActive]) {
        
        [qix takeAction:frameDuration spawnMissile:^(bool isSpawning, bool startSpawning, int tag) {
            if (startSpawning) {
                // [missileTags removeAllObjects];
                [[qix missile] cleanUpMissiles];
            }
            if (isSpawning) {
                [qix fire:frameDuration];
            }
        }];
    } else {
        [qix hitByArmor:GuidedMissile from:CGPointMake(-1, -1) time:frameDuration];
    }
}

- (NSString *)backgroundImagePath
{
    return [super backgroundImagePath];
}

// the revealed image path
- (NSString *) revealedImagePath
{
    return [super revealedImagePath];
}

// the position of the Qix (this method is called when the game needs to decide which area is claimed by the player)
- (CGPoint) qixPosition
{
    return [qix position];
}

// move player by using joysticks with direction (this method is called once per frame, subclass which overrides this method should call [super onPlayerMovingState])
- (void) onPlayerMovingState:(int) direction frameDuration:(ccTime)frameDuration
{
    if(direction != NODIR){
        [[QXPlayers sharedPlayers] fire:frameDuration dir:prevDirection];
    }
    [super onPlayerMovingState:direction frameDuration:frameDuration];
}

// player claim area state (this method is called when the player claims an area, subclass which overrides this method should call [super onClaimAreaState])
- (void) onClaimAreaState
{
    [super onClaimAreaState];
}

// ensure position consistency between cocos2d sprites and box2d b2Bodies. (this method is called once per frame for each b2Body in the physical world)
- (void) onCocosAndBoxPositionUpdate:(b2Body *)body
{
    [super onCocosAndBoxPositionUpdate:body];
    
    NSString *value = (NSString *)body->GetUserData();
    NSString *missilePrefix = @"";
    NSString *quickAutoMissileTag = @"";
    
    if( value.length > BODY_FIRE_ARMOR.length){
        quickAutoMissileTag = [value substringToIndex:BODY_FIRE_ARMOR.length];
    }
    
    if (value.length > BODY_SCATTERED_MISSILE_TAG.length) {
        missilePrefix = [value substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
    }
    
    if([value isEqualToString:BODY_QIX]) {
        CGPoint point = [qix qixSprite].position;
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([qix qixSprite].rotation);
        // Update the Box2D position/rotation to match the Cocos2D position/rotation
        body->SetTransform(b2Position, b2Angle);
        
    } else if ([value isEqualToString:BODY_GUARD_1]) {
        if ([guardQix1 isActive]) {
            CGPoint point = [guardQix1 qixSprite].position;
            
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix1 qixSprite].rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([value isEqualToString:BODY_GUARD_2]) {
        if ([guardQix2 isActive]) {
            CGPoint point = [guardQix2 qixSprite].position;
            
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix2 qixSprite].rotation);
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([value isEqualToString:BODY_GUARD_3]) {
        if ([guardQix3 isActive]) {
            CGPoint point = [guardQix3 qixSprite].position;
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix3 qixSprite].rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([missilePrefix isEqualToString:BODY_SCATTERED_MISSILE_TAG]) {
        int index = [[value substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length] intValue];
        CCSprite *sprite = [[qix missile] missile:index];
        if (sprite != nil) {
            CGPoint point = sprite.position;
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            body->SetTransform(b2Position, b2Angle);
        }
    } else if( [quickAutoMissileTag isEqualToString:BODY_FIRE_ARMOR] ){
        int index = [[value substringFromIndex:BODY_FIRE_ARMOR.length] intValue];
        CCSprite *sprite = [[[QXPlayers sharedPlayers] fireArmor] missile:index];
        if (sprite != nil) {
            CGPoint point = sprite.position;
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    }
}

// detect object collisions (this method is called once per frame for every two objects that has collision)
- (bool) onBox2dCollisionDetection:(b2Body *)bodyA body2:(b2Body *)bodyB toDestroy:(std::vector<b2Body *>)toDestroy
{
    [super onBox2dCollisionDetection:bodyA body2:bodyB toDestroy:toDestroy];
    
    NSString *valueA = (NSString *) bodyA->GetUserData();
    NSString *valueB = (NSString *) bodyB->GetUserData();
    
    NSString *scatteredMissileValueA = @"";
    NSString *scatteredMissileValueB = @"";
    
    NSString *playerAutoMissileValueA = @"";
    NSString *playerAutoMissileValueB = @"";
    
    if (valueA.length > BODY_SCATTERED_MISSILE_TAG.length) {
        scatteredMissileValueA = [valueA substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
    }
    if (valueB.length > BODY_SCATTERED_MISSILE_TAG.length) {
        scatteredMissileValueB = [valueB substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
    }
    
    if (valueA.length > BODY_FIRE_ARMOR.length) {
        playerAutoMissileValueA = [valueA substringToIndex:BODY_FIRE_ARMOR.length];
    }
    if (valueB.length > BODY_FIRE_ARMOR.length) {
        playerAutoMissileValueB = [valueB substringToIndex:BODY_FIRE_ARMOR.length];
    }
    
    if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_QIX]) || ([valueA isEqualToString:BODY_QIX] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with qix");
        playerCollideWithQix = true;
        toDestroy.push_back(bodyA);
        toDestroy.push_back(bodyB);
        return true;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_1]) || ([valueA isEqualToString:BODY_GUARD_1] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with guard 1");
        playerCollideWithGuard1 = true;
        toDestroy.push_back(bodyA);
        toDestroy.push_back(bodyB);
        return true;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_2]) || ([valueA isEqualToString:BODY_GUARD_2] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with guard 2");
        playerCollideWithGuard2 = true;
        toDestroy.push_back(bodyA);
        toDestroy.push_back(bodyB);
        return true;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_3]) || ([valueA isEqualToString:BODY_GUARD_3] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with guard 3");
        playerCollideWithGuard3 = true;
        toDestroy.push_back(bodyA);
        toDestroy.push_back(bodyB);
        return true;
    } else if (([valueA isEqualToString:BODY_WORLD] && [valueB isEqualToString:BODY_QIX]) || ([valueA isEqualToString:BODY_QIX] && [valueB isEqualToString:BODY_WORLD])) {
        NSLog(@"qix collide with world");
        
        if ([valueA isEqualToString:BODY_QIX]) {
            qixCollideWithWorld = true;
        } else if ([valueB isEqualToString:BODY_QIX]) {
            qixCollideWithWorld = true;
        }
    } else if (([valueA isEqualToString:BODY_PLAYER] && [scatteredMissileValueB isEqualToString:BODY_SCATTERED_MISSILE_TAG]) || ([scatteredMissileValueA isEqualToString:BODY_SCATTERED_MISSILE_TAG] && [valueB isEqualToString:BODY_PLAYER])) {
        playerCollideWithMissile = true;
        toDestroy.push_back(bodyA);
        toDestroy.push_back(bodyB);
        return true;
    }
    
    else if (oneTimeCollisionListen == 0) {
    // player fire armor collide with other objects
     if ((valueB.length > BODY_FIRE_ARMOR.length && [valueA isEqualToString:BODY_QIX] && [playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR]) || (valueA.length > BODY_FIRE_ARMOR.length && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR] && [valueB isEqualToString:BODY_QIX])) {
         oneTimeCollisionListen = 1;
        playerQuickAutoMissileQix = true;
        NSLog(@"quickAutoMissile collide with QIX");
         return true;
     } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_GUARD_3] && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_GUARD_3]) ) ) ){
         playerQuickAutoMissileGuard3 = true;
         oneTimeCollisionListen = 1;
         toDestroy.push_back(bodyA);
         toDestroy.push_back(bodyB);
         if(valueA.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         } else if(valueB.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         }
         return true;
     } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_GUARD_2] && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_GUARD_2]) ) ) ){
         playerQuickAutoMissileGuard2 = true;
         oneTimeCollisionListen = 1;
         toDestroy.push_back(bodyA);
         toDestroy.push_back(bodyB);
         
         if(valueA.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
             
         }else if(valueB.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         }
         return true;
     } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_GUARD_1] && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_GUARD_1]) ) ) ){
         playerQuickAutoMissileGuard1 = true;
         oneTimeCollisionListen = 1;
         toDestroy.push_back(bodyA);
         toDestroy.push_back(bodyB);
         
         if(valueA.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             NSLog(@"collide with quickAutoMissile %d",temp2);
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
             
         } else if(valueB.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         }
         return true;
     } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_WALKER_NS] && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_WALKER_NS]) ) ) ){
         playerQuickAutoMissileNSWalker = true;
         oneTimeCollisionListen = 1;
         toDestroy.push_back(bodyA);
         toDestroy.push_back(bodyB);
         NSLog(@"quickAutoMissile collide with NSMonster");
         if(valueA.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         } else if(valueB.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         }
         return true;
     } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([valueB isEqualToString:BODY_WALKER_NW] && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR] && [valueA isEqualToString:BODY_WALKER_NW]) ) ) ){
         playerQuickAutoMissileNWWalker = true;
         oneTimeCollisionListen = 1;
         toDestroy.push_back(bodyA);
         toDestroy.push_back(bodyB);
         NSLog(@"quickAutoMissile collide with NWMonster");
         if(valueA.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         } else if(valueB.length > BODY_FIRE_ARMOR.length){
             NSString *temp1 = [valueA substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
         }
         return true;
     } else if( valueA.length > BODY_FIRE_ARMOR.length && ( ([playerAutoMissileValueB isEqualToString:BODY_SCATTERED_MISSILE_TAG] && [playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR])  || ( valueB.length > BODY_FIRE_ARMOR.length && ([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR] && [playerAutoMissileValueA isEqualToString:BODY_SCATTERED_MISSILE_TAG]) ) ) ){
         playerQuickAutoMissileQixMissile = true;
         oneTimeCollisionListen = 1;
         toDestroy.push_back(bodyA);
         toDestroy.push_back(bodyB);
         if([playerAutoMissileValueA isEqualToString:BODY_FIRE_ARMOR]){
             int temp2 = [[valueA substringFromIndex:BODY_FIRE_ARMOR.length] intValue];
             NSLog(@"A   collide with quickAutoMissile %d",temp2);
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
             temp2 = [[valueB substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length] intValue];
             NSLog(@"A   collide with QixMissile %d",temp2);
             [[qix missile] cleanUpSpecificMissile:temp2];
         } else if([playerAutoMissileValueB isEqualToString:BODY_FIRE_ARMOR]){
             NSString *temp1 = [valueB substringFromIndex:BODY_FIRE_ARMOR.length];
             int temp2 = [temp1 intValue];
             [[[QXPlayers sharedPlayers] fireArmor] cleanUpSpecificMissile:temp2];
             temp1 = [valueA substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length];
             temp2 = [temp1 intValue];
             [[qix missile] cleanUpSpecificMissile:temp2];
         }
         return true;
     }
    }
    return false;
}

// subclass should override this method to do follow-up actions if collisions are detected
- (void) afterBox2dCollisionDetetion
{
    [super afterBox2dCollisionDetetion];
    
    if (qixCollideWithWorld) {
        [qix stopAction];
    }
    
    int killedGuards = 0;
    if (playerCollideWithGuard1) {
        killedGuards++;
    }
    if (playerCollideWithGuard2) {
        killedGuards++;
    }
    if (playerCollideWithGuard3) {
        killedGuards++;
    }
    
    if (killedGuards) {
        [[QXMedalSystem sharedMedalSystem] invokeOnKillGuardQix:killedGuards rewardCallback:^(enum QXMedalType, QXMedal *) {
            ;
        }];
    }
    
    if (playerCollideWithMissile || playerCollideWithGuard1 || playerCollideWithGuard2 || playerCollideWithGuard3 || playerCollideWithQix || playerCollideWithWalkerNS || playerCollideWithWalkerNW) {
        if (playerCollideWithMissile) {
            [[QXMedalSystem sharedMedalSystem] invokeOnHitByScatteredMissile:^(enum QXMedalType, QXMedal *) {
                ;
            }];
        }
        [self lose];
    }
    
    if(playerQuickAutoMissileGuard1){
        [guardQix1 explosion];
    } else if(playerQuickAutoMissileGuard2){
        [guardQix2 explosion];
    } else if(playerQuickAutoMissileGuard3){
        [guardQix3 explosion];
    } else if(playerQuickAutoMissileNSWalker){
        [nsWalker explosion];
    } else if(playerQuickAutoMissileNWWalker){
        [nwWalker explosion];
    } else if(playerQuickAutoMissileQixMissile){
        [[[QXPlayers sharedPlayers] fireArmor] explode];
    }
    [self resetCollisionDetectionVariables];
}

- (void) resetCollisionDetectionVariables
{
    playerCollideWithWalkerNW = false;
    playerCollideWithGuard1 = false;
    playerCollideWithGuard2 = false;
    playerCollideWithGuard3 = false;
    playerCollideWithMissile = false;
    playerCollideWithQix = false;
    playerCollideWithWalkerNS = false;
    playerCollideWithWalkerNW = false;
    
    playerQuickAutoMissileGuard1 = false;
    playerQuickAutoMissileGuard2 = false;
    playerQuickAutoMissileGuard3 = false;
    playerQuickAutoMissileNSWalker= false;
    playerQuickAutoMissileNWWalker = false;
    playerQuickAutoMissileQixMissile = false;
    
    qixCollideWithWorld = false;
    
    oneTimeCollisionListen = 0;
}

// dealloc (this method is called when the layer class is destroyed, subclass which overrides this method should call [super onDealloc])
- (void) onDealloc
{
    [super onDealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
}

@end

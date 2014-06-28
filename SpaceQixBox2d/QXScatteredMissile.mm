//
//  QXGuidedMissile.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXScatteredMissile.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "AppDelegate.h"
#import "GB2ShapeCache.h"

@implementation QXScatteredMissile

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world
{
    [super setup:layer physicalWorld:world];
    _armors = [[NSMutableArray alloc] init];
    armorIndex = 0;
    missileTags = [[NSMutableArray alloc] init];
    attribute = [[QXScatteredMissileAttribute alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithDouble:2.0f] forKey:KEY_SCATTERED_MISSILE_FIRE_DURATION];
    [dict setValue:[NSNumber numberWithDouble:15] forKey:KEY_SCATTERED_MISSILE_COUNT];
    [attribute build:dict];
}

- (CCSprite *) spawnArmor:(CGPoint) position
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"misile.plist"];
    CCSprite *projectile = [CCSprite spriteWithSpriteFrameName:@"misile0.png"];
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"misile.png"];
    [batchNode addChild:projectile];
    
    [[CDAudioManager sharedManager].soundEngine playSound:SND_MSL
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 12; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"misile%d.png", i]];
        [animFrames addObject:frame];
        
    }
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [projectile runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    [_layer addChild:batchNode];
    projectile.tag = armorIndex++;
    [_armors addObject:projectile];
    
    return projectile;
}

- (void) fire:(ccTime)time  fromPosition:(CGPoint)position target:(CGPoint)target direction:(int)direction fireStop:(void (^)(int armorIndex)) fireStop
{
    if (count < 57 && count%3==0) {
        
        double angle = count/3*360/19;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *projectile = [self spawnArmor:position];
        
        projectile.position = position;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(projectile.position.x/PTM_RATIO, projectile.position.y/PTM_RATIO);
        
        NSString *userData = [NSString stringWithFormat:@"%@%d", BODY_SCATTERED_MISSILE_TAG, armorIndex];
        [missileTags addObject:userData];
        bodyDef.userData = userData;
        b2Body  *missileBody = _world->CreateBody(&bodyDef);
        [[GB2ShapeCache sharedShapeCache]
         addFixturesToBody:missileBody forShapeName:@"missileBody"];
        [projectile setAnchorPoint:[
                                    [GB2ShapeCache sharedShapeCache]
                                    anchorPointForShape:@"missileBody"]];
        
        // Determine offset of location to projectile
        CGPoint realDest = ccp(projectile.position.x+winSize.width*cosf(CC_DEGREES_TO_RADIANS(angle)), projectile.position.y + winSize.width*sinf(CC_DEGREES_TO_RADIANS(angle)));

        // Determine the length of how far you're shooting
        float length = winSize.width*2;
        float velocity = 300/1; // 48pixels/1sec
        float realMoveDuration = length/velocity;
        
        // Determine angle to face
        projectile.rotation = -angle+90;
        
        // Move projectile to actual endpoint
        id action = [CCMoveTo actionWithDuration:realMoveDuration position:realDest];
        id ease = [CCEasePolynomial actionWithAction:action];
        [projectile runAction:
         [CCSequence actions:
          ease,
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [_armors removeObject:node];
             [node removeFromParentAndCleanup:YES];
         }],
          nil]];
    }
    
    count++;
    
    if (missleFireStep == 0) {
        missleFireStep+=time;
        [_armors removeAllObjects];
    } else if (missleFireStep < [attribute fireDuration]){
        missleFireStep+=time;
    } else {
        missleFireStep = 0;
        if (fireStop) {
            fireStop(armorIndex);
        }
        count = 0;
    }
}

- (CCSprite *) missile:(int)tag
{
    for (int i = 0; i < [_armors count]; i++) {
        CCSprite *sprite = [_armors objectAtIndex:i];
        if (sprite.tag == tag) {
            return sprite;
        }
    }
    return nil;
}

- (void) cleanUpSpecificMissile:(int)tagNum
{
    for (int i = 0; i < [_armors count]; i++) {
        CCSprite *projectile = [_armors objectAtIndex:i];
        if (projectile.tag == tagNum) {
            [_armors removeObject:projectile];
            NSLog(@"remove specifig missile: %d", tagNum);
            [projectile  removeFromParentAndCleanup:YES];
            
        }
    }

//     for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
//         if (b->GetUserData() != NULL) {
//             // update the sprite position to be consistency with box body location
//             NSString *value = (NSString *)b->GetUserData();
//     
//             if( value.length > BODY_SCATTERED_MISSILE_TAG.length){
//                 NSString *m = [value substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
//                 if ([m isEqualToString:BODY_SCATTERED_MISSILE_TAG]) {
//                     m = [m substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length];
//                     int missileTag = [m intValue];
//                     if( missileTag == tagNum){
//                         b->GetWorld()->DestroyBody(b);
//                     }
//                 }
//             }
//         }
//     }
}

- (void) cleanUpMissiles
{
    [_armors removeAllObjects];
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            // update the sprite position to be consistency with box body location
            NSString *value = (NSString *)b->GetUserData();
            NSString *m = @"";
            if (value.length > BODY_SCATTERED_MISSILE_TAG.length) {
                m = [value substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
                if ([m isEqualToString:BODY_SCATTERED_MISSILE_TAG]) {
                    b->GetWorld()->DestroyBody(b);
                }
            }
        }
    }
}

- (void) cleanUpMissilesOutOfScreen
{
    //clear
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for (int i = 0; i < [_armors count]; i++) {
        CCSprite *projectile = [_armors objectAtIndex:i];
        if (projectile.position.x<0 || projectile.position.x>winSize.width || projectile.position.y<0 || projectile.position.y > winSize.height) {
            
            for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
                if (b->GetUserData() != NULL) {
                    // update the sprite position to be consistency with box body location
                    NSString *value = (NSString *)b->GetUserData();
                    
                    if (value.length > BODY_SCATTERED_MISSILE_TAG.length) {
                        NSString *m = [value substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
                        if ([m isEqualToString:BODY_SCATTERED_MISSILE_TAG]) {
                            int tag = [[value substringFromIndex:BODY_SCATTERED_MISSILE_TAG.length] intValue];
                            if (projectile.tag == tag) {
                                b->GetWorld()->DestroyBody(b);
                            }
                        }
                    }
                }
            }
            [_armors removeObjectAtIndex:i];
            i--;
            [projectile  removeFromParentAndCleanup:YES];
        }
    }

}

- (NSMutableArray *)armors
{
    return _armors;
}

- (int) currentArmorIndex
{
    return armorIndex;
}

- (QXScatteredMissileAttribute *)attribute
{
    return attribute;
}

@end

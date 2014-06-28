//
//  QXShield.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/21/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXShield.h"
#import "AppDelegate.h"
#import "CDAudioManager.h"

@implementation QXShield

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world
{
    [super setup:layer physicalWorld:world];
}

- (void) fire:(ccTime)delta fromPosition:(CGPoint)position target:(CGPoint)target direction:(int)direction fireStop:(void (^)(int armorIndex)) fireStop
{
    armor.position = position;
}

- (void) cleanUpMissiles
{
    [armor removeFromParentAndCleanup:YES];
}

- (void) cleanUpMissilesOutOfScreen
{

}

- (CCSprite *) spawnArmor:(CGPoint) position
{
    
    [[CDAudioManager sharedManager].soundEngine playSound:SND_INV
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shield_0.plist"];
    armor = [CCSprite spriteWithSpriteFrameName:@"shield_01.png"];
    //sprite.anchorPoint = ccp(0,0);
    //armor.position = ccp(200,200);
    armor.scale = 0.8;
    CCSpriteBatchNode * batchNodeProjectile1 = [CCSpriteBatchNode batchNodeWithFile:@"shield_0.png"];
    [batchNodeProjectile1 addChild:armor];
    NSMutableArray * animFrames = [NSMutableArray array];
    for(int i =1; i < 9; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"shield_0%d.png", i]];
        [animFrames addObject:frame];
        
    }
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [armor runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];

    
    
    //armor = [CCSprite spriteWithFile:@"wall_c.png"];
    armor.scale = 1.5;
    armor.anchorPoint = ccp(0.48,0.49);
    [_layer addChild:batchNodeProjectile1];
    return armor;
}

- (void) explode
{

}

// return true is the armor is picked up.
- (bool) pickup
{
    return false;
}

- (CCSprite *) armorSprite
{
    return armor;
}

@end

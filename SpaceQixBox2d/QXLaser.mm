//
//  QXLaser.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/20/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXLaser.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"

@implementation QXLaser

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world
{
    [super setup:layer physicalWorld:world];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:1.0f] forKey:KEY_EMIT_DELAY];
    [dict setObject:[NSNumber numberWithDouble:2.0f] forKey:KEY_EMIT_DURATION];
    attribute = [[QXLaserAttribute alloc] init];
    [attribute build:dict];
    delayStep = 0;
    emitStep = 0;
    preAngle = 90;
}

- (void) fire:(ccTime)delta fromPosition:(CGPoint)position target:(CGPoint)target direction:(int)direction fireStop:(void (^)(int armorIndex)) fireStop
{
    delayStep += delta;
    
    if (delayStep >= [attribute emitDelay]) {

        if (emitStep == 0) {
            
            [[CDAudioManager sharedManager].soundEngine playSound:SND_ELE
                                                    sourceGroupId:CGROUP_EFFECTS
                                                            pitch:1.0f
                                                              pan:0.0f
                                                             gain:1.0f
                                                             loop:NO];

            CCRotateBy *rotate = [CCRotateBy actionWithDuration:2 angle:90];
            CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeBeam:)];
            [armor runAction:[CCSequence actions:rotate,vanishAction, nil]];
        }
        
        emitStep += delta;
        
        if (emitStep >= [attribute emitDuration]) {
            delayStep = 0;
            emitStep = 0;
            if (fireStop) {
                fireStop(-1);
            }
        }
    }
}

- (void) cleanUpMissiles
{
    
}

- (void) cleanUpMissilesOutOfScreen
{

}

-(void) removeBeam:(id)sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
    _world->DestroyBody(body);
}

- (CCSprite *) spawnArmor:(CGPoint) position
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"beam.plist"];
    CCSprite *beam = [CCSprite spriteWithSpriteFrameName:@"beam0.png"];
    beam.anchorPoint = ccp(0,0.5);
    beam.scaleX = 4;
    
    beam.rotation = preAngle + 90;
    preAngle = preAngle + 90;
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"beam.png"];
    [batchNode addChild:beam];
    [_layer addChild:batchNode];
    beam.position = ccpAdd(position,ccp(12, 10));
    armor = beam;
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 30; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"beam%d.png", i]];
        [animFrames addObject:frame];
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [beam runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:2]];
    
    
    /************************ Laser Qix Beam box2D ***************************/
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(beam.position.x/PTM_RATIO, beam.position.y/PTM_RATIO);
    bodyDef.userData = BODY_BEAM_ARMOR;
    body = _world->CreateBody(&bodyDef);
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:@"beamBox"];
    [beam setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"beamBox"]];
    return beam;
}

- (void) explode
{

}

- (CCSprite *) armorSprite
{
    return armor;
}

// return true is the armor is picked up.
- (bool) pickup
{
    return false;
}

@end

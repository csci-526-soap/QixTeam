//
//  QXCrab.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/17/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXCrab.h"
#import "CCParticleEffectGenerator.h"
#import "CCShake.h"
#import "QXPlayers.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"




@implementation QXCrab


- (void) setUp:(CCLayer *)layer physicalWorld:(b2World *)world
{
    
    
    CCParticleRain *rain;
    
    rain = [[CCParticleRain alloc] init];
    
    [_layer addChild:rain];
    CGSize size = [[CCDirector sharedDirector] winSize];
    rain.position = ccp(size.width/2,size.height);
    rain.emissionRate = 40;
    
    [super setUp:layer physicalWorld:world];
    _layer = layer;
    [_layer addChild:rain];
    shadeStep = 0;
    moveStep =0;
    //headAngle = arc4random()%360;
    headAngle = 0;
    angleChange = 120;
    stepDuration = 0.8;
    shadeTime = 2;
    shadeTimeOver = 5;
    //*******animation*********
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"giantQix.plist"];
    _qixMonster = [CCSprite spriteWithSpriteFrameName:@"giantQix0.png"];
    //sprite.anchorPoint = ccp(0,0);
    _qixMonster.position = ccp(280,160);
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"giantQix.png"];
    [batchNode addChild:_qixMonster];
    [layer addChild:batchNode];
    NSMutableArray * animFrames;
    CCAnimation * animation;
    
    animFrames = [[NSMutableArray alloc] init];
    
    for(int i =0; i < 36; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"giantQix%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    animation = [CCAnimation animationWithSpriteFrames:animFrames delay:stepDuration/35*2];
    [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"giantQixBody.plist"];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(_qixMonster.position.x/PTM_RATIO, _qixMonster.position.y/PTM_RATIO);
    bodyDef.userData = BODY_CRAB;
    _qixMonsterBody = world->CreateBody(&bodyDef);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_qixMonsterBody forShapeName:@"giantQixBody"];
    [_qixMonster setAnchorPoint:[
                                 [GB2ShapeCache sharedShapeCache]
                                anchorPointForShape:@"giantQixBody"]];
}

- (void) takeAction:(ccTime) time
{
    shadeStep+=time;
    moveStep+=time;
    if (moveStep >= stepDuration) {
    moveStep = 0;
    
    [[CDAudioManager sharedManager].soundEngine playSound:SND_STP
                                                sourceGroupId:CGROUP_EFFECTS
                                                        pitch:1.0f
                                                          pan:0.0f
                                                         gain:1.0f
                                                         loop:NO];
        
    int preAngle = headAngle;
    headAngle = preAngle-angleChange/2+arc4random()%angleChange;
    //headAngle = preAngle+90;
    if (headAngle > 360) {
        headAngle -= 360;
    }
    if (headAngle < 0) {
        headAngle += 360;
    }
        
        
       
    //_qixMonster.rotation = -headAngle + 90;
    newPos = ccp(50*cosf(CC_DEGREES_TO_RADIANS(headAngle)), 50*sinf(CC_DEGREES_TO_RADIANS(headAngle)));

    
    CGPoint point = ccpAdd(_qixMonster.position, ccp(newPos.x, 0));
    
    if (!([[QXMap sharedMap] isSpace:point] || [[QXMap sharedMap] isTrace:point])) {
        newPos.x = -newPos.x;
        headAngle =180 - headAngle;
        if (headAngle > 360) {
            headAngle -= 360;
        }
        if (headAngle < 0) {
            headAngle += 360;
        }

    }
    point = ccpAdd(_qixMonster.position, ccp(0, newPos.y));
    
    if (!([[QXMap sharedMap] isSpace:point] || [[QXMap sharedMap] isTrace:point])) {
        newPos.y = -newPos.y;
        headAngle = -headAngle;
        if (headAngle > 360) {
            headAngle -= 360;
        }
        if (headAngle < 0) {
            headAngle += 360;
        }

    }
     [_qixMonster runAction:[CCRotateTo actionWithDuration:stepDuration angle:-headAngle + 90]];
    newPos = ccpAdd(_qixMonster.position, newPos);
    id snakeMove = [CCMoveTo actionWithDuration:stepDuration-0.05 position:newPos];
    //[_qixMonster runAction:snakeMove];
    
   [_qixMonster runAction:[CCSequence actions: snakeMove, [CCCallFuncN actionWithTarget:_layer selector:@selector(crabQixFire:)],nil]];

    
    [attribute updatePosition:newPos];
    }
    
    if (shadeStep >= shadeTime && shadeStep <= shadeTimeOver) {
        if (_qixMonster.opacity >= 10) {
            _qixMonster.opacity -=10;
        }
        
        //shoot
       
    }
    
    if (shadeStep > shadeTimeOver) {
        _qixMonster.opacity += 5;
        if (_qixMonster.opacity == 10) {
            [self crabQixParticle];
        }
        if (_qixMonster.opacity == 255) {
            shadeStep = 0;
         //   [self crabQixParticle];
        }
    }

}

- (void) crabQixParticle{
    
    
    
    CCParticleFlower *rain2;
    
    rain2 = [[CCParticleFlower alloc] init];
    
    [_layer addChild:rain2];
    
    rain2.position = ccp(_qixMonster.position.x,_qixMonster.position.y);
    rain2.emissionRate = 40;
    
    [rain2 runAction: [CCSequence actions: [CCMoveTo actionWithDuration:2.0f position:rain2.position],[CCCallFuncN actionWithTarget:self selector:@selector(particleRemove2:)],nil]];
    
    
 
    
}


- (void) particleRemove:(id)sender
{
    CCParticleFlower *rain = (CCParticleFlower *)sender;
    [rain removeFromParentAndCleanup:YES];
}

- (void) particleRemove2:(id)sender
{
    CCParticleSpiral *rain = (CCParticleSpiral *)sender;
    [rain removeFromParentAndCleanup:YES];
}



- (void) stopAction
{

}

- (void) fire:(ccTime) delta
{

}
@end

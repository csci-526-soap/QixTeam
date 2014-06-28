//
//  QXSimpleQix.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXGuard.h"

@implementation QXGuard

const double radius = 20.0f;

- (void) config:(QXBaseAttribute *)attribute
{
    QXGuardAttribute *attr = (QXGuardAttribute *) attribute;
    
}

- (void) setup:(CGPoint) position layer:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data
{
    type = Guard;
    [super setUp:layer physicalWorld:world];
    isActive = true;
    explosion = [[QXExplosion alloc] init];
    _layer = layer;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mon_little.plist"];
    _qixMonster = [CCSprite spriteWithSpriteFrameName:@"monlittle0.png"];
    //sprite.anchorPoint = ccp(0,0);
    _qixMonster.position = ccp(0,0);
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"mon_little.png"];
    [batchNode addChild:_qixMonster];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 24; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"monlittle%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    _qixMonster.scale = 0.4;
    _qixMonster.position = position;
    CGFloat anchorY = radius / [_qixMonster boundingBox].size.height;
    [_qixMonster setAnchorPoint:ccp(0.5f, anchorY)];
    [_qixMonster setRotation:90];

    [layer addChild:batchNode];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(_qixMonster.position.x/PTM_RATIO, _qixMonster.position.y/PTM_RATIO);
    bodyDef.userData = data;
    _qixMonsterBody = world->CreateBody(&bodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 10.0/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 0.5f;
    fixtureDef.restitution = 0.8f;
    _qixMonsterBody->CreateFixture(&fixtureDef);
    
    CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:0.1 angle:10];
    [_qixMonster runAction:[CCRepeatForever actionWithAction:rotateAction]];
}

- (void) takeAction:(ccTime)delta
{
    
    if ([[QXMap sharedMap] isFill:_qixMonster.position] || [[QXMap sharedMap] isBoundary:_qixMonster.position] || [[QXMap sharedMap] isWall:_qixMonster.position]) {
        isActive = false;
        [[QXExplosion sharedExplosion] explode:EGUARD layer:_layer position:_qixMonster.position];
        [_qixMonster stopAllActions];
        [_qixMonster removeFromParentAndCleanup:YES];
        _qixMonsterBody->GetWorld()->DestroyBody(_qixMonsterBody);
        return;
    }
    
}
/********************************/

- (void) explosion
{
    isActive = false;
    [[QXExplosion sharedExplosion] explode:EGUARD layer:_layer position:_qixMonster.position];
    [_qixMonster stopAllActions];
    [_qixMonster removeFromParentAndCleanup:YES];
    //_qixMonsterBody->GetWorld()->DestroyBody(_qixMonsterBody);
}

/********************************/


- (double) distance:(CGPoint) p q:(CGPoint)q
{
    return sqrt((p.x-q.x)*(p.x-q.x) + (p.y - q.y)*(p.y - q.y));
}
@end

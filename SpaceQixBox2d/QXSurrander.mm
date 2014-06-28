//
//  QXSurrander.m
//  SpaceQix
//
//  Created by Student on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXSurrander.h"

@implementation QXSurrander

const double radius = 20.0f;

static double angel = 0;

- (void) config:(QXBaseAttribute *)attribute
{
    QXGuardAttribute *attr = (QXGuardAttribute *) attribute;
    
}

- (void) setup:(CGPoint) position layer:(CCLayer *)layer physicalWorld:(b2World *)world userData:(void *)data Qixall:(QXLaserQix *) tempQix type:(int) typeCode
{
    code = typeCode;
    
    state = 0;
    
    type = Guard;
    [super setUp:layer physicalWorld:world];
    laser = tempQix;
    
    isActive = true;
    explosion = [[QXExplosion alloc] init];
    _layer = layer;
    //laser = [[QXLaserQix alloc] init];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"littleJellyFish.plist"];
    _qixMonster = [CCSprite spriteWithSpriteFrameName:@"littleJellyFish0.png"];
    //sprite.anchorPoint = ccp(0,0);
    _qixMonster.position = ccp(0,0);
    _qixMonster.scale =1.5;
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"littleJellyFish.png"];
    [batchNode addChild:_qixMonster];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 32; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"littleJellyFish%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.02f];
    [_qixMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    _qixMonster.position = position;
    CGFloat anchorY = radius / [_qixMonster boundingBox].size.height;
    [_qixMonster setAnchorPoint:ccp(0.5f, anchorY)];
    [_qixMonster setRotation:arc4random()%360];
    
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
    //[_qixMonster runAction:[CCRepeatForever actionWithAction:rotateAction]];
}

-(double) distanceBetween:(CGPoint) p1 : (CGPoint)p2{
    
    double dis = sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
    
    return  dis;
}

- (void) takeAction:(CGPoint) pPosition
{
    targetTrace = pPosition;
    
    CGPoint qixPos = [laser position];
    
    CGPoint monsPos = _qixMonster.position;
    
   if(state == 0)
   {
    
    if([self distanceBetween:targetTrace :monsPos]>100 || ([[QXMap sharedMap] isBoundary:targetTrace]))
    {
        if(code == 1){
    
            CGPoint monsPosition = [laser position];
    
            _qixMonster.position = ccp(monsPosition.x + 15 +40*sin(angel),monsPosition.y + 15 +40*cos(angel));
    
        }
        if(code == 2){
        
            CGPoint monsPosition = [laser position];
        
            _qixMonster.position = ccp(monsPosition.x + 15 +40*sin(angel+CC_DEGREES_TO_RADIANS(120)),monsPosition.y + 15 +40*cos(angel+CC_DEGREES_TO_RADIANS(120)));
        
        }
        if(code == 3){
        
            CGPoint monsPosition = [laser position];
        
            _qixMonster.position = ccp(monsPosition.x + 15 +40*sin(angel+CC_DEGREES_TO_RADIANS(240)),monsPosition.y + 15 +40*cos(angel+CC_DEGREES_TO_RADIANS(240)));
        
        }
        angel+=0.02;
    }
    else{
        state = 1;
        
        CGPoint direct = ccp(targetTrace.x - monsPos.x,targetTrace.y - monsPos.y);
        
        double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
        
        direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
        
        NSLog(@"get into function %f %f",direct.x,direct.y);
        
        _qixMonster.position = ccp(monsPos.x + direct.x*0.8,monsPos.y + direct.y*0.8);
    }
   }

    if(state == 1){
        
        
        if([self distanceBetween:targetTrace :monsPos]<200 && (![[QXMap sharedMap] isBoundary:targetTrace]))
        {
            state =1;
            CGPoint direct = ccp(targetTrace.x - monsPos.x,targetTrace.y - monsPos.y);
        
            double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
        
            direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
        
            //NSLog(@"get into function %f %f",direct.x,direct.y);
        
            _qixMonster.position = ccp(monsPos.x + direct.x*0.8,monsPos.y + direct.y*0.8);
        }
        else
        {
            state = 2;
            
            
            if(code == 1){
                
                CGPoint direct = ccp(qixPos.x - monsPos.x -20,qixPos.y - monsPos.y);
                
                double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
                
                direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
                
                _qixMonster.position = ccp(monsPos.x + direct.x*1.2,monsPos.y + direct.y*1.2);
                
            }
            if(code == 2){
                
                CGPoint direct = ccp(qixPos.x - monsPos.x +20,qixPos.y - monsPos.y);
                
                double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
                
                direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);

                
                _qixMonster.position = ccp(monsPos.x + direct.x*1.2,monsPos.y + direct.y*1.2);
                
            }
            if(code == 3){
                
                CGPoint direct = ccp(qixPos.x - monsPos.x,qixPos.y - monsPos.y+20);
                
                double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
                
                direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
                
                _qixMonster.position = ccp(monsPos.x + direct.x*1.2,monsPos.y + direct.y*1.2);
                
            }
        }
    }
    
    if(state == 2){
        
        if([self distanceBetween:targetTrace :monsPos]<200 && (![[QXMap sharedMap] isBoundary:targetTrace]))
        {
            state = 1;
            
        }
        else if(code == 3 && [self distanceBetween:monsPos :ccp(qixPos.x,qixPos.y+20)] > 5)
        {
            CGPoint direct = ccp(qixPos.x - monsPos.x,qixPos.y - monsPos.y+20);
            
            double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
            
            direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
            
            _qixMonster.position = ccp(monsPos.x + direct.x*3,monsPos.y + direct.y*3);
            
            state = 2;
            
        }
        else if(code == 3 && [self distanceBetween:monsPos :ccp(qixPos.x,qixPos.y+20)] < 5)
        {
            state= 0;
            
            //_qixMonster.position = ccp(qixPos.x,qixPos.y+20);
            
        }
        else if(code == 2 && [self distanceBetween:monsPos :ccp(qixPos.x + 20,qixPos.y)] > 5)
        {
            CGPoint direct = ccp(qixPos.x - monsPos.x +20,qixPos.y - monsPos.y);
            
            double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
            
            direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
            
            _qixMonster.position = ccp(monsPos.x + direct.x*3,monsPos.y + direct.y*3);
            
            state = 2;
            
        }
        else if(code == 2 && [self distanceBetween:monsPos :ccp(qixPos.x+20,qixPos.y)] < 5)
        {
            state= 0;
            
            //_qixMonster.position = ccp(qixPos.x+20,qixPos.y);
            
        }
        else if(code == 1 && [self distanceBetween:monsPos :ccp(qixPos.x -20,qixPos.y)] > 5)
        {
            CGPoint direct = ccp(qixPos.x - monsPos.x -20,qixPos.y - monsPos.y);
            
            double modOfPoint = sqrt(direct.x*direct.x+direct.y*direct.y);
            
            direct = ccp(direct.x/modOfPoint,direct.y/modOfPoint);
            
            _qixMonster.position = ccp(monsPos.x + direct.x*3,monsPos.y + direct.y*3);
            
            state = 2;
            
        }
        else if(code == 1 && [self distanceBetween:monsPos :ccp(qixPos.x,qixPos.y+20)] < 5)
        {
            state= 0;
            
            //_qixMonster.position = ccp(qixPos.x -20,qixPos.y);
            
        }
        else
        {
            state = 0;
        }
        
    }


    
}
/********************************/
 -(double) AbsoluteValue:(double) input
{
    if(input<0)
    {
        return -input;
    }
    else
    {
        return input;
    }
}


- (void) collideWithExplosion
{
    isActive = false;
 //   [explosion explode:EGUARD layer:_layer position:_qixMonster.position];
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

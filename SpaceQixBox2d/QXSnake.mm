//
//  QXSnake.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/8/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXSnake.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"

@implementation QXSnake

- (void) setup:(b2World *)physicalWorld layer:(CCLayer *)layer
{
    [super setUp:layer physicalWorld:physicalWorld];
    snake = [[NSMutableArray alloc] init];
    attribute = [[QXSnakeAttribute alloc] init];
    winSize = [[CCDirector sharedDirector] winSize];
    [attribute setup:@"snake" Id:30 position: ccp(winSize.width/2, winSize.height/2) tag:@"snake" description:@"" stepDuration:0.14f snakeBodyLength:12];
    snakeBodyTags = [[NSMutableArray alloc] init];
    isActive = true;
    for (int i = 0; i < [attribute snakeBodyLength]; i++) {
        
        //*****animation****************
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"medal.plist"];
        CCSprite *snakeBody = [CCSprite spriteWithSpriteFrameName:@"medal0.png"];
        //sprite.anchorPoint = ccp(0,0);
        CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"medal.png"];
        [batchNode addChild:snakeBody];
        [layer addChild:batchNode];
        NSMutableArray *animFrames = [[NSMutableArray alloc] init];
        
        for(int i =1; i < 8; i++) {
            CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"medal%d.png", i]];
            [animFrames addObject:frame];
            
        }
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
        [snakeBody runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
        snakeBody.scale = 0.8;
        snakeBody.opacity = 255-i*200/[attribute snakeBodyLength];
        //******************************
        
        //CCSprite *snakeBody = [CCSprite spriteWithFile:@"wall_c.png"];
        //snakeBody.scale = 30.0f;
        //snakeBody.color = ccc3(255-i*255/[attribute snakeBodyLength], 255-i*255/[attribute snakeBodyLength], 255-i*255/[attribute snakeBodyLength]);
        snakeBody.position = ccp(winSize.width/2, winSize.height/2);
        snakeBody.tag = i;
        [snake addObject:snakeBody];
        //[layer addChild:snakeBody];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(snakeBody.position.x/PTM_RATIO, snakeBody.position.y/PTM_RATIO);
        
        if (i == 0) {
            bodyDef.userData = BODY_SNAKE_HEAD;
        } else {
            NSString *userData = [NSString stringWithFormat:@"%@%d", BODY_SNAKE_BODY_PREFIX, i];
            [snakeBodyTags addObject:userData];
            bodyDef.userData = userData;
        }
        
        b2Body *body = _world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 5.0/PTM_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 0.5f;
        fixtureDef.restitution = 0.8f;
        body->CreateFixture(&fixtureDef);
    }
    _qixMonster = [snake objectAtIndex:0];
    moveStep = 0;
    moveStepCount = 0;
    headAngle = arc4random()%360;
    angleChange = 120;
    
    timeBomb = [[QXTimeBomb alloc] init];
    [timeBomb setup:layer physicalWorld:physicalWorld];
}

- (void) takeAction:(ccTime) time spawnMissile:(void (^)(bool isSpawning, bool start, int tag)) spawnMissile
{
    moveStep+=time;
    
    
    [timeBomb fire:time fromPosition:ccp(-1,-1) target:ccp(-1,-1) direction:NODIR fireStop:^(int armorIndex) {
        if (spawnMissile) {
            spawnMissile(true, true, armorIndex);
        }
    }];
    
    if (moveStep >= [attribute stepDuration]) {
        
        moveStepCount++;
        moveStep = 0;
        CCSprite * snakeSub;
        snakeSub = [snake objectAtIndex:0];
        
        float preAngle = headAngle;
        headAngle = preAngle-angleChange/2+arc4random()%angleChange;
        if (headAngle > 360) {
            headAngle -= 360;
        }
        if (headAngle < 0) {
            headAngle += 360;
        }
        if (moveStepCount > [attribute snakeBodyLength]) {//每隔10步
            if (moveStepCount > 2*[attribute snakeBodyLength]) {
                moveStepCount = 0;
                [timeBomb spawnArmor:snakeSub.position];
            }
            newPos = ccp(0, 0);
        }
        else{
            newPos = ccp(20*cosf(CC_DEGREES_TO_RADIANS(headAngle)), 20*sinf(CC_DEGREES_TO_RADIANS(headAngle)));
        }
        
        CGPoint point = ccpAdd(snakeSub.position, ccp(newPos.x, 0));
        
        if (!([[QXMap sharedMap] isSpace:point] || [[QXMap sharedMap] isTrace:point])) {
            newPos.x = -newPos.x;
            headAngle -=180;
        }
        point = ccpAdd(snakeSub.position, ccp(0, newPos.y));
        
        if (!([[QXMap sharedMap] isSpace:point] || [[QXMap sharedMap] isTrace:point])) {
            newPos.y = -newPos.y;
            headAngle +=180;
        }
        
        newPos = ccpAdd(snakeSub.position, newPos);
        
        id snakeMove = [CCMoveTo actionWithDuration:[attribute stepDuration] position:newPos];
        [snakeSub runAction:snakeMove];
        [attribute updatePosition:newPos];
        for (int i = 1; i < [attribute snakeBodyLength]; i++) {//后面的body走向前面body的位置
            CCSprite * snakePre;
            snakePre = [snake objectAtIndex:i-1];
            id snakeMove = [CCMoveTo actionWithDuration:[attribute stepDuration] position:snakePre.position];
            CCSprite *snakeCurr = [snake objectAtIndex:i];
            [snakeCurr runAction:snakeMove];
        }
        
    }
}



- (void) takeAction:(ccTime) delta
{
    
        moveStep+=delta;
    
        [timeBomb fire:delta fromPosition:ccp(-1,-1) target:ccp(-1,-1) direction:NODIR fireStop:^(int) {
            ;
        }];
    
        if (moveStep >= [attribute stepDuration]) {
        
            moveStepCount++;
            moveStep = 0;
            CCSprite * snakeSub;
            snakeSub = [snake objectAtIndex:0];
        
            float preAngle = headAngle;
                headAngle = preAngle-angleChange/2+arc4random()%angleChange;
                if (headAngle > 360) {
                    headAngle -= 360;
                }
            if (headAngle < 0) {
                headAngle += 360;
            }
            if (moveStepCount > [attribute snakeBodyLength]) {//每隔10步
                if (moveStepCount > 2*[attribute snakeBodyLength]) {
                    moveStepCount = 0;
                    [timeBomb spawnArmor:snakeSub.position];
                }
                newPos = ccp(0, 0);
            }
            else{
                newPos = ccp(20*cosf(CC_DEGREES_TO_RADIANS(headAngle)), 20*sinf(CC_DEGREES_TO_RADIANS(headAngle)));
            }
        
            CGPoint point = ccpAdd(snakeSub.position, ccp(newPos.x, 0));
        
                if (!([[QXMap sharedMap] isSpace:point] || [[QXMap sharedMap] isTrace:point])) {
                    newPos.x = -newPos.x;
                    headAngle -=180;
                }
                point = ccpAdd(snakeSub.position, ccp(0, newPos.y));
        
            if (!([[QXMap sharedMap] isSpace:point] || [[QXMap sharedMap] isTrace:point])) {
                newPos.y = -newPos.y;
                headAngle +=180;
            }
        
            newPos = ccpAdd(snakeSub.position, newPos);
        
            id snakeMove = [CCMoveTo actionWithDuration:[attribute stepDuration] position:newPos];
            [snakeSub runAction:snakeMove];
            [attribute updatePosition:newPos];
                for (int i = 1; i < [attribute snakeBodyLength]; i++) {//后面的body走向前面body的位置
                    CCSprite * snakePre;
                    snakePre = [snake objectAtIndex:i-1];
                    id snakeMove = [CCMoveTo actionWithDuration:[attribute stepDuration] position:snakePre.position];
                    CCSprite *snakeCurr = [snake objectAtIndex:i];
                    [snakeCurr runAction:snakeMove];
                }
        
        }

}

- (CCSprite *) findQixBodyByIndex:(int)index
{
    for (int i = 0; i < [snake count]; i++) {
        CCSprite *sprite = [snake objectAtIndex:i];
        if (sprite.tag == index) {
            return sprite;
        }
    }
    return nil;
}

- (QXSnakeAttribute *) attributes
{
    return attribute;
}

- (QXArmor *) armor
{
    return timeBomb;
}





/*************************************/
- (void) hitByGlacierFrozen
{
    [_qixMonster stopAllActions];
    isActive = false;
    NSLog(@"Snake should stop all actions");
}

- (void) hitByGlacierFrozenEnd:(CCLayer*)layer
{
    _layer = layer;
    [[[QXPlayers sharedPlayers] frozenMissileSprite ] removeFromParentAndCleanup:YES];
    isActive = true;
    [self iceExplode:layer];
    
}


-(void)iceExplode:(CCLayer*)layer
{
 
    [[CDAudioManager sharedManager].soundEngine playSound:SND_BRK
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"iceExplode.plist"];
    
    CCSprite *dustUnder = [CCSprite spriteWithSpriteFrameName:@"iceExplode0.png"];
    
    dustUnder.anchorPoint = ccp(0.5,0.5);
    dustUnder.scale = 4;
    
    dustUnder.position = ccpAdd(_qixMonster.position, ccp(45, 35));
    
    CCSpriteBatchNode * batchNodeDustUnder = [CCSpriteBatchNode batchNodeWithFile:@"iceExplode.png"];
    
    [batchNodeDustUnder addChild:dustUnder];
    
    [layer addChild:batchNodeDustUnder];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 17; i++) {
        
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"iceExplode%d.png", i]];
        
        [animFrames addObject:frame];
        
        
        
    }
    
    CCAnimation * animation2 = [CCAnimation animationWithSpriteFrames:animFrames delay:0.09f];
    
    [dustUnder runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation2] times:1]];
    
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeIceExplode:)];
    
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
    
    [dustUnder runAction:sequence];
    
    
}

-(void)removeIceExplode:(id)sender

{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
    [_qixMonster stopAllActions];
    isActive = true;
}


- (void) qixOpacityChange
{
    [[QXPlayers sharedPlayers] frozenMissileSprite].opacity = [[QXPlayers sharedPlayers] frozenMissileSprite].opacity - 20;
}




@end

//
//  QXDropItemArmor.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/17/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXTimeBomb.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "AppDelegate.h"
#import "GB2ShapeCache.h"
#import "QXMap.h"

@implementation QXTimeBomb

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world
{
    [super setup:layer physicalWorld:world];
    _items = [[NSMutableArray alloc] init];
    itemIndex = 0;
    itemTags = [[NSMutableArray alloc] init];
    timers = [[NSMutableDictionary alloc] init];
    
    attribute = [[QXTimeBombAttribute alloc] init];
    NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
    [attr setObject:[NSNumber numberWithDouble:5.0f] forKey:KEY_TIME_BOMB_TIMER];
    [attribute build:attr];
}

- (CCSprite *) spawnArmor:(CGPoint)position
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"battery.plist"];
    CCSprite* droppedItem = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
    
    CCSpriteBatchNode * batchNode = [CCSpriteBatchNode batchNodeWithFile:@"battery.png"];
    [batchNode addChild:droppedItem];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 2; i++) {
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"battery%d.png", i]];
        [animFrames addObject:frame];
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [droppedItem runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    [_layer addChild:batchNode];
    
    droppedItem.tag = itemIndex;
    [timers setObject:[NSNumber numberWithDouble:0.0f] forKey:[NSNumber numberWithInt:itemIndex]];
    [_items addObject:droppedItem];
    
    droppedItem.position = position;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    NSString *userData = [NSString stringWithFormat:@"%@%d", BODY_SNAKE_ITEM_PREFIX, itemIndex++];
    [itemTags addObject:userData];
    bodyDef.userData = userData;
    b2Body *body = _world->CreateBody(&bodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 5.0/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 0.5f;
    fixtureDef.restitution = 0.8f;
    body->CreateFixture(&fixtureDef);
    return droppedItem;
}

- (void) fire:(ccTime)time  fromPosition:(CGPoint)position target:(CGPoint)target direction:(int)direction fireStop:(void (^)(int armorIndex)) fireStop
{
    for (id key in timers.allKeys) {
        double value = [[timers objectForKey:key] doubleValue];
        if (value == -1) {
            // exploded
            continue;
        }
        
        for (int delta = [attribute timer] - 1; delta >= 0; delta--) {
            if (value + time > delta) {
                CCSprite  *sprite = [self missile:[key intValue]];
                CGPoint position = ccpAdd(sprite.position, ccp(0, [sprite boundingBox].size.height/2));
                switch (delta) {
                    case 0:
                        [[QXTimerEffect sharedTimerEffect] display:FIVE layer:_layer position:position];
                        break;
                    case 1:
                        [[QXTimerEffect sharedTimerEffect] display:FOUR layer:_layer position:position];
                        break;
                    case 2:
                        [[QXTimerEffect sharedTimerEffect] display:THREE layer:_layer position:position];
                        break;
                    case 3:
                        [[QXTimerEffect sharedTimerEffect] display:TWO layer:_layer position:position];
                        break;
                    case 4:
                        [[QXTimerEffect sharedTimerEffect] display:ONE layer:_layer position:position];
                        break;
                    case 5:
                        break;
                    default:
                        break;
                }
                break;
            }
        }
        
        if (value + time > [attribute timer]) {
            [timers setObject:[NSNumber numberWithDouble:-1] forKey:key];
            // explode
            [[QXExplosion sharedExplosion] explode:ETIME_BOMB layer:_layer position:[self missile:[key intValue]].position];
            if (fireStop) {
                fireStop([key intValue]);
            }
        } else {
            [timers setObject:[NSNumber numberWithDouble:value + time] forKey:key];
        }
    }
}

- (CCSprite *) missile:(int)tag
{
    for (int i = 0; i < [_items count]; i++) {
        CCSprite *sprite = [_items objectAtIndex:i];
        if (sprite.tag == tag) {
            return sprite;
        }
    }
    return nil;
}

- (void) cleanUpSpecificMissile:(int)tagNum
{
    for (int i = 0; i < [_items count]; i++) {
        CCSprite *projectile = [_items objectAtIndex:i];
        if (projectile.tag == tagNum) {
            [_items removeObject:projectile];
            NSLog(@"remove specifig missile: %d", tagNum);
            [projectile  removeFromParentAndCleanup:YES];
            [timers removeObjectForKey:[NSNumber numberWithInt:tagNum]];
        }
    }
    
}

- (void) cleanUpMissiles
{
    [timers removeAllObjects];
    [_items removeAllObjects];
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            // update the sprite position to be consistency with box body location
            NSString *value = (NSString *)b->GetUserData();
            NSString *m = @"";
            if (value.length > BODY_SNAKE_ITEM_PREFIX.length) {
                m = [value substringToIndex:BODY_SNAKE_ITEM_PREFIX.length];
                if ([m isEqualToString:BODY_SNAKE_ITEM_PREFIX]) {
                    b->GetWorld()->DestroyBody(b);
                }
            }
        }
    }
}

- (void) cleanUpMissilesOutOfScreen
{
    
}

- (int) cleanUpMissilesInClaimedArea
{
    int cnt = 0;
    NSMutableArray *toDelSprite = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_items count]; i++) {
        CCSprite *item = [_items objectAtIndex:i];
        if ([[QXMap sharedMap] isFill:item.position] || [[QXMap sharedMap] isWall:item.position] || [[QXMap sharedMap] isBoundary:item.position]) {
            cnt++;
            [toDelSprite addObject:item];
            [timers removeObjectForKey:[NSNumber numberWithInteger:item.tag]];
            [_items removeObjectAtIndex:i];
            i--;
        }
    }
    if (cnt != 0) {
        for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
            if (b->GetUserData() != NULL) {
                NSString *value = (NSString *)b->GetUserData();
                if (value.length > BODY_SNAKE_ITEM_PREFIX.length && [[value substringToIndex:BODY_SNAKE_ITEM_PREFIX.length] isEqualToString:BODY_SNAKE_ITEM_PREFIX]) {
                    int index = [[value substringFromIndex:BODY_SNAKE_ITEM_PREFIX.length] intValue];
                    for (int i = 0; i < [toDelSprite count]; i++) {
                        CCSprite *sprite = [toDelSprite objectAtIndex:i];
                        if (sprite.tag == index) {
                            _world->DestroyBody(b);
                            break;
                        }
                    }
                }
            }
        }
    }
    for (int i = 0; i < [toDelSprite count]; i++) {
        CCSprite *sprite = [toDelSprite objectAtIndex:i];
        [sprite removeFromParentAndCleanup:YES];
    }
    [toDelSprite removeAllObjects];
    return cnt;
}

- (NSMutableArray *)items
{
    return _items;
}

- (int) currentItemIndex
{
    return itemIndex;
}

@end

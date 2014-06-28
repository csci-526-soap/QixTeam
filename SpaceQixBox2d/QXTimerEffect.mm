//
//  QXTimerEffect.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/21/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXTimerEffect.h"

@implementation QXTimerEffect

static dispatch_once_t QXTimerEffectPredicate;
static QXTimerEffect *sharedTimerEffect = nil;

+ (QXTimerEffect *)sharedTimerEffect {
    dispatch_once(&QXTimerEffectPredicate, ^{
        sharedTimerEffect = [[QXTimerEffect alloc] init];
    });
    return sharedTimerEffect;
}

- (id) init
{
    id ret = [super init];
    callbackHolder = [[NSMutableArray alloc] init];
    return ret;
}

- (void) display:(enum QXTimer)timer layer:(CCLayer *)layer position:(CGPoint)position
{
    CCSprite *sprite;
    switch (timer) {
        case FIVE:
            sprite = [CCSprite spriteWithFile:@"num5.png"];
            break;
        case FOUR:
            sprite = [CCSprite spriteWithFile:@"num4.png"];
            break;
        case THREE:
            sprite = [CCSprite spriteWithFile:@"num3.png"];
            break;
        case TWO:
            sprite = [CCSprite spriteWithFile:@"num2.png"];
            break;
        case ONE:
            sprite = [CCSprite spriteWithFile:@"num1.png"];
            break;
        case ZERO:
            sprite = [CCSprite spriteWithFile:@"num0.png"];
            break;
        default:
            break;
    }
    sprite.position = ccpAdd(position, ccp(0, [sprite boundingBox].size.height * 0.3));
//    sprite.position = position;
    sprite.scale = 0.3;
    [layer addChild:sprite];
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.1f],vanishAction,nil];
    [sprite runAction:sequence];
}

// display the count down timer on the layer at position. the callback is called when the timer count down to zero
- (void) displayCountDownTimer:(enum QXCountDownTimer) timer layer:(CCLayer *)layer position:(CGPoint)position  onCompletion:(void(^)()) callback
{
    [callbackHolder removeAllObjects];
    countDownCallback = callback;
    [callbackHolder addObject:callback];
    id scaleL = [CCScaleTo actionWithDuration:0.5f scale:1.5f];
    id scaleB = [CCScaleTo actionWithDuration:0.5f scale:0.8f];
    CCCallFunc* displayAction = [CCCallFuncN actionWithTarget:self selector:@selector(displaySprite:)];
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
    CCCallFunc *callbackAction = [CCCallFuncN actionWithTarget:self selector:@selector(callback:)];
    id delay = [CCDelayTime actionWithDuration:1.0f];
    int i = 0;
    switch (timer) {
        case CD_THREE:
            i = 3;
            break;
        case CD_TWO:
            i = 2;
            break;
        case CD_ONE:
            i = 1;
            break;
        default:
            i = 0;
            break;
    }
    for (; i >= 1; i--) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        CCSprite *sprite;
        for (int j = 0; j < 3-i; j++) {
            [array addObject:delay];
        }
        [array addObject:displayAction];
        [array addObject:scaleL];
        [array addObject:scaleB];
        switch (i) {
            case 3:
                [array addObject:vanishAction];
                sprite = [CCSprite spriteWithFile:@"num3.png"];
                break;
            case 2:
                [array addObject:vanishAction];
                sprite = [CCSprite spriteWithFile:@"num2.png"];
                break;
            case 1:
                [array addObject:callbackAction];
                sprite = [CCSprite spriteWithFile:@"num1.png"];
                break;
            default:
                break;
        }
        sprite.position = position;
        [layer addChild:sprite];
        sprite.opacity = 0;
        [sprite runAction:[CCSequence actionWithArray:array]];
    }
}

- (void) displaySprite:(id) sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    bgSprite.opacity = 255;
}

-(void)removeSprite:(id)sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];

}

- (void) callback:(id) sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
    NSLog(@"callback called");
    if (countDownCallback) {
        countDownCallback();
    }
}

@end

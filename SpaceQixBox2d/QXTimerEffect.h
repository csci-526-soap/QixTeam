//
//  QXTimerEffect.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/21/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum QXTimer {FIVE, FOUR, THREE, TWO, ONE, ZERO};

enum QXCountDownTimer {CD_THREE, CD_TWO, CD_ONE};

@interface QXTimerEffect : NSObject {
    NSMutableArray *callbackHolder;
    void (^countDownCallback)();
}

+ (QXTimerEffect *) sharedTimerEffect;

// display a number on the layer at position p.
- (void) display:(enum QXTimer)timer layer:(CCLayer *)layer position:(CGPoint)position;

// display the count down timer on the layer at position. the callback is called when the timer count down to zero
- (void) displayCountDownTimer:(enum QXCountDownTimer) timer layer:(CCLayer *)layer position:(CGPoint)position onCompletion:(void(^)()) callback;

@end

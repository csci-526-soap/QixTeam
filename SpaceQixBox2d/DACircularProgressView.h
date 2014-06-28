//
//  DACircularProgressView.h
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timer.h"
#import <QuartzCore/QuartzCore.h>
#define EVENT_PROGRESS_HEARTBEAT 1
#define EVENT_PROGRESS_NORMAL 2

#define STATE_HIGH_SPEED 3
#define STATE_NORMAL 1
#define STATE_CONGRATULATION 2

static const CGSize progressViewSize = { 200.0f, 30.0f };
@interface DACircularProgressView : UIView<EventProcessor>
{
    float step;
    id heartbeatId;
    int currentState;
    int eventStackNumber;
}
@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic) float progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;
- (void)eventHappen: (int)atPicture EventIdentifier:(int) eventIdentifier;
- (void)nitrogenAdd: (CGFloat)ratio;
- (id)initAsNetrogenBar:(CGRect) space;
- (void)highSpeedKeyDown;

@end

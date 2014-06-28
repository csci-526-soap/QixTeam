//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"
#import "QXPlayers.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))
static const int nitrogenHight=80;
static const int nitrogenWidth=80;
static const float minStep=0.005;

@implementation DACircularProgressView

@synthesize trackTintColor = _trackTintColor;
@synthesize progressTintColor =_progressTintColor;
@synthesize progress = _progress;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat pathWidth = radius * 0.3f;
    
    CGFloat radians = DEGREES_2_RADIANS((_progress*359.9)-90);
    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
    CGPoint endPoint = CGPointMake(xOffset, yOffset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.trackTintColor setFill];
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    [self.progressTintColor setFill];
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);;
    CGFloat innerRadius = radius * 0.7;
	CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);    
	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
	CGContextFillPath(context);
}

#pragma mark - Property Methods

- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        _trackTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
        [_trackTintColor retain];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!_progressTintColor)
    {
        _progressTintColor = [UIColor whiteColor];
    }
    return _progressTintColor;
}

- (id)initAsNetrogenBar:(CGRect) space
{
    if (self = [super initWithFrame:space]) {
        self.backgroundColor = [UIColor clearColor];
        heartbeatId=nil;
        [self normalState];
        [self setProgress:0.5 animated:YES];
        eventStackNumber=0;
    }
    return self;
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if(progress<0)
    {
        progress=0.01;
        [self normalState];
    }
    
    if(progress>1)
    {
        progress=1;
    }
    _progress = progress;
    if(currentState!=STATE_HIGH_SPEED)
    {
        [[QXPlayers sharedPlayers] disableAccelerate];
        [[QXPlayers sharedPlayers] setV:(ceil(_progress*3)+1)];
    }
    
    if(animated)
    {
        [self setNeedsDisplay];
    }
}

-(void) normalState
{
    if(heartbeatId!=Nil)
    {
        [[Timer instance] deleteEvent:heartbeatId];
         heartbeatId=nil;
    }
    currentState=STATE_NORMAL;
    _progressTintColor=[UIColor whiteColor];
    [self setNeedsDisplay];
}

-(void) congratualationState
{
    [self addHeartBeat];
    eventStackNumber++;
    _progressTintColor=[UIColor whiteColor];
    step=minStep;
    currentState=STATE_CONGRATULATION;
    [self setNeedsDisplay];
}

-(void) highSpeadState
{
    [self addHeartBeat];
    _progressTintColor=[UIColor redColor];
    step=-2*minStep;
    currentState=STATE_HIGH_SPEED;
    [[QXPlayers sharedPlayers] enableAccelerate];
    [[QXPlayers sharedPlayers] setV:accelerateVelocity];
    [self setNeedsDisplay];
}

- (void)eventHappen: (int)atPicture EventIdentifier:(int) eventIdentifier
{
    switch(eventIdentifier)
    {
        case EVENT_PROGRESS_HEARTBEAT:
            [self setProgress:_progress+step animated:YES];
            break;
        case EVENT_PROGRESS_NORMAL:
            eventStackNumber--;
            if(eventStackNumber<=0)
            {
                if(currentState!=STATE_HIGH_SPEED)
                {
                    [self normalState];
                }
                eventStackNumber=0;
            }
        default:
            break;
    }
}

- (void)nitrogenAdd: (CGFloat)ratio;
{
    if(currentState<=STATE_CONGRATULATION)
    {
        [self congratualationState];
        [[Timer instance] addEvent:ceil(ratio/minStep)*1 EventDelegate:self EventIdendifier:EVENT_PROGRESS_NORMAL ifRepeat:NO];
    }
    else
    {
        [self setProgress:_progress+ratio];
    }
}

- (void)highSpeedKeyDown
{
    if(_progress<=0)
    {
        return;
    }
    else
    {
        if(currentState>STATE_CONGRATULATION)
        {
            //不能触发，但或许可以设置一些状态
        }
        else
        {
            [self highSpeadState];
        }
    }
}

- (void)addHeartBeat
{
    if(heartbeatId==nil)
    {
    heartbeatId=[[Timer instance] addEvent:1 EventDelegate:self EventIdendifier:EVENT_PROGRESS_HEARTBEAT ifRepeat:YES];
    }
}
@end

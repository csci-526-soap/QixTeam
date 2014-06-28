//
//  Timer.m
//  Cocos2dTest
//
//  Created by Jun Huang on 2/24/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import "Timer.h"

#define CHECK_EVENT_STEP 0x01
#define PIC_PER_SECOND 30


@interface PicEvent:NSObject{
}
@property (nonatomic, assign)int interval;
@property (nonatomic, assign)BOOL repeat;
@property (nonatomic, assign)int nextPicToHappen;
@property (nonatomic, assign)int indentifier;
@property (nonatomic, retain)NSObject<EventProcessor>*processor;
@end
@implementation PicEvent
@end




static Timer *instance = nil;
@implementation Timer

- (void) resetTime
{
    start=[NSDate date];
}

- (id)init {
    [super init];
    [self resetTime];
    events=[[NSMutableArray alloc] init];
    eventsToDelete=[[NSMutableArray alloc] init];
    return self;
}

- (double) timeElapsedInSeconds {
    return [[NSDate date] timeIntervalSinceDate:start];
}

- (double) timeElapsedInMilliseconds {
    return [self timeElapsedInSeconds] * 1000.0f;
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}

- (id) addEvent:(int)pictureInterval //return a new index
EventDelegate:(NSObject<EventProcessor>*)eventProcessor
 EventIdendifier:(int) idendifier ifRepeat:(BOOL)repeat;
{
    PicEvent* event=[[PicEvent alloc] init];
    event.interval=pictureInterval;
    event.processor=eventProcessor;
    event.indentifier=idendifier;
    event.nextPicToHappen=pictures+event.interval;
    event.repeat=repeat;
    
    [events addObject:event];
    return event;
}

- (void) deleteEvent:(id) objPointer
{
    [eventsToDelete addObject:objPointer];
}

- (void) picturesDrivenEvent
{
    pictures++;
    if((pictures&CHECK_EVENT_STEP)==0)
    {
        for(id pointer in eventsToDelete)
        {
            [events removeObject:pointer];
        }
        [eventsToDelete removeAllObjects];
        
        for(PicEvent *pe in events)
        {
            if(pe.nextPicToHappen<pictures)
            {
                [pe.processor eventHappen:pictures EventIdentifier:pe.indentifier];
                if(pe.repeat)
                {
                    pe.nextPicToHappen=pictures+pe.interval;
                }
                else
                {
                    [eventsToDelete addObject:pe];
                }
            }
        }
    }
}

- (int) getNowRealTime
{
    return pictures/PIC_PER_SECOND;
}

+(id)instance{
    if (instance == nil) {
        instance = [[super alloc] init];
    }
    return instance;
}
@end



//
//  Timer.h
//  Cocos2dTest
//
//  Created by Jun Huang on 2/24/14.
//  Copyright (c) 2014 Xin ZHANG. All rights reserved.
//

#import "AppDelegate.h"
#define EVENT_MESSAGE_DELETE -1
#define EVENT_MESSAGE_COMPLETE 0
@protocol EventProcessor <NSObject>
@required
- (void) eventHappen: (int)atPicture EventIdentifier:(int) eventIdentifier;
@end

@interface Timer : AppController
{
    NSDate *start;
    NSDate *end;
    int pictures;
    int checkSteps;
    NSMutableArray *events;
    NSMutableArray *eventsToDelete;
}


+(id)instance;
- (void) resetTime;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;
- (void) picturesDrivenEvent;
- (id) addEvent:(int)pictureInterval //return a new index
         EventDelegate:(NSObject<EventProcessor>*)eventProcessor
EventIdendifier:(int) idendifier ifRepeat:(BOOL)repeat;
- (void) deleteEvent:(id) objPointer;
@end

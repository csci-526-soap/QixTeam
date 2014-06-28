//
//  QXMap.h
//  SpaceQix
//
//  Created by Haoyu Huang on 2/1/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

enum QXTraceState {START, GO, STOP, OVER, WAIT};
const static int UP = 0;
const static int DOWN = 2;
const static int LEFT = 3;
const static int RIGHT = 1;
const static int NODIR = -1;

const static int UP_RIGHT = 4;
const static int BOTTOM_RIGHT = 5;
const static int BOTTOM_LEFT = 6;
const static int UP_LEFT = 7;

const static int JOYSTICK_BOUNDARY = 100;
const static int moveX[] = {-1,0,1,0};
const static int moveY[] = {0,1,0,-1};
#define PTM_RATIO 32.0

// the monster velocity
const static int monsterVelocity = 1;

@interface QXMap : NSObject {
    
    NSUInteger width;
    NSUInteger height;
    // the wall points in cocos2d coordination
    NSMutableArray *wall;
    // the filledSpace points in cocos2d coordination
    NSMutableArray *filledSpace;
    
    NSMutableArray *boundary;
    
    // the map.
    int array[960][640];
    
    //the trace points in cocos2d coordination
    NSMutableArray *trace;
    
    // test
    NSMutableArray *traces;
    
    // filled area
    int filledArea;
    
    // the empty area, the initial value is width*height
    int emptyArea;
    
    // the newly filled area
    int newlyFilledArea;
    
    // the entire area, the value is width*height;
    int entireArea;
    
    // the current start point
    CGPoint start;
    // the current stop point
    CGPoint stop;
    
    // the from point holds the value for the immediate take action call
    CGPoint from;
    // the to point holds the value for the immediate take action call
    CGPoint to;
    // the direction holds the value for the immediate take action call
    int direction;
    // the variable used to judge if the direction has been changed
    bool changeDirection;
    
    enum QXTraceState state;
}

// set up initial state;
- (void) setupInitialState:(int) w height:(int)h startPoint:(CGPoint)start;
-(void) clearArea;

// call this method when the character want to move one unit
- (bool) canMovetoPosition:(int)x y:(int)y direction:(int)direction;

// call this method when the character move one unit
- (void) moveFrom:(CGPoint) fpoint to:(CGPoint) tpoint direction:(int)direction;

// take action based on the current state, and call the completion block after filling the polygon
- (void) takeAction:(NSArray *)points qix:(CGPoint)qix completion:(void (^)(bool fill, NSArray* collision, QXTraceState state)) completion fillCallback:(void (^)(int x, int y)) fillCallback;

// the two-dimension map
- (int (*)[960][640]) map;

// generate the start point
- (CGPoint) generateStartPoint;

// singleton instance
+ (QXMap *)sharedMap;

// method used in polygon fill algorithm
- (NSMutableArray *) haoyu:(NSMutableArray*) filledSpace tempFilledSpace:(NSMutableArray *) temp;

- (NSArray *)poly1;

- (NSArray *)poly2;

// walls consist of CGPoitns
- (NSArray *) wall;

// trace consist of CGPoitns
- (NSArray *) trace;

// filledSpace consist of CGPoitns
- (NSArray *) filledSpace;

// the boundary;
- (NSArray *) boundary;

// the area of filled space
- (int) filledArea;

// the area of empty space
- (int) emptyArea;

// the newly filled area;
- (int) newlyFilledArea;

// the entire area;
- (int) entireArea;

// return true if the point is in a wall
- (bool) isWall:(CGPoint) point;

// return true if the point is in a trace
- (bool) isTrace:(CGPoint) point;

// return true if the point is in filled space
- (bool) isFill:(CGPoint) point;

// return true if the point is in empty space
- (bool) isSpace:(CGPoint) point;

// return true if the point is in boundary
- (bool) isBoundary:(CGPoint) point;

// call this method when the game is over
- (void) gameOver;

// return true if game is over
- (bool) isGameOver;

// return true if the point is inside the closed polygon. 
- (bool)isInsidePolygon:(NSArray *)polygon point:(CGPoint)point;

- (NSArray *) traces;

+ (double) distance:(CGPoint) p q:(CGPoint)q;

// return the start point if the current state is GO or START
- (CGPoint) respawn;
@end

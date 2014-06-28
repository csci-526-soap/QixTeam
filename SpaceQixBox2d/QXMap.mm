//
//  QXMap.m
//  SpaceQix
//
//  Created by Haoyu Huang on 2/1/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//
#import "QXMap.h"

@implementation QXMap

#pragma mark private fields

#pragma mark static fields

const static NSUInteger TRACE = 3;
const static NSUInteger WALL = 1;
const static NSUInteger SPACE = 0;
const static NSUInteger FILL = 2;
const static NSUInteger BOUNDARY = 4;
const static NSUInteger EMPTY = -1;

static const int colorSize = 8;
static const int color[] = {-1,-2,-3,-4,-5,-6,-7,-8};
static const int offsetSize = 8;
static const int offsetX[] = {-1,-1,-1,0,0,1,1,1};
static const int offsetY[] = {-1,0,1,-1,1,-1,0,1};

#pragma mark methods

static dispatch_once_t QXMapPredicate;
static QXMap *sharedMap = nil;

+ (QXMap *)sharedMap {
    dispatch_once(&QXMapPredicate, ^{
        sharedMap = [[QXMap alloc] init];
    });
    return sharedMap;
}

-(void) clearArea{
    filledArea = 0;
}

- (CGPoint) generateStartPoint
{
    //int winsize = [cc];
    return CGPointMake(width/3, 0);
}

- (void) setupInitialState:(int) w height:(int)h startPoint:(CGPoint)start
{
    NSLog(@"width: %d height: %d", w, h);
    
    width = w;
    height = h;
    newlyFilledArea = 0;
    wall = [[NSMutableArray alloc] init];
    trace = [[NSMutableArray alloc] init];
    traces = [[NSMutableArray alloc] init];
    
    filledSpace = [[NSMutableArray alloc] init];
    boundary = [[NSMutableArray alloc] init];
    poly1 = [[NSMutableArray alloc] init];
    poly2 = [[NSMutableArray alloc] init];
    for (int i = 0; i <= width; i++) {
        for (int j = 0; j <= height; j++) {
            if (i == 0 ||( i == (width) )|| j == 0 ||(j == (height))) {
                array[i][j] = BOUNDARY;
            } else {
                array[i][j] = SPACE;
            }
        }
    }
    state = WAIT;
    
    for(int i=0;i<=JOYSTICK_BOUNDARY;i++) {
//        array[i][0] = FILL;
        array[i][JOYSTICK_BOUNDARY] = BOUNDARY;
//        array[0][i] = FILL;
        array[JOYSTICK_BOUNDARY][i] = BOUNDARY;
    }
    
    for (int i = 0; i < JOYSTICK_BOUNDARY; i++) {
        for (int j = 0; j < JOYSTICK_BOUNDARY; j++) {
            array[i][j] = FILL;
        }
    }
    
    emptyArea = width * height;
    entireArea = emptyArea;
    
    [boundary addObject:[NSValue valueWithCGPoint:CGPointMake(0, height) ]];
    [boundary addObject:[NSValue valueWithCGPoint:CGPointMake(width, height) ]];
    [boundary addObject:[NSValue valueWithCGPoint:CGPointMake(width, 0) ]];
    [boundary addObject:[NSValue valueWithCGPoint:CGPointMake(JOYSTICK_BOUNDARY, 0) ]];
    [boundary addObject:[NSValue valueWithCGPoint:CGPointMake(JOYSTICK_BOUNDARY, JOYSTICK_BOUNDARY) ]];
    [boundary addObject:[NSValue valueWithCGPoint:CGPointMake(0, JOYSTICK_BOUNDARY) ]];
}

- (bool) canMovetoPosition:(int)x y:(int)y  direction:(int) direction
{
    bool canMove = false;
    switch (direction) {
        case UP:
            if (y+1 <= height && array[x][y+1] != FILL && array[x][y+1] != WALL && array[x][y+1] != TRACE) {
                canMove = true;
            } else if (y == height) {
                canMove = false;
            }
            break;
        case DOWN:
            if (y-1 >= 0 && array[x][y-1] != FILL && array[x][y-1] != WALL && array[x][y-1] != TRACE) {
                canMove = true;
            } else if (y == 0) {
                canMove = false;
            }
            break;
        case LEFT:
            if (x - 1 >= 0 && array[x-1][y] != FILL && array[x-1][y] != WALL && array[x-1][y] != TRACE) {
                canMove = true;
            } else if (x == 0) {
                canMove = false;
            }
            break;
        case RIGHT:
            if (x + 1 <= width && array[x+1][y] != FILL && array[x+1][y] != WALL && array[x+1][y] != TRACE) {
                canMove = true;
            } else if (x == width) {
                canMove = false;
            }
            break;
        default:
            break;
    }
    return canMove;
}

- (void) moveFrom:(CGPoint) fpoint to:(CGPoint) tpoint direction:(int)dir
{
    NSUInteger value = array[(int)tpoint.x][(int)tpoint.y];
    from = fpoint;
    to = tpoint;
    if (direction == dir) {
        changeDirection = false;
    } else {
        changeDirection = true;
    }
    direction = dir;
//    enum QXTraceState ps = state;
    switch (state) {
        case START:
            switch (value) {
                case SPACE:
                    state = GO;
                    break;
                case FILL:
                    // do things for over state
                    break;
                case WALL:
                    // do things for stop state
                    break;
                case TRACE:
                    // do things for over state
                    break;
                case BOUNDARY:
                    // do nothing;
                    break;
                default:
                    break;
            }
            break;
        case GO:
            switch (value) {
                case SPACE:
                    // do things for go state;
                    break;
                case FILL:
                    state = OVER;
                    // do things for over state
                    break;
                case WALL:
                    state = STOP;
                    // do things for stop state
                    break;
                case TRACE:
                    state = OVER;
                    // do things for over state
                    break;
                case BOUNDARY:
                    state = STOP;
                    // do things for stop state
                    break;
                default:
                    break;
            }
            break;
        case STOP:
            switch (value) {
                case SPACE:
                    state = START;
                    // do things for start state
                    break;
                case FILL:
                    state = OVER;
                    // do things for over state
                    break;
                case WALL:
                    state = WAIT;
                    // do things for stop state
                    break;
                case TRACE:
                    state = OVER;
                    // do things for over state
                    break;
                case BOUNDARY:
                    state = WAIT;
                    // do things for stop state
                    break;
                default:
                    break;
            }
            break;
        case WAIT:
            switch (value) {
                case SPACE:
                    state = START;
                    // do things for start state
                    break;
                case FILL:
                    state = OVER;
                    // do things for over state
                    break;
                case WALL:
                    state = WAIT;
                    // do things for stop state
                    break;
                case TRACE:
                    state = OVER;
                    // do things for over state
                    break;
                case BOUNDARY:
                    state = WAIT;
                    // do things for stop state
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
//    if (ps != state) {
//        NSLog(@"current state: %u", ps);
//        NSLog(@"transfered state: %u", state);
//    }
}

- (void) takeAction:(NSArray *)points qix:(CGPoint)qix completion:(void (^)(bool fill, NSArray* collision, QXTraceState state)) completion fillCallback:(void (^)(int x, int y)) fillCallback
{
    switch (state) {
        case START:
            start = from;
            if (array[(int)start.x][(int)start.y] != TRACE) {
                [traces addObject:[NSNumber valueWithCGPoint:start]];
            }
            array[(int)to.x][(int)to.y] = TRACE;
            [trace addObject:[NSNumber valueWithCGPoint:start]];
            if (completion) {
                completion(false, nil, state);
            }
            break;
        case GO:
            if (array[(int)to.x][(int)to.y] != TRACE) {
                [traces addObject:[NSNumber valueWithCGPoint:to]];
            }
            array[(int)to.x][(int)to.y] = TRACE;
            if (changeDirection) {
                [trace addObject:[NSNumber valueWithCGPoint:from]];
            }
            if (completion) {
                completion(false, nil, state);
            }
            break;
        case OVER:
            [traces removeAllObjects];
            [trace removeAllObjects];
            if (completion) {
                completion(false, nil, state);
            }
            break;
        case WAIT:
            // do nothing
            break;
        case STOP:
            [trace addObject:[NSNumber valueWithCGPoint:to]];
            [self scanLineFill:qix fillCallback:fillCallback];
            [self buildWall];
            [traces removeAllObjects];
            [trace removeAllObjects];
            if (completion) {
                completion(true, [self isInsidePolygon:boundary points:points], state);
            }
            break;
        default:
            break;
    }
}

- (int (*)[960][640]) map
{
    return &array;
}

int minArea = NSUIntegerMax;
int tempArea = 0;
int minColor = 0;
int currentColorIndex = 0;

- (void) dfsfill
{
    for (int i = 0; i < offsetSize; i++) {
        [self dfs:start.x+offsetX[i] y:start.y + offsetY[i]];
        if (tempArea != 0 && tempArea < minArea) {
            minArea = tempArea;
            minColor = currentColorIndex;
        }
        tempArea = 0;
        currentColorIndex++;
    }
    
    int value = color[minColor];
    
    // fill the space
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            if (array[i][j] == value) {
                array[i][j] = FILL;
            } else if (array[i][j] < 0) {
                array[i][j] = SPACE;
            } else if (array[i][j] == TRACE) {
                array[i][j] = WALL;
            }
        }
    }
}

NSMutableArray *poly1;
NSMutableArray *poly2;

- (void) scanLineFill:(CGPoint) qix fillCallback:(void (^)(int x, int y)) fillCallback
{
    CGPoint traceStart = [[trace objectAtIndex:0] CGPointValue];
    CGPoint traceEnd = [[trace objectAtIndex:[trace count]-1] CGPointValue];
    
    poly1 = [[NSMutableArray alloc] init];
    poly2 = [[NSMutableArray alloc] init];
    
    int startIn = -1;
    int endIn = -1;
    
    for (int i = 0; i < [boundary count]; i++) {
        CGPoint p1 = [[boundary objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[boundary objectAtIndex:(i+1)%[boundary count]] CGPointValue];
        if ([self intersetWithp1:p1 p2:p2 q:traceStart]) {
            startIn = i;
        }
        if ([self intersetWithp1:p1 p2:p2 q:traceEnd]) {
            endIn = i;
        }
    }
    
    if (startIn < endIn) {
        // we find the start point first
        for (id em in trace) {
            [poly1 addObject:em];
            [poly2 addObject:em];
        }
        
        int i = (endIn + 1) % [boundary count];
        
        while (i != startIn + 1) {
            if (![poly1 containsObject:[boundary objectAtIndex:i]]) {
                [poly1 addObject:[boundary objectAtIndex:i]];
            }
            i = (i + 1) % [boundary count];
        }
        
        i = endIn % [boundary count];
        
        while (i != startIn) {
            if (![poly2 containsObject:[boundary objectAtIndex:i]]) {
                [poly2 addObject:[boundary objectAtIndex:i]];
            }
            if (i - 1 == -1) {
                i = [boundary count];
            }
            i = (i-1) % [boundary count];
        }
        
    } else if (startIn > endIn) {
        // we find the end point first
        for (id em in [trace reverseObjectEnumerator]) {
            [poly2 addObject:em];
            [poly1 addObject:em];
        }
        
        int i = (startIn + 1) % [boundary count];
        
        while (i != endIn + 1) {
            if (![poly1 containsObject:[boundary objectAtIndex:i]]) {
                [poly1 addObject:[boundary objectAtIndex:i]];
            }
            i = (i + 1) % [boundary count];
        }
        
        i = startIn % [boundary count];
        
        while (i != endIn) {
            if (![poly2 containsObject:[boundary objectAtIndex:i]]) {
                [poly2 addObject:[boundary objectAtIndex:i]];
            }
            if (i - 1 == -1) {
                i = [boundary count];
            }
            i = abs(i-1) % [boundary count];
        }
    } else if (startIn == endIn && startIn != -1) {
        // the start point and end point are on the same line
        for (id em in trace) {
            [poly1 addObject:em];
            [poly2 addObject:em];
        }
        CGPoint p = [[boundary objectAtIndex:startIn] CGPointValue];
        if ([self distance:p q:traceStart] < [self distance:p q:traceEnd]) {
            // we find the start point first
            int i = (startIn + 1) % [boundary count];
            do {
                if (![poly2 containsObject:[boundary objectAtIndex:i]]) {
                    [poly2 addObject:[boundary objectAtIndex:i]];
                }
                i = (i + 1) % [boundary count];
            } while (i != (startIn + 1) % [boundary count]);
        } else {
            // we find the end point first
            int i = (startIn) % [boundary count];
            do {
                if (![poly2 containsObject:[boundary objectAtIndex:i]]) {
                    [poly2 addObject:[boundary objectAtIndex:i]];
                }
                if (i - 1 == -1) {
                    i = [boundary count];
                }
                i = abs(i-1) % [boundary count];
            } while (i != startIn);
        }
        
    }
    
    // we need to consider the situation that the start point or end point comes or ends at boundary end points.
    [self formatPolygon:poly1];
    [self formatPolygon:poly2]; 
    
//    NSLog(@"Find two Polygon");
//    
//    NSLog(@"Polygon 1");
//    [self logPoly:poly1];
//    
//    NSLog(@"Polygon 2");
//    [self logPoly:poly2];
    
    NSMutableArray *fillArray1 = [[NSMutableArray alloc] init];
    NSMutableArray *fillArray2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempFillArray1 = [[NSMutableArray alloc] init];
    NSMutableArray *tempFillArray2 = [[NSMutableArray alloc] init];
    
    int area1 = 0;
    int area2 = 0;
    bool insidePoly1 = false;
    bool insidePoly2 = false;
    
    // scan line
    for (int h = 0; h < height; h++) {
        
        // find intersection points of polygon 1 at line h
        for (int i = 0; i < [poly1 count]; i++) {
            CGPoint p = [[poly1 objectAtIndex:i] CGPointValue];
            if (p.y == h) {
                [tempFillArray1 addObject:[poly1 objectAtIndex:i]];
            }
        }
        
        // find intersection points of polygon 2 at line h
        for (int i = 0; i < [poly2 count]; i++) {
            CGPoint p = [[poly2 objectAtIndex:i] CGPointValue];
            if (p.y == h) {
                [tempFillArray2 addObject:[poly2 objectAtIndex:i]];
            }
        }
        
        // adjust the filled array for polygon 1
        fillArray1 = [self haoyu:fillArray1 tempFilledSpace:tempFillArray1];
        
        // adjust the filled array for polygon 2
        fillArray2 = [self haoyu:fillArray2 tempFilledSpace:tempFillArray2];
        
        // update area1
        for (int i = 0; i < [fillArray1 count]; i+=2) {
            CGPoint p = [[fillArray1 objectAtIndex:i] CGPointValue];
            CGPoint q = [[fillArray1 objectAtIndex:i+1] CGPointValue];
            area1 += (q.x - p.x);
            if (qix.y == h && (qix.x >= p.x && qix.x <= q.x)) {
                insidePoly1 = true;
            }
        }
        
        // update area2
        for (int i = 0; i < [fillArray2 count]; i += 2) {
            CGPoint p = [[fillArray2 objectAtIndex:i] CGPointValue];
            CGPoint q = [[fillArray2 objectAtIndex:i+1] CGPointValue];
            area2 += (q.x - p.x);
            if (qix.y == h && (qix.x >= p.x && qix.x <= q.x)) {
                insidePoly2 = true;
            }
        }
        
        // clean
        [tempFillArray1 removeAllObjects];
        [tempFillArray2 removeAllObjects];
    }
    
    NSLog(@"area1 %d, area2 %d", area1, area2);
   
    insidePoly1 = [self isInsidePolygon:poly1 point:qix];
    insidePoly2 = [self isInsidePolygon:poly2 point:qix];
   
    if (insidePoly1) {
        boundary = poly1;
        filledArea += area2;
        emptyArea -= area2;
        newlyFilledArea = area2;
        [self fillPolygon:poly2 fillCallback:fillCallback];
    } else if (insidePoly2){
        filledArea += area1;
        emptyArea -= area1;
        newlyFilledArea = area1;
        boundary = poly2;
        [self fillPolygon:poly1  fillCallback:fillCallback];
    } else if (area1 > area2) {
        boundary = poly1;
        newlyFilledArea = area2;
        filledArea += area2;
        emptyArea -= area2;
        [self fillPolygon:poly2  fillCallback:fillCallback];
    } else {
        newlyFilledArea = area1;
        filledArea += area1;
        emptyArea -= area1;
        boundary = poly2;
        [self fillPolygon:poly1  fillCallback:fillCallback];
    }
    
}

- (bool) contains:(NSArray *)poly point:(CGPoint)p
{
    for (int i = 0; i < [poly count]; i++) {
        CGPoint q = [[poly objectAtIndex:i] CGPointValue];
        if (p.x == q.x && p.y == q.y) {
            return true;
        }
    }
    return false;
}

- (void) formatPolygon:(NSMutableArray *) polygon
{
    // remove points that are the same line
    for (int i = 0; i < [polygon count]; i++) {
        CGPoint p = [[polygon objectAtIndex:i] CGPointValue];
        CGPoint q = [[polygon objectAtIndex:(i+1) % [polygon count]] CGPointValue];
        CGPoint r = [[polygon objectAtIndex:(i+2) % [polygon count]] CGPointValue];
        
        if ([self onSameLine:p q:q r:r]) {
            [polygon removeObjectAtIndex:(i+1) %[polygon count]];
            return;
        }
        
    }
    
    // add points to form a polygon
    // find the intersection point
    // add the point that is not on the same line.
    
}

- (bool)isInsidePolygon:(NSArray *)polygon point:(CGPoint)point
{
    int i, j, c = 0;
    for (i = 0, j = [polygon count]-1; i < [polygon count]; j = i++) {
        CGPoint p = [[polygon objectAtIndex:i] CGPointValue];
        CGPoint q = [[polygon objectAtIndex:j] CGPointValue];
        if ( ((p.y>point.y) != (q.y>point.y)) &&
            (point.x < (q.x-p.x) * (point.y-p.y) / (q.y-p.y) + p.x) )
            c = !c;
    }
    return c;
}

- (bool) onSameLine:(CGPoint) p q:(CGPoint)q r:(CGPoint)r
{
    return (p.x == q.x && q.x == r.x) || (p.y == q.y && q.y == r.y);
}

- (NSMutableArray *) haoyu:(NSMutableArray*) filledSpace tempFilledSpace:(NSMutableArray *) temp
{
    NSMutableArray *combine = [[NSMutableArray alloc] init];
    [combine addObjectsFromArray:filledSpace];
    [combine addObjectsFromArray:temp];
    
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    // sort the by x in ascending order
    NSArray *sorted = [combine sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        CGPoint p = [obj1 CGPointValue];
        CGPoint q = [obj2 CGPointValue];
        NSComparisonResult result = [[NSNumber numberWithFloat:p.x] compare:[NSNumber numberWithFloat:q.x]];
        return result;
    }];
    
//    NSLog(@"sorted array %@", sorted);
    
    // remove duplicates
    int i = 0;
    
    while (i < [sorted count]) {

        if (i + 1 < [sorted count]) {
            CGPoint p = [[sorted objectAtIndex:i] CGPointValue];
            CGPoint q = [[sorted objectAtIndex:i+1] CGPointValue];
            // duplicates
            if (p.x == q.x) {
                i += 2;
            } else {
                // add object
                [retVal addObject:[sorted objectAtIndex:i]];
                i += 1;
            }
        } else {
            [retVal addObject:[sorted objectAtIndex:i]];
            i += 1;
        }
    }
    
    return retVal;
}

- (NSArray*) isInsidePolygon:(NSArray *)polygon points:(NSArray *)points
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    if (points == nil) {
        return retVal;
    }
    for (int i = 0; i < [points count]; i++) {
        bool inside = [self isInsidePolygon:polygon point:[[points objectAtIndex:i] CGPointValue]];
        [retVal addObject:[NSNumber numberWithBool:inside]];
    }
    return retVal;
}



- (NSArray *)poly1
{
    return poly1;
}

- (NSArray *)poly2
{
    return poly2;
}

- (void) logPoly:(NSArray *)poly
{
    for (int i = 0; i < [poly count]; i++) {
        CGPoint p = [[poly objectAtIndex:i] CGPointValue];
        NSLog(@"x=%f, y=%f", p.x, p.y);
    }
}

- (void) fillPolygon:(NSArray *)poly fillCallback:(void (^)(int x, int y)) fillCallback
{
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempFillArray = [[NSMutableArray alloc] init];
    
    // scan line
    for (int h = 0; h < height; h++) {
        
        // find intersection points of polygon at line h
        for (int i = 0; i < [poly count]; i++) {
            CGPoint p = [[poly objectAtIndex:i] CGPointValue];
            if (p.y == h) {
                [tempFillArray addObject:[poly objectAtIndex:i]];
            }
        }
        
        // adjust the filled array for polygon
        fillArray = [self haoyu:fillArray tempFilledSpace:tempFillArray];
        
        // update area1
        for (int i = 0; i < [fillArray count]; i+=2) {
            CGPoint p = [[fillArray objectAtIndex:i] CGPointValue];
            CGPoint q = [[fillArray objectAtIndex:i+1] CGPointValue];
            for (int x = p.x; x < q.x; x++) {
                if (array[x][h] == SPACE) {
                    array[x][h] = FILL;
                    if (fillCallback) {
                        fillCallback(x, h);
                    }
                }
            }
        }
        
        // clean
        [tempFillArray removeAllObjects];
    }
}

- (int) filledArea
{
    return filledArea;
}

- (int) emptyArea
{
    return emptyArea;
}

- (int) newlyFilledArea
{
    return newlyFilledArea;
}

- (int) entireArea
{
    return entireArea;
}

// return the distance between two poitns
- (float) distance:(CGPoint)p q:(CGPoint)q
{
    if (p.x == q.x) {
        return fabs(q.y - p.y);
    } else if (p.y == q.y) {
        return fabs(q.x - p.x);
    }
    return -1;
}

// check if q is in the line (p1, p2)
- (bool) intersetWithp1:(CGPoint) p1 p2:(CGPoint) p2 q:(CGPoint) q
{
    int max = -1;
    int min = -1;
    if (p1.x == p2.x) {
        max = p1.y > p2.y ? p1.y : p2.y;
        min = p1.y > p2.y ? p2.y : p1.y;
        
        if (q.x == p1.x && q.y <= max && q.y >= min) {
            return true;
        }
        
    } else if (p1.y == p2.y) {
        max = p1.x > p2.x ? p1.x : p2.x;
        min = p1.x > p2.x ? p2.x : p1.x;
        
        if (q.y == p1.y && q.x <= max && q.x >= min) {
            return true;
        }
    }
    return false;
}

- (void) buildWall
{
    for (int i = 0; i <= width; i++) {
        for (int j = 0; j <= height; j++) {
            if (array[i][j] == TRACE) {
                array[i][j] = WALL;
            } else if (array[i][j] == BOUNDARY) {
                array[i][j] = WALL;
            }
        }
    }
    
    for (int i = 0; i < [boundary count]; i++) {
        CGPoint p = [[boundary objectAtIndex:i] CGPointValue];
        CGPoint q = [[boundary objectAtIndex:(i+1)%[boundary count]] CGPointValue];
        if (p.x == q.x) {
            int y1 = MIN(p.y, q.y);
            int y2 = MAX(p.y, q.y);
            for (int y = y1; y <= y2; y++) {
                array[(int)p.x][y] = BOUNDARY;
            }
        } else if (p.y == q.y) {
            int x1 = MIN(p.x, q.x);
            int x2 = MAX(p.x, q.x);
            for (int x = x1; x <= x2; x++) {
                array[x][(int)p.y] = BOUNDARY;
            }
        }
    }
}

- (void) dfs:(int) x y:(int)y
{
    if (x < 0 || x >= width) {
        return;
    }
    if (y < 0 || y >= height) {
        return;
    }
//    int index = x*width + y;
    if (array[x][y] != SPACE) {
        return;
    }
    tempArea += 1;
    array[x][y] = color[currentColorIndex];
    [self dfs:x-1 y:y];
    [self dfs:x+1 y:y];
    [self dfs:x y:y-1];
    [self dfs:x y:y+1];
}

- (NSArray *) wall
{
    return wall;
}

- (NSArray *) filledSpace
{
    return filledSpace;
}

- (NSArray *) trace
{
    return trace;
}

- (NSArray *) traces
{
    return traces;
}

- (NSArray *) boundary
{
    return boundary;
}

- (bool) isWall:(CGPoint) point
{
    if (point.x < 0 || point.x > width) {
        return false;
    }
    if (point.y < 0 || point.y > height) {
        return false;
    }
    return array[(int)point.x][(int)point.y] == WALL;
}


- (bool) isSpace:(CGPoint) point
{
    if (point.x < 0 || point.x > width) {
        return false;
    }
    if (point.y < 0 || point.y > height) {
        return false;
    }
    return array[(int)point.x][(int)point.y] == SPACE;
}

- (bool) isTrace:(CGPoint) point
{
    if (point.x < 0 || point.x > width) {
        return false;
    }
    if (point.y < 0 || point.y > height) {
        return false;
    }
    return array[(int)point.x][(int)point.y] == TRACE;

}

- (bool) isFill:(CGPoint) point
{
    if (point.x < 0 || point.x > width) {
        return false;
    }
    if (point.y < 0 || point.y > height) {
        return false;
    }
    return array[(int)point.x][(int)point.y] == FILL;
}

- (bool) isBoundary:(CGPoint)point
{
    if (point.x < 0 || point.x > width) {
        return false;
    }
    if (point.y < 0 || point.y > height) {
        return false;
    }
    return array[(int)point.x][(int)point.y] == BOUNDARY;
}

- (void) gameOver
{
    state = OVER;
}

- (bool) isGameOver
{
    return state == OVER;
}

+ (double) distance:(CGPoint) p q:(CGPoint)q
{
    return sqrt((p.x-q.x)*(p.x-q.x) + (p.y - q.y)*(p.y - q.y));
}

- (CGPoint) respawn
{
    if (state == GO || state == START) {
        state = WAIT;
        [trace removeAllObjects];
        [traces removeAllObjects];
        for (int i = 0; i <= width; i++) {
            for (int j = 0; j <= height; j++) {
                if (array[i][j] == TRACE) {
                    array[i][j] = SPACE;
                }
            }
        }
        return start;
    } else {
        return CGPointMake(-1, -1);
    }
}

@end

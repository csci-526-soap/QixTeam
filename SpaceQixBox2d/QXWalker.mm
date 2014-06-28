//
//  QXSimpleMonster.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXWalker.h"
#import "QXMap.h"

@implementation QXWalker

const double rotationDuration = 0.1f;

- (void) config:(QXBaseAttribute *)attribute
{
    QXWalkerAttribute *attr = (QXWalkerAttribute *)attribute;
    
}

- (void) setup:(CCSprite *)sprite Layer:(CCLayer *)layer runDirection:(int) dir runClockwise:(bool)clockwise position:(CGPoint) position userData:(void *) data physicalWorld:(b2World *)world
{
    [super setUp:layer physicalWorld:world];
    type = Walker;
    
    attribute = [[QXWalkerAttribute alloc] init];
    
    _qixMonster = sprite;
    initRotation = sprite.rotation;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInt:dir] forKey:KEY_RUN_DIRECTION];
    [dict setValue:[NSNumber numberWithBool:clockwise] forKey:KEY_CLOCKWISE];
    [dict setValue:[NSNumber numberWithInt:3] forKey:KEY_SPEED];
    
    [attribute build:dict];
    
    isActive = true;
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"simpleMonsterBody.plist"];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(_qixMonster.position.x/PTM_RATIO, _qixMonster.position.y/PTM_RATIO);
    bodyDef.userData = data;
    _qixMonsterBody = world->CreateBody(&bodyDef);
    
    [[GB2ShapeCache sharedShapeCache]
     addFixturesToBody:_qixMonsterBody forShapeName:@"simpleMonsterBody"];
    [_qixMonster setAnchorPoint:[
                                 [GB2ShapeCache sharedShapeCache]
                                 anchorPointForShape:@"simpleMonsterBody"]];
}

- (CGPoint) currentPosition
{
    return [attribute position];
}

- (float) speed
{
    return [attribute speed];
}

- (void) takeAction:(ccTime)delta
{
    CGPoint curPoint = _qixMonster.position;
    
    if (![[QXMap sharedMap] isBoundary:curPoint]) {
        isActive = false;
        [_qixMonster removeFromParentAndCleanup:YES];
//        _world->DestroyBody(_qixMonsterBody);
//        _qixMonsterBody->GetWorld()->DestroyBody(_qixMonsterBody);
        return;
    }
    
    CGFloat tempX = curPoint.x;
    CGFloat tempY = curPoint.y;
    
    int i = 0;
    
    while (i < [attribute speed]) {
        if ([[QXMap sharedMap] isBoundary:CGPointMake(tempX+moveX[[attribute runDirection]], tempY+moveY[[attribute runDirection]])]) {
            tempX += moveX[[attribute runDirection]];
            tempY += moveY[[attribute runDirection]];
            i++;
        } else {
            if ([attribute clockwise]) {
                [self changeDirectionClockwise:tempX y:tempY];
            } else {
                [self changeDirectionAntiClockwise:tempX y:tempY];
            }
        }
    }
    _qixMonster.position = CGPointMake(tempX, tempY);
    [attribute updatePosition:_qixMonster.position];
}

- (void) changeDirectionClockwise:(CGFloat)x y:(CGFloat)y
{
    double rotation = 0.0f;
    switch ([attribute runDirection]) {
        case UP:
            [attribute updateDirection:RIGHT];
            rotation = 90.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[LEFT], y+moveY[LEFT])]){
                [attribute updateDirection:LEFT];
                rotation = -90.0f;
            }
            break;
        case LEFT:
            [attribute updateDirection:UP];
//            rotation = 90.0f;
            rotation = 0.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[DOWN], y+moveY[DOWN])]){
                [attribute updateDirection:DOWN];
//                rotation = -90.0f;
                rotation = 180.0f;
            }
            break;
        case RIGHT:
            [attribute updateDirection:DOWN];
//            rotation = 90.0f;
            rotation = 180.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[UP], y+moveY[UP])]){
                [attribute updateDirection:UP];
//                rotation = -90.0f;
                rotation = 0.0f;
            }
            break;
        case DOWN:
            [attribute updateDirection:LEFT];
//            rotation = 90.0f;
            rotation = -90.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[RIGHT], y+moveY[RIGHT])]){
                [attribute updateDirection:RIGHT];
//                rotation = -90.0f;
                rotation = 90.0f;
            }
            break;
        default:
            break;
    }
//    [_qixMonster runAction:[CCRotateBy actionWithDuration:0.01f angle:rotation]];
    _qixMonster.rotation = initRotation + rotation;
}

- (void) changeDirectionAntiClockwise:(CGFloat)x y:(CGFloat)y
{
    double rotation = 0.0f;
    switch ([attribute runDirection]) {
        case UP:
            [attribute updateDirection:LEFT];
            rotation = -90.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[RIGHT], y+moveY[RIGHT])]){
                [attribute updateDirection:RIGHT];
                rotation = 90.0f;
            }
            break;
        case LEFT:
            [attribute updateDirection:DOWN];
//            rotation = -90.0f;
            rotation = 180.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[UP], y+moveY[UP])]){
                [attribute updateDirection:UP];
//                rotation = 90.0f;
                rotation = 0.0f;
            }
            break;
        case RIGHT:
            [attribute updateDirection:UP];
//            rotation = -90.0f;
            rotation = 0.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[DOWN], y+moveY[DOWN])]){
                [attribute updateDirection:DOWN];
//                rotation = 90.0f;
                rotation = 180.0f;
            }
            break;
        case DOWN:
            [attribute updateDirection:RIGHT];
//            rotation = -90.0f;
            rotation = 90.0f;
            if ([[QXMap sharedMap] isBoundary:CGPointMake(x+moveX[LEFT], y+moveY[LEFT])]){
                [attribute updateDirection:LEFT];
//                rotation = 90.0f;
                rotation = -90.0f;
            }
            break;
        default:
            break;
    }
//    [_qixMonster runAction:[CCRotateBy actionWithDuration:0.01f angle:rotation]];
    _qixMonster.rotation = initRotation + rotation;
}

/********************************/

- (void) explosion
{
    isActive = false;
    [explosion explode:EWALKER layer:_layer position:_qixMonster.position];
    [_qixMonster stopAllActions];
    [_qixMonster removeFromParentAndCleanup:YES];
    //_qixMonsterBody->GetWorld()->DestroyBody(_qixMonsterBody);
}

/********************************/

@end

//
//  QXMonsterConfig.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonsterConfig.h"

@implementation QXMonsterConfig

- (void) setup
{
    guardAttributes = [[NSMutableArray alloc] init];
    walkersAttributes = [[NSMutableArray alloc] init];
    qixAttributes = [[NSMutableArray alloc] init];
    snakeAttributes = [[NSMutableArray alloc] init];
}

- (void) addMonster:(NSDictionary *)attributes
{
    NSString *name = [attributes objectForKey:KEY_NAME];
    if ([name isEqualToString:KEY_WALKER]) {
        QXWalkerAttribute *attr = [[QXWalkerAttribute alloc] init];
        [attr build:attributes];
        [walkersAttributes addObject:attr];
    } else if ([name isEqualToString:KEY_MISSLE_QIX]) {
        QXQixAttribute *attr = [[QXQixAttribute alloc] init];
        [attr build:attributes];
        [qixAttributes addObject:attr];
    } else if ([name isEqualToString:KEY_GUARD]) {
        QXGuardAttribute *attr = [[QXGuardAttribute alloc] init];
        [attr build:attributes];
        [guardAttributes addObject:attr];
    }
}

- (void) loadMosnter:(QXBaseAttribute *)attribute qixType:(enum QXQixType)type
{
    switch (type) {
        case Walker:
            [walkersAttributes addObject:attribute];
            break;
        case Qix:
            [qixAttributes addObject:attribute];
            break;
        case Snake:
            [snakeAttributes addObject:attribute];
            break;
        case Guard:
            [guardAttributes addObject:attribute];
            break;
        default:
            break;
    }
}

- (NSMutableArray *) getMonster:(enum QXQixType) type
{
    switch (type) {
        case Qix:
            return qixAttributes;
        case Walker:
            return walkersAttributes;
        case Guard:
            return guardAttributes;
        case Snake:
            return snakeAttributes;
        default:
            break;
    }
    return nil;
}

- (QXWalkerAttribute *) findWalkerById:(int) Id
{
    for (int i = 0; i < [walkersAttributes count]; i++) {
        QXWalkerAttribute *walker = [walkersAttributes objectAtIndex:i];
        if (walker.ID == Id) {
            return walker;
        }
    }
    return nil;
}

- (QXQixAttribute *) findQixById:(int) Id
{
    for (int i = 0; i < [qixAttributes count]; i++) {
        QXQixAttribute *qixAttr = [qixAttributes objectAtIndex:i];
        if (qixAttr.ID == Id) {
            return qixAttr;
        }
    }
    return nil;
}

- (QXGuardAttribute *) findGuardById:(int) Id
{
    for (int i = 0; i < [guardAttributes count]; i++) {
        QXGuardAttribute *guardAttr = [guardAttributes objectAtIndex:i];
        if (guardAttr.ID == Id) {
            return guardAttr;
        }
    }
    return nil;
}
@end

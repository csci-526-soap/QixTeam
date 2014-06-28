//
//  QXBaseAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_NAME @"name"
#define KEY_ID @"id"
#define KEY_DESCRIPTION @"description"
#define KEY_TAG @"tag"
#define KEY_POSITION @"position"
#define KEY_POSITION_X @"x"
#define KEY_POSITION_Y @"y"
#define KEY_LAYOUT @"layout"
#define KEY_LAYOUT_RELATIVE @"relative"
#define KEY_LAYOUT_ABSOLUTE @"absolute"

enum Layout {LayoutAbsolute, LayoutRelative};

@interface QXBaseAttribute : NSObject {
    NSString *_name;
    NSUInteger _ID;
    CGPoint _position;
    // the tag indicates whether the attribute is qix, player or armor
    NSString *_tag;
    NSString *_description;
    enum Layout _layout;
}

- (void) build:(NSDictionary *)attributeDict;

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description;

- (NSString *) name;

- (NSUInteger) ID;

- (CGPoint) position;

- (void) updatePosition:(CGPoint) position;

- (NSString *) tag;

- (NSString *) description;

- (void) buildPosition:(NSDictionary *)positionDict;
@end

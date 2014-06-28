//
//  QXBaseAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXBaseAttribute.h"

@implementation QXBaseAttribute

- (void) build:(NSDictionary *)attributeDict
{
    for (id key in attributeDict) {
        if ([key isEqualToString:KEY_DESCRIPTION]) {
            _description = [attributeDict objectForKey:key];
        } else if ([key isEqualToString:KEY_ID]) {
            _ID = [[attributeDict objectForKey:key] integerValue];
        } else if ([key isEqualToString:KEY_LAYOUT]) {
            NSString *layout = [attributeDict objectForKey:key];
            if ([layout isEqualToString:KEY_LAYOUT_ABSOLUTE]) {
                _layout = LayoutAbsolute;
            } else if ([layout isEqualToString:KEY_LAYOUT_RELATIVE]) {
                _layout = LayoutRelative;
            }
        } else if ([key isEqualToString:KEY_NAME]) {
            _name = [attributeDict objectForKey:key];
        } else if ([key isEqualToString:KEY_TAG]) {
            _tag = [attributeDict objectForKey:key];
        }
    }
}

- (void) buildPosition:(NSDictionary *)positionDict
{
    CGFloat x = 0;
    CGFloat y = 0;
    for (id key in positionDict) {
        if ([key isEqualToString:KEY_LAYOUT]) {
            NSString *layout = [positionDict objectForKey:key];
            if ([layout isEqualToString:KEY_LAYOUT_ABSOLUTE]) {
                _layout = LayoutAbsolute;
            } else if ([layout isEqualToString:KEY_LAYOUT_RELATIVE]) {
                _layout = LayoutRelative;
            }
        } else if ([key isEqualToString:KEY_POSITION_X]) {
            x = [[positionDict objectForKey:key] floatValue];
        } else if ([key isEqualToString:KEY_POSITION_Y]) {
            y = [[positionDict objectForKey:key] floatValue];
        }
    }
    _position = CGPointMake(x, y);
}

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description;
{
    _name = name;
    _ID = ID;
    _position = position;
    _tag = tag;
    _description = description;
}

- (NSString *) name
{
    return _name;
}

- (NSUInteger) ID
{
    return _ID;
}

- (CGPoint) position
{
    return _position;
}

- (void) updatePosition:(CGPoint) position
{
    _position = position;
}

- (NSString *) tag
{
    return _tag;
}

- (NSString *) description
{
    return _description;
}
@end

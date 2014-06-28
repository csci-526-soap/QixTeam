//
//  QXMonsterAttribute.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/9/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMonsterAttribute.h"

@implementation QXMonsterAttribute

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description qixType:(enum QXQixType)qixType
{
    [super setup:name Id:ID position:position tag:tag description:description];
    _qixType = qixType;
}

- (void) setQixType:(enum QXQixType)qixType
{
    _qixType = qixType;
}

- (enum QXQixType)qixType
{
    return _qixType;
}
@end

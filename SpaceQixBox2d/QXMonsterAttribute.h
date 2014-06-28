//
//  QXMonsterAttribute.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/9/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXBaseAttribute.h"
#import "QXMonster.h"

@interface QXMonsterAttribute : QXBaseAttribute {
    enum QXQixType _qixType;
}

- (void) setup:(NSString *)name Id:(NSUInteger)ID position:(CGPoint)position tag:(NSString *)tag description:(NSString *)description qixType:(enum QXQixType)qixType;

- (void) setQixType:(enum QXQixType)qixType;

- (enum QXQixType)qixType;

@end

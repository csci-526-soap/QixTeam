//
//  QXObject.h
//  SpaceQix
//
//  Created by Haoyu Huang on 4/5/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXBaseAttribute.h"

#define PTM_RATIO 32.0

@interface QXObject : NSObject {
    NSString *tag;
}

- (void) config:(QXBaseAttribute *)attribute;

@end

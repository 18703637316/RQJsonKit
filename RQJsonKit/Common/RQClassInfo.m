//
//  RQClassInfo.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQClassInfo.h"

@implementation RQClassInfo

@synthesize propertyCache = _propertyCache;

- (NSMutableArray *)propertyCache
{
    if(!_propertyCache) {
        _propertyCache = [NSMutableArray array];
    }
    return _propertyCache;
}

@end

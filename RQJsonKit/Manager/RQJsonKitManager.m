//
//  RQJsonKitManager.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQJsonKitManager.h"

@implementation RQJsonKitManager

static id _instance = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _cache = [RQJsonKitCache sharedCache];
        _transformOperation = [RQTransformOperation sharedOperation];
    }
    return self;
    
}

- (id)modelWithJson:(id)json clazz:(Class)clazz {
    
    if (!json) return nil;
    if (!clazz) return nil;
    //1 clazz 转化为对应的属性信息
    RQClassInfo *classInfo = [self.cache classInfoFromCache:clazz];
    //2 属性信息和字典映射对应值
    return [self.transformOperation modelWithJson:json classInfo:classInfo];
    
}

@end

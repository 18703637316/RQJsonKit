//
//  RQJsonKitCache.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/11.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQJsonKitCache.h"
#import <objc/runtime.h>
#import "NSObject+RQJsonKit.h"

@interface RQJsonKitCache ()

@property (nonatomic, strong) NSMutableDictionary *classCache;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation RQJsonKitCache

static id _instance;
+ (instancetype)sharedCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self == [super init]) {
        _classCache = [NSMutableDictionary dictionary];
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (RQClassInfo *)classInfoFromCache:(Class)clazz {
    if (clazz == [NSObject class]) return nil;
    [self lock];
    RQClassInfo *classInfo = [_classCache objectForKey:NSStringFromClass(clazz)];
    [self unLock];
    if (!classInfo) {
        classInfo = [[RQClassInfo alloc] init];
        Class superClazz = class_getSuperclass(clazz);
        RQClassInfo *superClassInfo = [self classInfoFromCache:superClazz];
        classInfo.superClassInfo = superClassInfo;
        classInfo.name = @(object_getClassName(clazz));
        classInfo.clazz = clazz;
        classInfo.superClazz = superClazz;
        
        //存放当前类 父类的所有属性信息
        NSMutableArray *tmpPropertys = [NSMutableArray array];
        
        
        NSDictionary *classInArrayDict = nil;
        if([clazz respondsToSelector:@selector(rq_objectClassInArray)]) {
            classInArrayDict = [clazz rq_objectClassInArray];
        }
        
        NSDictionary *mappingDict = nil;
        unsigned int outCount = 0;
        objc_property_t *propertys = class_copyPropertyList(clazz, &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = propertys[i];
            RQPropertyInfo *propertyInfo = [RQPropertyInfo propertyWithProperty_t:property];
            [tmpPropertys addObject:propertyInfo];
            [classInfo.propertyCache addObject:propertyInfo];
        }
        
        for(RQPropertyInfo *propertyInfo in tmpPropertys) {
            [propertyInfo setupkeysMappingWithMappingDict:mappingDict];
            [propertyInfo setupClassInArrayWithClassInArrayDict:classInArrayDict];
        }
        
        if (propertys) {
            free(propertys);
        }
        
        [self lock];
        _classCache[NSStringFromClass(clazz)] = classInfo;
        [self unLock];
    }
    return classInfo;
}

- (void)lock {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)unLock {
    dispatch_semaphore_signal(_semaphore);
}


@end

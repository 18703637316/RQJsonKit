//
//  NSObject+RQJsonKit.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "NSObject+RQJsonKit.h"
#import "RQJsonKitManager.h"

@implementation NSObject (RQJsonKit)

+ (instancetype)rq_modelWithJson:(id)json {
    return [[RQJsonKitManager sharedManager] modelWithJson:json clazz:self];
}

@end

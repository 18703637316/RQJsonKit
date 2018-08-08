//
//  RQTransformOperation.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQTransformOperation.h"
#import "NSString+RQJsonKit.h"
#import <objc/message.h>
#import "RQJsonKitManager.h"
#import "RQMappingKey.h"

@implementation RQTransformOperation

static id _instance;

+ (instancetype)sharedOperation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//step1 json or data to dic;
- (id)modelWithJson:(id)json classInfo:(RQClassInfo *)classInfo
{
    if(!json || !classInfo) return nil;
    if([json isKindOfClass:[NSString class]]) {
        json = [RQJsonKitTool objectWithJsonString:json];
    } else if([json isKindOfClass:[NSData class]]) {
        json = [RQJsonKitTool objectWithData:json];
    }
    if(![json isKindOfClass:[NSDictionary class]]) return nil;
    id model = [[classInfo.clazz alloc] init];
    for(RQPropertyInfo *propertyInfo in classInfo.propertyCache) {
        id value = nil;
        for(NSArray *array in propertyInfo.mappingKeyPath) {
            value = json;
            for(RQMappingKey *mappingKey in array) {
                value = [mappingKey valueWithObject:value];
            }
            if(value) break;
        }
        if(!value || value == [NSNull null]) continue;
        @try {
            RQPropertyTypeInfo *propertyType = propertyInfo.type;
            Class typeClazz = propertyType.typeClass;
            Class arrayClazz = propertyInfo.arrayClazz;
            if (typeClazz == [NSMutableArray class] && [value isKindOfClass:[NSArray class]]) {
                value = [NSMutableArray arrayWithArray:value];
            } else if (typeClazz == [NSMutableDictionary class] && [value isKindOfClass:[NSDictionary class]]) {
                value = [NSMutableDictionary dictionaryWithDictionary:value];
            } else if (typeClazz == [NSMutableString class] && [value isKindOfClass:[NSString class]]) {
                value = [NSMutableString stringWithString:value];
            } else if (typeClazz == [NSMutableData class] && [value isKindOfClass:[NSData class]]) {
                value = [NSMutableData dataWithData:value];
            }
            if(!propertyType.isFromFoundation && typeClazz) { //先处理对象类型，此时是自定义对象类型
                RQClassInfo *classInfo = [[RQJsonKitManager sharedManager].cache classInfoFromCache:typeClazz];
                value = [self modelWithJson:value classInfo:classInfo];
            } else if(typeClazz && arrayClazz) { //数组类型
                if([value isKindOfClass:[NSArray class]]) {
                    if(!propertyInfo.isArrayClazzFromFoundation) {
                        RQClassInfo *classInfo = [[RQJsonKitManager sharedManager].cache classInfoFromCache:arrayClazz];
                        value = [self modelArrayWithJsonArray:value classInfo:classInfo];
                    }
                }
            } else { //处理一些基本数据类型和NSString之间的转换
                if(typeClazz == [NSString class]) {
                    if([value isKindOfClass:[NSNumber class]]) { //NSNumber->NSString
                        value = [RQJsonKitTool convertNumberToString:value];
                    } else if([value isKindOfClass:[NSURL class]]) { //NSURL->NSString
                        value = [value absoluteString];
                    }
                } else if([value isKindOfClass:[NSString class]]) {
                    if(typeClazz == [NSURL class]) { //NSString->NSURL
                        value = [(NSString *)value rq_url];
                    } else if(propertyType.isNumberType && propertyInfo.assigmnetType == RQAssignmentTypeMessage) { //NSString->NSNumber
                        NSNumber *num = [RQJsonKitTool createNumberWithObject:value];
                        num = [RQJsonKitTool convertNumberToNumber:num];
                        [RQJsonKitTool setupNumberTypeWithModel:model number:num propertyInfo:propertyInfo];
                        continue;
                    }
                } else if([value isKindOfClass:[NSNumber class]]) {
                    if(propertyType.isNumberType && propertyInfo.assigmnetType == RQAssignmentTypeMessage) {
                        NSNumber *num = [RQJsonKitTool convertNumberToNumber:value];
                        [RQJsonKitTool setupNumberTypeWithModel:model number:num propertyInfo:propertyInfo];
                        continue;
                        
                    }
                }
                
            }
            //类型校验
            if(typeClazz && ![value isKindOfClass:typeClazz]) value = nil;
            if(!value) continue;
            if(propertyInfo.assigmnetType == RQAssignmentTypeMessage) {
                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, propertyInfo.setter, (id)value);
            } else {
                [model setValue:value forKey:propertyInfo.name];
            }
        } @catch (NSException *exception) {
            
        }
    }
    return model;
}

- (NSArray *)modelArrayWithJsonArray:(id)json classInfo:(RQClassInfo *)classInfo
{
    if([json isKindOfClass:[NSString class]]) {
        json = [RQJsonKitTool objectWithJsonString:json];
    } else if([json isKindOfClass:[NSData class]]) {
        json = [RQJsonKitTool objectWithData:json];
    }
    if(![json isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *tmpArray = [NSMutableArray array];
    for(id object in json) {
        if([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [self modelArrayWithJsonArray:object classInfo:classInfo];
            if(array.count) {
                [tmpArray addObjectsFromArray:array];
            }
        } else if([object isKindOfClass:[NSDictionary class]]) {
            id model = [self modelWithJson:object classInfo:classInfo];
            if(model) {
                [tmpArray addObject:model];
            }
        }
    }
    return tmpArray;
}

@end

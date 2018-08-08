//
//  RQPropertyInfo.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/19.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "RQPropertyTypeInfo.h"

@interface RQPropertyInfo : NSObject

/**
 *  属性
 */
@property (nonatomic, assign) objc_property_t property_t;

/**
 *  属性名字
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  属性的值
 */
@property (nonatomic, strong) id value;

/**
 *  属性类型
 */
@property (nonatomic, strong, readonly) RQPropertyTypeInfo *type;

/**
 *  setter方法
 */
@property (nonatomic, assign,readonly) SEL setter;

/**
 *  getter方法
 */
@property (nonatomic, assign, readonly) SEL getter;

/**
 *  赋值的方式，如果属性是readOnly，采用KVC赋值，否则采用runtime的消息机制
 */
@property (nonatomic, assign, readonly) RQAssignmentType assigmnetType;

/**
 *  保存着模型的这个属性对应着字典中的key，可以是多级映射
 */
@property (nonatomic, strong) NSMutableArray *mappingKeyPath;

/**
 *  数组中的类，可能为空
 */
@property (nonatomic, assign, readonly) Class arrayClazz;

/**
 类型是否来自于Foundation框架，比如NSString、NSArray
 */
@property (nonatomic, readonly, getter = isArrayClazzFromFoundation) BOOL arrayClazzFromFoundation;


- (void)setupkeysMappingWithMappingDict:(NSDictionary *)mappingDict;

- (void)setupClassInArrayWithClassInArrayDict:(NSDictionary *)classInArrayDict;

+ (instancetype)propertyWithProperty_t:(objc_property_t)property_t;


@end

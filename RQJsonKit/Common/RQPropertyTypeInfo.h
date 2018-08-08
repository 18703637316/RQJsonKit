//
//  RQPropertyTypeInfo.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/27.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQJsonKitConst.h"

@interface RQPropertyTypeInfo : NSObject

/**
 类型标识符
 */
@property (nonatomic, copy) NSString *typeCode;

/**
 是否为基本数字类型：int、float等
 */
@property (nonatomic, readonly, getter = isNumberType) BOOL numberType;

/**
 *  如果是基本数字类型，是否为整形
 */
@property (nonatomic, readonly, getter = isIntegerType) BOOL integerType;

/**
 对象类型（如果是基本数据类型，此值为nil）
 */
@property (nonatomic, assign, readonly) Class typeClass;

/**
 类型是否来自于Foundation框架，比如NSString、NSArray
 */
@property (nonatomic, readonly, getter = isFromFoundation) BOOL fromFoundation;

/**
 *  类型的枚举
 */
@property (nonatomic, assign,readonly) RQEncodingType encodingType;

+ (instancetype)rq_propertyTypeWithTypeCode:(NSString *)typeCode;

@end

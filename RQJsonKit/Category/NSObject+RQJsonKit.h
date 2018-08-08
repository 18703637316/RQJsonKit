//
//  NSObject+RQJsonKit.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RQJsonKitProtocol <NSObject>
@optional

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)rq_objectClassInArray;

@end

@interface NSObject (RQJsonKit) <RQJsonKitProtocol>

/**
 *  通过字典来创建一个模型
 *
 *  @param json 字典数据，可以是dict，json，NSData
 *
 *  @return 返回一个创建好的模型
 */
+ (instancetype)rq_modelWithJson:(id)json;

@end

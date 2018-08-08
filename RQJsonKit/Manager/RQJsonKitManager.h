//
//  RQJsonKitManager.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQJsonKitCache.h"
#import "RQTransformOperation.h"

@interface RQJsonKitManager : NSObject

/**
 *  缓存对象
 */
@property (nonatomic, strong, readonly) RQJsonKitCache *cache;

/**
 *  单例方法
 *
 *  @return 对象本身
 */
+ (instancetype)sharedManager;

/**
 *  转换对象
 */
@property (nonatomic, strong, readonly) RQTransformOperation *transformOperation;

/**
 *  通过字典来创建一个模型
 *
 *  @param json 字典
 *  @param clazz 类
 *  @return 返回一个模型对象
 */
- (id)modelWithJson:(id)json clazz:(Class)clazz;



@end

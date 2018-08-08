//
//  RQJsonKitCache.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/11.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQPropertyInfo.h"
#import "RQClassInfo.h"

@interface RQJsonKitCache : NSObject

/**
 *  单例方法
 *
 *  @return 对象本身
 */
+ (instancetype)sharedCache;

/**
 *  提供给外部从缓存中获取RQClassInfo的接口
 *
 *  @param clazz 要获取的类类型，会用来作为字典的key
 *
 *  @return 返回一个RQClassInfo对象
 */
- (RQClassInfo *)classInfoFromCache:(Class)clazz;


@end

//
//  RQClassInfo.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RQClassInfo : NSObject

/**
 *  类
 */
@property (nonatomic, assign) Class clazz;

/**
 *  父类
 */
@property (nonatomic, assign) Class superClazz;

/**
 *  父类的信息
 */
@property (nonatomic, assign) RQClassInfo *superClassInfo;

/**
 * 类名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  类中属性的缓存数组，里面装着RQPropertyInfo对象
 */
@property (nonatomic, strong) NSMutableArray *propertyCache;

@end

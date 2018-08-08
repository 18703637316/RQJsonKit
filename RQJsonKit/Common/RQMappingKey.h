//
//  RQMappingKey.h
//  RQJsonKit
//
//  Created by renqiang on 2018/1/8.
//  Copyright © 2018年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQJsonKitConst.h"

@interface RQMappingKey : NSObject

/**
 *  映射key的类型
 */
@property (nonatomic, copy) NSString *name;
/**
 *  映射key的类型
 */
@property (nonatomic, assign) RQMappingKeyType type;
/**
 *  从字典中取值
 *
 *  @param object 可能是数组，也可能是字典
 *
 *  @return 所对应的值
 */
- (id)valueWithObject:(id)object;

@end

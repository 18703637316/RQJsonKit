//
//  RQTransformOperation.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQClassInfo.h"
#import "RQJsonKitTool.h"

@interface RQTransformOperation : NSObject

/**
 *  单例方法
 *
 *  @return 对象本身
 */
+ (instancetype)sharedOperation;

- (id)modelWithJson:(id)json classInfo:(RQClassInfo *)classInfo;

@end

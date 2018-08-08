//
//  NSString+RQJsonKit.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQJsonKitConst.h"

@interface NSString (RQJsonKit)

/**
 *  解析映射的key
 *
 *  @param block block
 */
- (void)rq_enumerateMappingKeyUsingBlock:(void (^)(RQMappingKeyType type,NSString *name))block;

- (NSString *)rq_createSetter;

- (NSURL *)rq_url;

@end

//
//  RQJsonKitTool.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RQJsonKitConst.h"
#import "RQPropertyInfo.h"

@interface RQJsonKitTool : NSObject

+ (id)objectWithJsonString:(NSString *)json;

+ (id)objectWithData:(NSData *)data;

+ (RQEncodingType)encodingGetType:(const char *)typeEncoding;

+ (BOOL)encodingTypeIsNumberType:(RQEncodingType)type;

+ (BOOL)classFromFoundation:(Class)clazz;

+ (NSNumber *)convertNumberToNumber:(NSNumber *)number;

+ (NSString *)convertNumberToString:(NSNumber *)number;

+ (NSNumber *)createNumberWithObject:(id)value;

+ (void)setupNumberTypeWithModel:(id)model number:(NSNumber *)num propertyInfo:(RQPropertyInfo *)propertyInfo;
@end

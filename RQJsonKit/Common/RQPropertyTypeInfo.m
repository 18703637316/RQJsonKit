//
//  RQPropertyTypeInfo.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/27.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQPropertyTypeInfo.h"
#import "RQJsonKitTool.h"

@implementation RQPropertyTypeInfo

+ (instancetype)rq_propertyTypeWithTypeCode:(NSString *)typeCode {
    RQPropertyTypeInfo *typeInfo = [[self alloc] init];
    typeInfo.typeCode  = typeCode;
    return typeInfo;
}

- (void)setTypeCode:(NSString *)typeCode {
    _typeCode = typeCode;
    _encodingType = [RQJsonKitTool encodingGetType:typeCode.UTF8String];
    _numberType = [RQJsonKitTool encodingTypeIsNumberType:_encodingType];
    if(typeCode.length > 3 && [typeCode hasPrefix:@"@\""]) {
        _typeCode = [typeCode substringWithRange:NSMakeRange(2, typeCode.length - 3)];
        _typeClass = NSClassFromString(_typeCode);
        _fromFoundation = [RQJsonKitTool classFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
    }
}


@end

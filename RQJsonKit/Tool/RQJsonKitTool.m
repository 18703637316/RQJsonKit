//
//  RQJsonKitTool.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQJsonKitTool.h"
#import <objc/message.h>

@implementation RQJsonKitTool

static NSSet *_set;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _set = [NSSet setWithObjects: [NSURL class],
                [NSDate class],
                [NSValue class],
                [NSData class],
                [NSError class],
                [NSArray class],
                [NSDictionary class],
                [NSString class],
                [NSNumber class],
                [NSAttributedString class], nil];
    });
}

+ (id)objectWithJsonString:(NSString *)json
{
    if(!json) return nil;
    return [self objectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (id)objectWithData:(NSData *)data
{
    if(!data) return nil;
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(!error) return jsonDict;
    return nil;
}

+ (RQEncodingType)encodingGetType:(const char *)typeEncoding {
    char *type = (char *)typeEncoding;
    if (!type) return RQEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return RQEncodingTypeUnknown;
    switch (*type) {
        case 'v': return RQEncodingTypeVoid;
        case 'B': return RQEncodingTypeBool;
        case 'c': return RQEncodingTypeInt8;
        case 'C': return RQEncodingTypeUInt8;
        case 's': return RQEncodingTypeInt16;
        case 'S': return RQEncodingTypeUInt16;
        case 'i': return RQEncodingTypeInt32;
        case 'I': return RQEncodingTypeUInt32;
        case 'l': return RQEncodingTypeInt32;
        case 'L': return RQEncodingTypeUInt32;
        case 'q': return RQEncodingTypeInt64;
        case 'Q': return RQEncodingTypeUInt64;
        case 'f': return RQEncodingTypeFloat;
        case 'd': return RQEncodingTypeDouble;
        case 'D': return RQEncodingTypeLongDouble;
        case '#': return RQEncodingTypeClass;
        case ':': return RQEncodingTypeSEL;
        case '*': return RQEncodingTypeCString;
        case '^': return RQEncodingTypePointer;
        case '[': return RQEncodingTypeCArray;
        case '(': return RQEncodingTypeUnion;
        case '{': return RQEncodingTypeStruct;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return RQEncodingTypeBlock;
            else return RQEncodingTypeObject;
        }
        default: return RQEncodingTypeUnknown;
    }
}

+ (BOOL)encodingTypeIsNumberType:(RQEncodingType)type
{
    switch (type) {
        case RQEncodingTypeBool:
        case RQEncodingTypeInt8:
        case RQEncodingTypeUInt8:
        case RQEncodingTypeInt16:
        case RQEncodingTypeUInt16:
        case RQEncodingTypeInt32:
        case RQEncodingTypeUInt32:
        case RQEncodingTypeInt64:
        case RQEncodingTypeUInt64:
        case RQEncodingTypeFloat:
        case RQEncodingTypeDouble:
        case RQEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

+ (BOOL)classFromFoundation:(Class)clazz
{
    if(clazz == [NSObject class]) return YES;
    __block BOOL FromFoundation = NO;
    [_set enumerateObjectsUsingBlock:^(id  obj, BOOL * stop) {
        if([clazz isSubclassOfClass:obj]) {
            FromFoundation = YES;
            *stop = YES;
        }
    }];
    return FromFoundation;
}

+ (NSNumber *)convertNumberToNumber:(NSNumber *)number
{
    if(!number) return nil;
    double conversionValue = [number doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decNumber;
}

+ (NSString *)convertNumberToString:(NSNumber *)number
{
    if(!number) return nil;
    double conversionValue = [number doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

#pragma mark - C函数工具处理方法
+ (NSNumber *)createNumberWithObject:(id)value
{
    static NSCharacterSet *dot;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
        dic = @{@"TRUE" :   @(YES),
                @"True" :   @(YES),
                @"true" :   @(YES),
                @"FALSE" :  @(NO),
                @"False" :  @(NO),
                @"false" :  @(NO),
                @"YES" :    @(YES),
                @"Yes" :    @(YES),
                @"yes" :    @(YES),
                @"NO" :     @(NO),
                @"No" :     @(NO),
                @"no" :     @(NO),
                @"NIL" :    (id)kCFNull,
                @"Nil" :    (id)kCFNull,
                @"nil" :    (id)kCFNull,
                @"NULL" :   (id)kCFNull,
                @"Null" :   (id)kCFNull,
                @"null" :   (id)kCFNull,
                @"(NULL)" : (id)kCFNull,
                @"(Null)" : (id)kCFNull,
                @"(null)" : (id)kCFNull,
                @"<NULL>" : (id)kCFNull,
                @"<Null>" : (id)kCFNull,
                @"<null>" : (id)kCFNull
                };
    });
    
    if (!value || value == (id)kCFNull) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSNumber *num = dic[value];
        if (num) {
            if (num == (id)kCFNull) return nil;
            return num;
        }
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            double num = atof(cstring);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        } else {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            return @(atoll(cstring));
        }
    }
    return nil;
}

+ (void)setupNumberTypeWithModel:(id)model number:(NSNumber *)num propertyInfo:(RQPropertyInfo *)propertyInfo
{
    if(!model || !propertyInfo || !num) return;
    RQEncodingType type = propertyInfo.type.encodingType;
    switch (type) {
        case RQEncodingTypeBool:
        {
            ((void (*)(id, SEL, bool))(void *) objc_msgSend)((id)model, propertyInfo.setter, num.boolValue);
        }
            break;
        case RQEncodingTypeInt8:
        {
            ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)((id)model,propertyInfo.setter, (int8_t)num.charValue);
        }
            break;
        case RQEncodingTypeUInt8:
        {
            ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (uint8_t)num.unsignedCharValue);
        }
            break;
        case RQEncodingTypeInt16:
        {
            ((void (*)(id, SEL, int16_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (int16_t)num.shortValue);
        }
            break;
        case RQEncodingTypeUInt16:
        {
            ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)((id)model,propertyInfo.setter, (uint16_t)num.unsignedShortValue);
        }
            break;
        case RQEncodingTypeInt32:
        {
            ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (int32_t)num.intValue);
        }
        case RQEncodingTypeUInt32:
        {
            ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (uint32_t)num.unsignedIntValue);
        }
            break;
        case RQEncodingTypeInt64:
        {
            if ([num isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (int64_t)num.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (uint64_t)num.longLongValue);
            }
        }
            break;
        case RQEncodingTypeUInt64:
        {
            if ([num isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (int64_t)num.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)model, propertyInfo.setter, (uint64_t)num.unsignedLongLongValue);
            }
        }
            break;
        case RQEncodingTypeFloat:
        {
            float f = num.floatValue;
            if (isnan(f) || isinf(f)) f = 0;
            ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)model, propertyInfo.setter, f);
        }
            break;
        case RQEncodingTypeDouble:
        {
            double d = num.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)model, propertyInfo.setter, d);
        }
            break;
        case RQEncodingTypeLongDouble:
        {
            long double d = num.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id, SEL, long double))(void *) objc_msgSend)((id)model, propertyInfo.setter, (long double)d);
        }
            break;
        default:
        {
            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, propertyInfo.setter, num);
        }
            break;
    }
}

@end

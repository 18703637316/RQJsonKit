//
//  RQPropertyInfo.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/19.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQPropertyInfo.h"
#import "RQMappingKey.h"
#import "NSString+RQJsonKit.h"
#import "RQJsonKitTool.h"

@implementation RQPropertyInfo

#pragma mark 懒加载
- (NSMutableArray *)mappingKeyPath
{
    if(_mappingKeyPath == nil) {
        _mappingKeyPath = [NSMutableArray array];
    }
    return _mappingKeyPath;
}

#pragma mark 初始化方法

+ (instancetype)propertyWithProperty_t:(objc_property_t)property_t
{
    RQPropertyInfo *propertyInfo = [[self alloc] init];
    propertyInfo.property_t = property_t;
    return propertyInfo;
}

#pragma mark 重写setter

- (void)setProperty_t:(objc_property_t)property_t {
    
    _property_t = property_t;
    _name = [NSString stringWithCString:property_getName(property_t) encoding:NSUTF8StringEncoding];
    if(!_name.length || [_name isEqualToString:@"hash"] || [_name isEqualToString:@"superclass"] || [_name isEqualToString:@"description"] || [_name isEqualToString:@"debugDescription"]) {
        _name = nil;
        return;
    }
    
    unsigned int outCount = 0;
    objc_property_attribute_t *attrs = property_copyAttributeList(property_t, &outCount);
    for(int i = 0;i < outCount;i++) {
        objc_property_attribute_t attr = attrs[i];
        NSLog(@"attribute.name = %s,attribute.value = %s",attr.name,attr.value);
        switch (attr.name[0]) {
            //属性类型type
            case 'T':
            {
                if(attr.value) {
                    _type = [RQPropertyTypeInfo rq_propertyTypeWithTypeCode:@(attr.value)];
                }
            }
                break;
            //getter
            case 'G':
            {
                if (attr.value) {
                    _getter = NSSelectorFromString(@(attr.value));
                }
            }
                break;
            //setter
            case 'S':
            {
                if (attr.value) {
                    _setter = NSSelectorFromString(@(attr.value));
                }
            }
                break;
            //readonly
            case 'R':
            {
                _assigmnetType = RQAssignmentTypeKVC;
            }
                break;
        }
    }
    if(attrs) {
        free(attrs);
    }
    if(!_setter) {
        _setter = NSSelectorFromString([_name rq_createSetter]);
    }
    if(!_getter) {
        _getter = NSSelectorFromString(_name);
    }
}

- (void)setupkeysMappingWithMappingDict:(NSDictionary *)mappingDict
{
    if(!self.name.length) return;
    id mappingKey = mappingDict[self.name];
    if(!mappingKey) mappingKey = self.name;
    NSMutableArray *tmpArray = [NSMutableArray array];
    if([mappingKey isKindOfClass:[NSString class]]) {
        [mappingKey rq_enumerateMappingKeyUsingBlock:^(RQMappingKeyType type, NSString *name) {
            RQMappingKey *mappingKey = [[RQMappingKey alloc] init];
            mappingKey.type = type;
            mappingKey.name = name;
            [tmpArray addObject:mappingKey];
        }];
        [self.mappingKeyPath addObject:tmpArray];
    }

}

- (void)setupClassInArrayWithClassInArrayDict:(NSDictionary *)classInArrayDict
{
    if(!self.name.length) return;
    id clazz = classInArrayDict[self.name];
    if(!clazz) return;
    if([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    _arrayClazz = clazz;
    _arrayClazzFromFoundation = [RQJsonKitTool classFromFoundation:clazz];
}

@end

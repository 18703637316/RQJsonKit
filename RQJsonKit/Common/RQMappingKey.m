//
//  RQMappingKey.m
//  RQJsonKit
//
//  Created by renqiang on 2018/1/8.
//  Copyright © 2018年 renqiang. All rights reserved.
//

#import "RQMappingKey.h"

@implementation RQMappingKey

- (id)valueWithObject:(id)object
{
    if(!object || !self.name) return nil;
    if(self.type == RQMappingKeyTypeDictionary && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        return dict[self.name];
    } else if(self.type == RQMappingKeyTypeArray && [object isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)object;
        return array[self.name.intValue];
    }
    return nil;
}

@end

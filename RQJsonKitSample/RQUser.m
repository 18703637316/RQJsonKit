//
//  RQUser.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "RQUser.h"

@implementation RQUser

@end

@implementation RQStatus

@end

@implementation RQAd

@end

@implementation RQStatusResult
+ (NSDictionary *)rq_objectClassInArray
{
    return @{
             @"statuses" : @"RQStatus",
             @"ads" : @"RQAd"
             };
}
@end

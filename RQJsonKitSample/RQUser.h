//
//  RQUser.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/8.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SexMale,
    SexFemale
} Sex;

@interface RQUser : NSObject

/** 名称 */
@property (copy, nonatomic) NSString *name;
/** 头像 */
@property (copy, nonatomic) NSString *icon;
/** 年龄 */
@property (assign, nonatomic) unsigned int age;
/** 身高 */
@property (strong, nonatomic) NSNumber *height;
///** 财富 */
@property (strong, nonatomic) NSNumber *money;
/** 性别 */
@property (assign, nonatomic) Sex sex;
/** 同性恋 */
@property (assign, nonatomic) BOOL gay;

@end

@interface RQStatus : NSObject

@property (nonatomic, assign) NSInteger staID;
/** 微博文本内容 */
@property (copy, nonatomic) NSString *text;
/** 微博作者 */
@property (strong, nonatomic) RQUser *user;
/** 转发的微博 */
@property (strong, nonatomic) RQStatus *retweetedStatus;

@end

@interface RQAd : NSObject
/** 广告图片 */
@property (copy, nonatomic) NSString *image;
/** 广告url */
@property (strong, nonatomic) NSURL *url;
@end

@interface RQStatusResult : NSObject
/** 存放着某一页微博数据（里面都是Status模型） */
@property (strong, nonatomic) NSMutableArray *statuses;
/** 存放着一堆的广告数据（里面都是RQAd模型） */
@property (strong, nonatomic) NSArray *ads;
/** 总数 */
@property (strong, nonatomic) NSNumber *totalNumber;
/** 上一页的游标 */
@property (assign, nonatomic) long long previousCursor;
/** 下一页的游标 */
@property (assign, nonatomic) long long nextCursor;
@end


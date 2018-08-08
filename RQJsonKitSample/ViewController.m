//
//  ViewController.m
//  RQJsonKitSample
//
//  Created by renqiang on 2018/8/8.
//  Copyright © 2018年 renqiangqiang. All rights reserved.
//

#import "ViewController.h"
#import "RQUser.h"
#import "NSObject+RQJsonKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self keyValues2object3];
}

//简单字典转模型
- (void)keyValuesToObject {
    
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"name" : @"Jack",
                           @"icon" : @"lufy.png",
                           @"age" : @"20",
                           @"height" : @1.55,
                           @"money" : @"100.9",
                           @"sex" : @(SexFemale),
                           @"gay" : @"1"
                           //                             @"gay" : @"NO"
                           //                             @"gay" : @"true"
                           };
    RQUser *user = [RQUser rq_modelWithJson:dict];
    
    // 3.打印RQUser模型的属性
    NSLog(@"name=%@, icon=%@, age=%zd, height=%@, money=%@, sex=%d, gay=%d", user.name, user.icon, user.age, user.height, user.money, user.sex, user.gay);
}

/**
 *  字典里面嵌套模型
 */
- (void)keyValues2object2 {
    
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"text" : @"是啊，今天天气确实不错！",
                           
                           @"user" : @{
                                   @"name" : @"Jack",
                                   @"icon" : @"lufy.png"
                                   },
                           
                           @"retweetedStatus" : @{
                                   @"text" : @"今天天气真不错！",
                                   
                                   @"user" : @{
                                           @"name" : @"Rose",
                                           @"icon" : @"nami.png"
                                           }
                                   }
                           };
    
    
    RQStatus *status = [RQStatus rq_modelWithJson:dict];
    
    NSLog(@"text = %@, name = %@, icon = %@, text2 = %@, name2 = %@, icon2 = %@",status.text,status.user.name,status.user.icon,status.retweetedStatus.text,status.retweetedStatus.user.name,status.retweetedStatus.user.icon);
    
}

/**
 *  复杂的字典 -> 模型 (模型的数组属性里面又装着模型)
 */
- (void)keyValues2object3 {
    
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"statuses" : @[
                                   @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"明天去旅游了",
                                       
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               }
                                       }
                                   
                                   ],
                           
                           @"ads" : @[
                                   @{
                                       @"image" : @"ad01.png",
                                       @"url" : @"http://www.小码哥ad01.com"
                                       },
                                   @{
                                       @"image" : @"ad02.png",
                                       @"url" : @"http://www.小码哥ad02.com"
                                       }
                                   ],
                           
                           @"totalNumber" : @"2014",
                           @"previousCursor" : @"13476589",
                           @"nextCursor" : @"13476599"
                           };
    
    // 2.将字典转为RQStatusResult模型
    RQStatusResult *result = [RQStatusResult rq_modelWithJson:dict];
    
    // 3.打印RQStatusResult模型的简单属性
    NSLog(@"totalNumber=%@, previousCursor=%lld, nextCursor=%lld", result.totalNumber, result.previousCursor, result.nextCursor);
    
    // 4.打印statuses数组中的模型属性
    for (RQStatus *status in result.statuses) {
        NSString *text = status.text;
        NSString *name = status.user.name;
        NSString *icon = status.user.icon;
        NSLog(@"text=%@, name=%@, icon=%@", text, name, icon);
    }
    
    // 5.打印ads数组中的模型属性
    for (RQAd *ad in result.ads) {
        NSLog(@"image=%@, url=%@", ad.image, ad.url);
    }
}

@end

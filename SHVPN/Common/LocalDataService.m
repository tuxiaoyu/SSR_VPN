//#0	0x00000001000f48c8 in +[LocalDataService getSVNType] at /Users/wanglei/Documents/iOS相关/SS/融合/8修改bundleID之前可连接/SHVPN/Class/UserDefaultCenter/LocalDataService.m:26

//  LocaDataService.m
//  SHVPN
//
//  Created by 王雷 on 2017/9/8.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "LocalDataService.h"
//SVN类型
#define SVN_type @"vpn_type"
//VPN分流配置
#define SVN_confige @"vpn_confige"
//订阅到期时间
#define Expires_date @"expires_date"


static id _instance;

@implementation LocalDataService : NSObject
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+(NSString *)getSVNType{
 
    if ([[NSUserDefaults standardUserDefaults]  stringForKey:SVN_type]) {
        return [[NSUserDefaults standardUserDefaults]  stringForKey:SVN_type];
    }else{
        return @"SS";
    }
}
+(void)setSVNType:(NSString *)type{
    [[NSUserDefaults standardUserDefaults]  setValue:type forKey:SVN_type];
}

//VPN分流配置
+(NSString *)getSVNTConfige{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:SVN_confige]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:SVN_confige];
    }else{
       //如果UserDefault 没有数据读取本地文件的
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"gfwlist" withExtension:@"json"];
        NSString *string =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSString *temp = [string substringWithRange:NSMakeRange(1, string.length - 2)];
         return temp;
    }
}
+(void)setSVNTConfige:(NSString *)confige{
    
    [[NSUserDefaults standardUserDefaults] setValue:confige forKey:SVN_confige];
}

//订阅到期时间
+(NSString *)getexpiresDate{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:Expires_date]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:Expires_date];
    }else{
        return @"";
    }
}

+(void)setexpiresDate:(NSString *)date{
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:Expires_date];
}
@end

//
//  AIHelpeManager.m
//  SHVPN
//
//  Created by 王树超 on 2018/4/25.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "AIHelpeManager.h"
//ALHelp客服
#import <ElvaChatServiceSDK/ECServiceSdk.h>
@implementation AIHelpeManager
+(instancetype)sharedManager{
    static AIHelpeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AIHelpeManager alloc] init];
    });
    return manager;
}
//初始化AIHelper
+(void)init:(NSString*) appSecret Domain:(NSString*) domain AppId:(NSString*) appId{
    [ECServiceSdk init:appSecret Domain:domain AppId:appId];
    [ECServiceSdk setName:@" "];
}


//用户名
+(NSString *)getAI_UserName{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"AI_UserName"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"AI_UserName"];
    }else{
        return @"游客";
    }
}
+(void)setAI_UserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"AI_UserName"];
}


//用户唯一表示
+(NSString *)getAI_UserID{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"AI_UserID"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"AI_UserID"];
    }else{
        return @"123456";
    }
}
+(void)setAI_UserID:(NSString *)userID{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"AI_UserID"];
}
//用户服务器
+(NSString *)getAI_ServerId{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"AI_ServerId"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"AI_ServerId"];
    }else{
        return @"123";
    }
}
+(void)setAI_ServerId:(NSString *)serverId{
    [[NSUserDefaults standardUserDefaults] setObject:serverId forKey:@"AI_ServerId"];
}
//tags
+(NSString *)getAIHelp_tags{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"AIHelp_tags"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"AIHelp_tags"];
    }else{
        return @"vip1";
    }
}
+(void)setAIHelp_tags:(NSString *)tags{
    [[NSUserDefaults standardUserDefaults] setObject:tags forKey:@"AIHelp_tags"];
}
//版本
+(NSString *)getAIHelp_VersionCode{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"AIHelp_VersionCode"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"AIHelp_AIHelp_VersionCode"];
    }else{
        return @"1.0.0";
    }
}
+(void)setAIHelp_VersionCode:(NSString *)versionCode{
    [[NSUserDefaults standardUserDefaults] setObject:versionCode forKey:@"AIHelp_AIHelp_VersionCode"];
}
@end

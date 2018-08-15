//
//  AIHelpeManager.h
//  SHVPN
//
//  Created by 王树超 on 2018/4/25.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIHelpeManager : NSObject
+(instancetype)sharedManager;


//初始化AIHelper
+(void)init:(NSString*) appSecret Domain:(NSString*) domain AppId:(NSString*) appId;

//用户名
+(NSString *)getAI_UserName;
+(void)setAI_UserName:(NSString *)userName;
//用户唯一表示
+(NSString *)getAI_UserID;
+(void)setAI_UserID:(NSString *)userID;
//用户服务器
+(NSString *)getAI_ServerId;
+(void)setAI_ServerId:(NSString *)serverId;
//tags
+(NSString *)getAIHelp_tags;
+(void)setAIHelp_tags:(NSString *)tags;
//版本
+(NSString *)getAIHelp_VersionCode;
+(void)setAIHelp_VersionCode:(NSString *)versionCode;

@end

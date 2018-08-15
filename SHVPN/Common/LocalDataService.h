//
//  LocaDataService.h
//  SHVPN
//
//  Created by 王雷 on 2017/9/8.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDataService : NSObject
+(instancetype)shared;

+(NSString *)getSVNType;
+(void)setSVNType:(NSString *)type;

+(NSString *)getSVNTConfige;
+(void)setSVNTConfige:(NSString *)confige;

//订阅到期时间
+(NSString *)getexpiresDate;
+(void)setexpiresDate:(NSString *)date;
@end

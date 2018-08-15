//
//  CommUtls.h
//  SHVPN
//
//  Created by 王雷 on 2017/8/29.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommUtls : NSObject

//转换颜色色值
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//#define RGB(R, G, B)                        ([UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f])
+ (UIColor *)colorWithRGB:(CGFloat )r G:(CGFloat)g B:(CGFloat)b  ;
+(NSString *)getDeviceBounds;
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+ (NSURL *)getURLFromString:(NSString *)str;
+(NSString *)checkNullValueForString:(id)object;

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//检验是否为有效邮箱
+(BOOL)isValidateEmail:(NSString *)email;

+ (void)telePhone;

+(UIImage*)createImageWithColor:(UIColor*) color;
+(NSString*)getNowDate;
+(NSString*)getNowTime;
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
+ (NSString *)timeConvertoString:(NSString *)time;

//新活页面的时间转换
+ (NSString *)timeConvertoStringForWork:(double)time;
//李文刚+ 时间戳转时间字符串
+ (NSString *)timeStampConvertoString:(NSInteger)time;
+ (NSString *)getSha1String:(NSString *)srcString;
+ (NSString *)toJSONData:(id)theData;
+ (NSString*)base64forData:(NSData*)theData;
//erp
+(NSMutableArray*)getErpHeader;
+(NSString *) md5: (NSString *) inPutText;
//sha1  加密
+(NSString*) sha1:(NSString*)input;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//根据文字和文字字体计算label宽度
+(CGFloat)calculateRowWidth:(NSString *)string AndFont:(CGFloat)font ;

//获取网络状态
+(NSString *)getNetworkType;
//获取运营商
+(NSString *)getCarrierName;
@end

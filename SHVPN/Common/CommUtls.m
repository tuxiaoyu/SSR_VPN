//
//  CommUtls.m
//  SHVPN
//
//  Created by 王雷 on 2017/8/29.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "CommUtls.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation CommUtls

/**
 *	@brief	获取颜色
 *
 *	@param 	stringToConvert 	取色数值
 *
 *	@return	返回颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
/**
 *  获取颜色 rgb
 *
 *  @param r <#r description#>
 *  @param g <#g description#>
 *  @param b <#b description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *)colorWithRGB:(CGFloat )r G:(CGFloat)g B:(CGFloat)b
{
    return   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}
+(NSString *)getDeviceBounds
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    if (rect.size.width ==480||rect.size.height ==480) {
        return @"4";
    }else if (rect.size.width==568||rect.size.height ==568)
    {
        return @"5";
        
    }else if (rect.size.width==667||rect.size.height ==667)
    {
        return @"6";
        
    }else if (rect.size.width==736||rect.size.height ==736)
    {
        return @"6p";
        
    }
    
    return nil;
    
    
}

//图片尺寸处理
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSURL *)getURLFromString:(NSString *)str
{
    NSURL *url =[[NSURL alloc]initWithString:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return url;
}

/*
 判断JSon解析出来的Object是否为NSNull类型
 输入参数：需要判断的Object
 输出参数：返回一个经过格式化的NSString类型
 */
+(NSString *)checkNullValueForString:(id)object
{
    if([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if(!object)
    {
        return @"";// (NSString *)object;
    }
    else
    {
        return [NSString stringWithFormat:@"%@",object];// (NSString *)object;
    }
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */

//            String matchRex = "^[1][34578][0-9]{9}"; //进行正则表达式的校检
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString * matchRex = @"^[1][34578][0-9]{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchRex];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    || ([regextestcm evaluateWithObject:mobileNum] == YES)
//    || ([regextestct evaluateWithObject:mobileNum] == YES)
//    || ([regextestcu evaluateWithObject:mobileNum] == YES)
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    
  
    return [emailTest evaluateWithObject:email];
    
}

+(void)telePhone
{
    NSString *number = @"4009966566";// 此处读入电话号码
    // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    
//    使用这种方式拨打电话时，当用户结束通话后，iphone界面会停留在电话界面。
//    用如下方式，可以使得用户结束通话后自动返回到应用：
//    UIWebView*callWebview =[[UIWebView alloc] init];
//    NSURL *telURL =[NSURL URLWithString:@"tel:10086"];// 貌似tel:// 或者 tel: 都行
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    //记得添加到view上
//    [self.view addSubview:callWebview];
}




+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/**
 *  获取当前日期
 *
 *  @return <#return value description#>
 */
+(NSString*)getNowDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}
+(NSString*)getNowTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;

}
/**
 *  时间戳转换成时间
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)timeConvertoString:(NSString *)time{//时间戳转换成时间
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:ss"];
    NSString *regStr = [df stringFromDate:dt];
    return regStr;
}

//李文刚+
+(NSString *)timeStampConvertoString:(NSInteger)time {
    if (time == 0) {
        return @"";
    } else {
        NSDate *dt = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [df stringFromDate:dt];
        return dateStr;
    }
}

//新活页面的时间转换
+ (NSString *)timeConvertoStringForWork:(double)time{//时间戳转换成时间
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *regStr = [df stringFromDate:dt];
    
    return regStr;
}

+(NSString*)weekdayStringFromDate:(NSDate*)inputDate
{

    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//数组转jsonstring
+ (NSString *)toJSONData:(id)theData{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:theData
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
    
}
+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSUInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSUInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    (uint8_t)table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    (uint8_t)table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? (uint8_t)table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? (uint8_t)table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}
//设置erp cookie 信息
+(NSMutableArray*)getErpHeader
{
    int rand= arc4random();
    NSString *randT=[NSString stringWithFormat:@"%d",rand];
    NSString *notice=  [self md5:randT];
    NSString *signure=[NSString stringWithFormat:@"dc48eded7fc2e5cae062ea9b2c31ed1b%@",notice];//dc48eded7fc2e5cae062ea9b2c31ed1b
    NSString *sha1Code=[[self sha1:signure] lowercaseString];
    NSMutableArray *cookies=nil;
    NSString *header=nil;
    if (![sha1Code isEqualToString:@""]&&![sha1Code isEqual:[NSNull null]]) {
        header=[NSString stringWithFormat:@"Cookie=signature=%@;nonce=%@",sha1Code,notice];
        //创建一个cookie
        NSMutableDictionary *properties1 = [NSMutableDictionary dictionary];
        [properties1 setObject:@"signature" forKey:NSHTTPCookieName];
        [properties1 setObject:sha1Code forKey:NSHTTPCookieValue];
        [properties1 setObject:@"120.26.216.175:8088" forKey:NSHTTPCookieDomain];
        [properties1 setObject:@"120.26.216.175:8088" forKey:NSHTTPCookieOriginURL];
        [properties1 setObject:@"/" forKey:NSHTTPCookiePath];
        [properties1 setObject:@"0" forKey:NSHTTPCookieVersion];
        
        NSMutableDictionary *properties2 = [NSMutableDictionary dictionary];
        [properties2 setObject:@"nonce" forKey:NSHTTPCookieName];
        [properties2 setObject:notice forKey:NSHTTPCookieValue];
        [properties2 setObject:@"120.26.216.175:8088" forKey:NSHTTPCookieDomain];
        [properties2 setObject:@"120.26.216.175:8088" forKey:NSHTTPCookieOriginURL];
        [properties2 setObject:@"/" forKey:NSHTTPCookiePath];
        [properties2 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie1 = [[NSHTTPCookie alloc] initWithProperties:properties1];
        NSHTTPCookie *cookie2 = [[NSHTTPCookie alloc] initWithProperties:properties2];
        cookies=[[NSMutableArray alloc] initWithObjects:cookie1,cookie2, nil];
    }
//    Set-Cookie: JSESSIONID=13B4ADC06D4DEF5DA6452969701343EE; Path=/yhr
//    Set-Cookie: JSESSIONID=13B4ADC06D4DEF5DA6452969701343EE; Expires=Thu, 10-Mar-2016 02:49:52 GMT
    return cookies;
}
+(NSString *) md5: (NSString *) inPutText
{
    const char *original_str = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//sha1  加密
+(NSString*) sha1:(NSString*)input

{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
    
}
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }

    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(CGFloat)calculateRowWidth:(NSString *)string AndFont:(CGFloat)font {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
//获取网络状态
+(NSString *)getNetworkType{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *statue;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            statue = @"无服务";
            break;
            
        case 1:
            NSLog(@"2G");
            statue =@"2G";
            break;
            
        case 2:
            NSLog(@"3G");
            statue=@"3G";
            break;
            
        case 3:
            NSLog(@"4G");
            statue=@"4G";
            break;
            
        case 4:
            NSLog(@"LTE");
            statue=@"LTE";
            break;
            
        case 5:
            NSLog(@"Wifi");
            statue=@"Wifi";
            break;
            
            
        default:
            statue=@"未获取到";
            break;
    }
    return statue;
}
#pragma mark 获取运营商的名称
+(NSString *)getCarrierName{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        mobile = @"没卡";
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
}

@end

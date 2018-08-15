//
//  userModel.h
//  SHVPN
//
//  Created by Tommy on 2017/12/26.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userModel : NSObject<NSCoding>
//激活时间
@property(nonatomic,copy)NSString * register_time;
//唯一点登陆标识
@property(nonatomic,copy)NSString * token;
//有效期
@property(nonatomic,copy)NSString * user_expiration_date;
//用户类型（VIP 和 free）
@property(nonatomic,copy)NSString * user_type;
//后台生成的手机唯一标识UUID
@property(nonatomic,copy)NSString * uuid;
//购买的套餐
@property(nonatomic,copy)NSString *goods_name;
//qq群
@property(nonatomic,copy)NSString *qq;
//密码
@property(nonatomic,copy)NSString *password;
//手机号
@property(nonatomic,copy)NSString *phone;
//二维码的版本号
@property(nonatomic,copy)NSString *version;

//用户名
@property(nonatomic,copy)NSString *user_name;

@property(nonatomic,copy)NSString *apple_id;
@end

//
//  routeModel.h
//  SHVPN
//
//  Created by Tommy on 2017/12/18.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface routeModel : NSObject <NSCoding>
//服务器IP
@property(nonatomic,copy)NSString *vps_addr;
//用户名
@property(nonatomic,copy)NSString *vps_username;
//密码
@property(nonatomic,copy)NSString *vps_password;
//psk
@property(nonatomic,copy)NSString *vps_psk;
//服务器国家代码
@property(nonatomic,copy)NSString *vps_area_code;
//服务器国家名称
@property(nonatomic,copy)NSString *vps_area_name;
//服务器的连接类型
@property(nonatomic,copy)NSString *vps_connect_type;
//remote_id
@property(nonatomic,copy)NSString *remote_id;
//ss加密方式
@property(nonatomic,copy)NSString *encrypt;
//ss密码
@property(nonatomic,copy)NSString *ss_pass;

@property(nonatomic,copy)NSString *port;

@property(nonatomic,copy)NSString *vip;
@property(nonatomic,copy)NSString *add_time;
@property(nonatomic,copy)NSString *supplier;
//协议插件
    @property(nonatomic,copy) NSString *ss_protocol;
    @property(nonatomic,copy) NSString *ss_mix;
@end

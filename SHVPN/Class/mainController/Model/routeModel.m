//
//  routeModel.m
//  SHVPN
//
//  Created by Tommy on 2017/12/18.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "routeModel.h"

@implementation routeModel 

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"ip"]) {
        self.vps_addr = value;
    }
    
    if ([key isEqualToString:@"name"]) {
        self.vps_username = value;
    }
    
    if ([key isEqualToString:@"pass"]) {
        self.vps_password = value;
    }
    
    if ([key isEqualToString:@"psk"]) {
        self.vps_psk = value;
    }
    
    if ([key isEqualToString:@"remote_id"]) {
        self.remote_id = value;
    }
    
    if ([key isEqualToString:@"connect_type"]) {
        self.vps_connect_type = value;
    }
    
    if ([key isEqualToString:@"area_code"]) {
        self.vps_area_code = value;
    }
    
    
}


//"ip": "45.77.126.213",
//"name": "ipsEC@ioS%vPn",
//"pass": "CespiNpVsoi2016",
//"psk": 'iosVpN%6102ipsEC' ,
//"port": "63521",
//"remote_id": "qdlpn.com",
//"connect_type": "ssr",
//"area_code": "us",
//"vip": "0",
//"add_time": "2017-11-03 16:43:29",
//"supplier" : "Linode"

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder  encodeObject:self.vps_addr forKey:@"vps_addr"];
    [aCoder encodeObject:self.vps_username forKey:@"vps_username"];
    [aCoder  encodeObject:self.vps_password forKey:@"vps_password"];
    [aCoder  encodeObject:self.vps_psk forKey:@"vps_psk"];
    [aCoder encodeObject:self.vps_area_code forKey:@"vps_area_code"];
    [aCoder  encodeObject:self.vps_area_name forKey:@"vps_area_name"];
    [aCoder  encodeObject:self.vps_connect_type forKey:@"vps_connect_type"];
    [aCoder encodeObject:self.remote_id forKey:@"remote_id"];
    [aCoder  encodeObject:self.encrypt forKey:@"encrypt"];
    [aCoder  encodeObject:self.port forKey:@"port"];
    [aCoder encodeObject:self.vip forKey:@"vip"];
    [aCoder  encodeObject:self.add_time forKey:@"add_time"];
    [aCoder  encodeObject:self.supplier forKey:@"supplier"];
    [aCoder encodeObject:self.ss_pass forKey:@"ss_pass"];
    [aCoder encodeObject:self.ss_protocol forKey:@"self.ss_protocol"];
    [aCoder encodeObject:self.ss_mix forKey:@"self.ss_mix"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.vps_addr = [aDecoder decodeObjectForKey:@"vps_addr"];
    self.vps_username = [aDecoder decodeObjectForKey:@"vps_username"];
    self.vps_password = [aDecoder decodeObjectForKey:@"vps_password"];
    self.vps_psk = [aDecoder decodeObjectForKey:@"vps_psk"];
    self.vps_area_code = [aDecoder decodeObjectForKey:@"vps_area_code"];
    self.vps_area_name = [aDecoder decodeObjectForKey:@"vps_area_name"];
    self.vps_connect_type = [aDecoder decodeObjectForKey:@"vps_connect_type"];
    self.remote_id = [aDecoder decodeObjectForKey:@"remote_id"];
    self.encrypt = [aDecoder decodeObjectForKey:@"encrypt"];
    self.port = [aDecoder decodeObjectForKey:@"port"];
    self.vip = [aDecoder decodeObjectForKey:@"vip"];
    self.add_time = [aDecoder decodeObjectForKey:@"add_time"];
    self.supplier = [aDecoder decodeObjectForKey:@"supplier"];
    self.ss_pass = [aDecoder decodeObjectForKey:@"ss_pass"];
    self.ss_mix = [aDecoder decodeObjectForKey:@"ss_mix"];
    self.ss_protocol = [aDecoder decodeObjectForKey:@"ss_protocol"];
    return self;
}

@end

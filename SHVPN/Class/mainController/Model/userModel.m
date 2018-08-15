//
//  userModel.m
//  SHVPN
//
//  Created by Tommy on 2017/12/26.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "userModel.h"

@implementation userModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder  encodeObject:self.register_time forKey:@"register_time"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder  encodeObject:self.user_expiration_date forKey:@"user_expiration_date"];
    
    [aCoder  encodeObject:self.user_type forKey:@"user_type"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder  encodeObject:self.goods_name forKey:@"goods_name"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder  encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.apple_id forKey:@"apple_id"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.register_time = [aDecoder decodeObjectForKey:@"register_time"];
    self.token = [aDecoder decodeObjectForKey:@"token"];
    self.user_expiration_date = [aDecoder decodeObjectForKey:@"user_expiration_date"];
    
    self.user_type = [aDecoder decodeObjectForKey:@"user_type"];
    self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    self.goods_name = [aDecoder decodeObjectForKey:@"goods_name"];
    
    self.qq = [aDecoder decodeObjectForKey:@"qq"];
    self.password = [aDecoder decodeObjectForKey:@"password"];
   
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.version = [aDecoder decodeObjectForKey:@"version"];
    self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
    self.apple_id = [aDecoder decodeObjectForKey:@"apple_id"];
    return self;
}
@end

//
//  listModel.m
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "listModel.h"

@implementation listModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder  encodeObject:self.area_code forKey:@"area_code"];
    [aCoder encodeObject:self.area_name forKey:@"area_name"];
    [aCoder  encodeObject:self.type forKey:@"area_type"];
    [aCoder encodeObject:self.flag forKey:@"flag"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.area_name = [aDecoder decodeObjectForKey:@"area_name"];
    self.area_code = [aDecoder decodeObjectForKey:@"area_code"];
    self.type = [aDecoder decodeObjectForKey:@"area_type"];
    self.flag = [aDecoder decodeObjectForKey:@"flag"];
    return self;
}

@end

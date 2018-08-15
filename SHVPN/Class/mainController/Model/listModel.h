//
//  listModel.h
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface listModel : NSObject <NSCoding>

@property(nonatomic,copy)NSString * area_code;

@property(nonatomic,copy)NSString * area_name;

@property(nonatomic,copy)NSString * type;

@property(nonatomic,copy)NSString * flag;

@end

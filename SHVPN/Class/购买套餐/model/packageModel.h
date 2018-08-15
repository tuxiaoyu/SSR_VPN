//
//  packageModel.h
//  SHVPN
//
//  Created by Tommy on 2017/12/22.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface packageModel : NSObject
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *goods_info;
@property(nonatomic,copy)NSString *goods_price;
@property(nonatomic,copy)NSString *is_hot;
@property(nonatomic,copy)NSString *priority;
@property(nonatomic,copy)NSString *goods_name;


//订单model
//订单号
@property(nonatomic,copy) NSString *order_num;
//价格
@property(nonatomic,copy) NSString *order_amount;
//商品促销的价格
@property(nonatomic,copy) NSString *promotion_price;

@end

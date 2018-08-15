//
//  activityModel.h
//  SHVPN
//
//  Created by Tommy on 2018/4/27.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activityModel : NSObject
/**
 "bundle_id" = "com.ssr";
 content = "\U4fc3\U9500\U4ef7\U6765\U88ad";
 "end_date" = "2018-04-27 11:44:32";
 id = 1;
 img = "<null>";
 intro = "\U4fc3\U9500\U4ef7\U6765\U88ad";
 link = "<null>";
 "sale_type" = discount;
 "start_date" = "2018-04-25 11:44:22";
 title = "\U4fc3\U9500\U4ef7\U6765\U88ad";
 */


@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *end_date;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *sale_type;
@property(nonatomic,copy)NSString *start_date;
@end

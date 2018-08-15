//
//  rountChooseViewController.h
//  SHVPN
//
//  Created by Tommy on 2017/12/15.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userModel.h"
@class listModel;
@protocol  routeDelegate<NSObject>

-(void)chooseRouteInfo:(listModel *)model;

@end

@interface rountChooseViewController : UIViewController

@property(nonatomic,assign)id <routeDelegate> Delegate;

@property(nonatomic,strong)userModel *usermoder;
@end

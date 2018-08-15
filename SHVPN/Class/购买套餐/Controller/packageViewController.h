//
//  packageViewController.h
//  SHVPN
//
//  Created by Tommy on 2017/12/15.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userModel.h"
@protocol  buySuccessDelgate<NSObject>

-(void)UIRefreshWithToken:(NSString *)token;

@end

@interface packageViewController : UIViewController

@property(nonatomic,assign)id <buySuccessDelgate> buyDelegate;

@property(nonatomic,strong)userModel *model;

@property(nonatomic,assign)NSInteger   payTypeInt;
//是否显示协议(1为显示)
@property(nonatomic,assign)NSInteger   isShowProtocal;

@property(nonatomic,copy)NSString *protocol;
@property(nonatomic,copy)NSString *service;

+(instancetype)sharePay;

-(void)getSubscribeTime;

@end

//
//  userCenterViewController.h
//  SHVPN
//
//  Created by Tommy on 2017/12/26.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userModel.h"

@protocol  userCountLoginDelegate<NSObject>

-(void)userLoginByCount:(NSString *)count  passsword:(NSString *)psd;

-(void)userActive;
@end

@interface userCenterViewController : UIViewController

@property(nonatomic,strong)userModel *usermodel;

@property(nonatomic,weak)id <userCountLoginDelegate> delegate;

@end

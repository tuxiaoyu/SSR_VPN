//
//  bindTelorEmailViewController.h
//  SHVPN
//
//  Created by Tommy on 2018/1/8.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userModel.h"
@interface bindTelorEmailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *telorEmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *coderTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendmsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

/*
 1000 绑定手机号
 1001 修改手机号
 1002 找回密码
*/
@property(nonatomic,assign)NSInteger  tag;
@property(nonatomic,copy)NSString *navTitle;

@property(nonatomic,strong)userModel *model;
@end

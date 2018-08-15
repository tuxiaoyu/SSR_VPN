//
//  loginView.m
//  SHVPN
//
//  Created by Tommy on 2018/3/30.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "loginView.h"

@implementation loginView

-(void)awakeFromNib{
    self.userNameTextfield.placeholder = NSLocalizedString(@"key86", @"请输入用户名和密码");
    self.psdTextField.placeholder = NSLocalizedString(@"key56", @"请输入密码");
                                     
    [self.cancelBtn setTitle:NSLocalizedString(@"key17", @"取消") forState:UIControlStateNormal];
    [self.sureBtn setTitle:NSLocalizedString(@"key10", @"确定") forState:UIControlStateNormal];
                                     
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self removeFromSuperview];
}


- (IBAction)sureAction:(UIButton *)sender {
    
    [self.delgate userLoginWithuserName:self.userNameTextfield.text psd:self.psdTextField.text];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.psdTextField resignFirstResponder];
    [self.userNameTextfield resignFirstResponder];
}
@end

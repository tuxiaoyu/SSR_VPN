//
//  tipsView.m
//  SHVPN
//
//  Created by Tommy on 2018/3/30.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "tipsView.h"

@implementation tipsView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.tipsLabel.text = NSLocalizedString(@"key70", @"提示");
    
    [self.cancelBtn setTitle:NSLocalizedString(@"key17", @"取消") forState:UIControlStateNormal];
    [self.sureBtn setTitle:NSLocalizedString(@"key10", @"确定") forState:UIControlStateNormal];
    
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self removeFromSuperview];
}

- (IBAction)sureAction:(UIButton *)sender {
    
    [self.delegate bindTelorEmail];
    
}

@end

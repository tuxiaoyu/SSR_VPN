//
//  adView.m
//  SHVPN
//
//  Created by Tommy on 2018/1/19.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "adView.h"

@implementation adView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.userInteractionEnabled = YES;
//    UIView *bgView = [[UIView alloc]init];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(15 * KHeight_Scale));
//        make.bottom.equalTo(@(0));
//        make.left.equalTo(@(0));
//        make.right.equalTo(@(-15 * KWidth_Scale));
//    }];

    
    
    
    self.closeBtn = [[UIButton alloc]init];
    [self.closeBtn  setImage:[UIImage imageNamed:@"rec_popup_error"] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    self.closeBtn.contentMode = UIViewContentModeScaleToFill;
    [self.closeBtn  addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15 * KHeight_Scale));
        make.right.equalTo(@(15 * KWidth_Scale));
        make.width.equalTo(@(50 * KWidth_Scale));
        make.height.equalTo(@(50 * KHeight_Scale));
    }];
    
    self.adWebView = [[WKWebView alloc]init];
    self.adWebView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.adWebView];
    [self.adWebView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0 * KWidth_Scale));
        make.right.equalTo(@(0 * KHeight_Scale));
        make.top.equalTo(@(0 * KWidth_Scale));
        make.bottom.equalTo(@(0 * KHeight_Scale));
    }];
    
    [self bringSubviewToFront:self.closeBtn];
}

-(void)btnAction{
    
    [self.delegate  removeAdView];
}
@end

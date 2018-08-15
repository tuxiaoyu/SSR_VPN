//
//  noDataView.m
//  SHVPN
//
//  Created by Tommy on 2017/12/26.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "noDataView.h"

@implementation noDataView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}


-(void)setupView{
    
    UIImageView *bgview = [[UIImageView alloc]init];
    bgview.image = [UIImage imageNamed:@"line_image_error"];
    bgview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.text = NSLocalizedString(@"key33", nil);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = colorRGB(110, 110, 110);
    [self addSubview:tipsLabel];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bgview);
        make.trailing.equalTo(bgview);
        make.top.equalTo(bgview.mas_bottom).with.offset(30 * KHeight_Scale);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"line_button_ok"] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"key34", nil) forState:UIControlStateNormal];
    [btn  addTarget:self action:@selector(actionBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(150 * KWidth_Scale));
        make.height.equalTo(@(45 * KHeight_Scale));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(tipsLabel.mas_bottom).with.offset(40 * KHeight_Scale);
    }];
}


-(void)actionBtn{
    [self.delegate refreshUI];
}
@end

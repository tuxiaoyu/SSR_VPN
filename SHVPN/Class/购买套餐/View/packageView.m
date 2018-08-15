//
//  packageView.m
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "packageView.h"

@implementation packageView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}


-(void)setupView{
    
    __weak typeof(self) weakSelf = self;
    //图标
    self.iconImageView = [[UIImageView alloc]init];
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview: self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20 * KHeight_Scale));
        make.width.mas_equalTo(50 * KWidth_Scale);
        make.height.equalTo(weakSelf.iconImageView.mas_width);
        make.centerX.equalTo(@(0));
    }];
    [self layoutIfNeeded];
    
    self.titleLabel = [[UILabel alloc]init];
    
    [self addSubview:self.titleLabel];

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = colorRGB(129, 129, 129);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).with.offset(0 * KHeight_Scale);
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.bottom.equalTo(@(-10 * KHeight_Scale));
    }];
    
}

@end

//
//  itemView.m
//  SHVPN
//
//  Created by Tommy on 2017/12/13.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "itemView.h"

@implementation itemView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    __weak typeof(self) weakSelf = self;
    
    //图片
    self.imgView = [[UIImageView alloc]init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self  addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(5 * KHeight_Scale));
        make.bottom.equalTo(@(-5 * KHeight_Scale));
        make.width.equalTo(weakSelf.imgView.mas_height);
    }];
   
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = colorRGB(56, 56, 56);
    [self  addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imgView.mas_right).with.offset(10 * KWidth_Scale);
        make.top.equalTo(weakSelf.imgView.mas_top);
        make.bottom.equalTo(weakSelf.imgView.mas_bottom);
//        make.right.equalTo(weakSelf.detailLbel.mas_left);
    }];

    
    
    //详情
    self.detailLbel = [[UILabel alloc]init];
    self.detailLbel.textAlignment = NSTextAlignmentRight;
    self.detailLbel.textColor = colorRGB(121, 121, 121);
    [self addSubview:self.detailLbel];
    [self.detailLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right);
        make.top.equalTo(weakSelf.imgView.mas_top);
        make.bottom.equalTo(weakSelf.imgView.mas_bottom);
    }];

    //右箭头
    
    self.moreButton = [[UIButton alloc]init];
    [self.moreButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview: self.moreButton];
    [self.moreButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.detailLbel.mas_right);
        make.top.equalTo(weakSelf.imgView.mas_top);
        make.bottom.equalTo(weakSelf.imgView.mas_bottom);
        make.right.equalTo(weakSelf);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)];
    
    [self addGestureRecognizer:tap];
}


-(void)TapAction:(UIGestureRecognizer *)sender{
    
    [self.delegate  buttonJump:self.tagNum];
}

-(void)action:(UIButton *)sender{
    
        [self.delegate buttonJump:sender.tag];

}
@end

//
//  itemView.h
//  SHVPN
//
//  Created by Tommy on 2017/12/13.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol  jumpDelegate<NSObject>

-(void)buttonJump:(NSInteger)sender;

@end

@interface itemView : UIView

@property(nonatomic,strong)UIImageView  *imgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLbel;
@property(nonatomic,strong)UIButton *moreButton;
//记录点击了哪一个按钮
@property(nonatomic,assign)NSInteger  tagNum;
@property(nonatomic,assign) id <jumpDelegate>  delegate;


@end

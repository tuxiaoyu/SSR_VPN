//
//  paomaView.h
//  SHVPN
//
//  Created by Tommy on 2018/4/24.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface paomaView : UIView
@property(nonatomic,strong) NSTimer* timer;// 定义定时器
@property(nonatomic,strong) UIView *viewAnima; //装 滚动视图的容器
@property(nonatomic,weak) UILabel *customLab;
@end

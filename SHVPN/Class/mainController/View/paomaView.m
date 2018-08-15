//
//  paomaView.m
//  SHVPN
//
//  Created by Tommy on 2018/4/24.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "paomaView.h"

@implementation paomaView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}


-(void)setUpView{
 
    //定义视图大小
    UIView *viewAnima = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.viewAnima = viewAnima;
    self.viewAnima.clipsToBounds = YES;
    
    [self addSubview:self.viewAnima];
    
   
    UILabel *customLab = [[UILabel alloc] init];
    customLab.frame = CGRectMake(self.viewAnima.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [customLab setTextColor:[UIColor redColor]];
    customLab.font = [UIFont boldSystemFontOfSize:15];
    self.customLab = customLab;

    //添加视图
    [self.viewAnima addSubview:customLab];
    
    // 启动NSTimer定时器来改变UIImageView的位置
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self selector:@selector(changePos)
                                                userInfo:nil repeats:YES];
}


- (void) changePos
{
    CGPoint curPos = self.customLab.center;

    // 当curPos的x坐标已经超过了屏幕的宽度
    if(curPos.x <  -100 )
    {
        CGFloat jianJu = self.customLab.frame.size.width/2;
        // 控制蝴蝶再次从屏幕左侧开始移动
        self.customLab.center = CGPointMake(self.viewAnima.frame.size.width + jianJu, 20);
        
    }
    else
    {
        self.customLab.center = CGPointMake(curPos.x - 5, 20);
    }
}


-(CGFloat)getTextlenght:(NSString *)str{
    
    return 0;
}
@end

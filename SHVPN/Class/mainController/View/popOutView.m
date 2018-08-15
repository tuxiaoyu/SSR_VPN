//
//  popOutView.m
//  SHVPN
//
//  Created by Tommy on 2018/4/25.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "popOutView.h"

@implementation popOutView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self getAdData];
        [self   setupView];
    }
    return self;
}


-(void)setupView{
   //弹框界面
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10 * KWidth_Scale, 0, self.frame.size.width - 20 * KWidth_Scale, self.frame.size.height * 3/4)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4;
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bgView];
    
    
    self.bgImg = [[UIImageView alloc]initWithFrame:bgView.frame];
    self.bgImg.contentMode =  UIViewContentModeScaleAspectFit;
    [self addSubview:self.bgImg];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width + 20 * KWidth_Scale -(self.frame.size.height * 1/4) - 20 * KHeight_Scale)/2 , (self.frame.size.height * 3/4) + 10 * KHeight_Scale, (self.frame.size.height * 1/4) - 20 * KHeight_Scale, (self.frame.size.height * 1/4) - 20 * KHeight_Scale)];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = ((self.frame.size.height * 1/4) - 20 * KHeight_Scale)/2 ;
    [self addSubview:btn];
    
}


-(void)removeView{
    
    [self   removeFromSuperview];
}


#pragma mark 获取广告信息
-(void)getAdData{
    //获取广告信息
    NSString *urlStr = [rootUrl stringByAppendingString:openAppAdURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    [manager POST:urlStr parameters:@{@"bundle_id":[NSBundle mainBundle].bundleIdentifier} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *data = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [data jsonDictionary];
        
        [self.bgImg sd_setImageWithURL:[NSURL URLWithString:dic[@"popout"][@"image"]]];
        
        if ([dic[@"popout"][@"is_open"] integerValue] == 0) {
            self.hidden = YES;
        }
        NSLog(@"广告数据：%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
@end

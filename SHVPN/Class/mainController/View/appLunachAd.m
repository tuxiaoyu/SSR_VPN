//
//  appLunachAd.m
//  SHVPN
//
//  Created by Tommy on 2018/4/25.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "appLunachAd.h"

@implementation appLunachAd

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self getAdData];
        [self setupView];
       
    }
    
    return self;
}


-(void)setupView{
    self.bgImg = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:self.bgImg];
   
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth - 100 * KWidth_Scale,  50 * KHeight_Scale,80 * KWidth_Scale, 30 * KHeight_Scale);
        [btn  setTitle:@"取消" forState:UIControlStateNormal];
        
        [btn addTarget: self  action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor  grayColor];
        [self addSubview:btn];
        
        self.btn = btn;
  
    
     [self reduceTime];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgLink:)];
    [self addGestureRecognizer:tap];
    
}

-(void)removeView{
    
    [self  removeFromSuperview];
}

-(void)imgLink:(UIGestureRecognizer *)sender{
    [self.delegate imgTapLink:self.URLStr];
    [self removeFromSuperview];
}

#pragma mark 倒计时
-(void)reduceTime{
    __block NSInteger time = 5 ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.btn  setTitle:@"X" forState:UIControlStateNormal];
            });
            
        }else{
            
            int seconds = time % 10;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.btn setTitle:[NSString stringWithFormat:@"(跳过%ds)", seconds] forState:UIControlStateNormal];
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
        NSDictionary *dict = [data jsonDictionary];
        
        [self.bgImg sd_setImageWithURL:[NSURL URLWithString:dict[@"coopen"][@"image"]]];
        
        if ([dict[@"coopen"][@"is_open"] integerValue] == 0) {
            self.hidden = YES;
        }
        
        self.URLStr = dict[@"coopen"][@"link"];
        
        NSLog(@"广告数据：%@",dict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


@end

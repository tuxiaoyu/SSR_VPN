//
//  openAdViewController.m
//  newSHVPN
//
//  Created by Tommy on 2018/2/2.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "openAdViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "adViewController.h"

@interface openAdViewController ()

@end

@implementation openAdViewController

//adInfo =         {
//    image = "http://45.77.28.206/Public/Uploads/2018-02-02/5a744c14b59be.jpg";
//    "is_open" = 1;
//    link = "www.baidu.com";
//};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [bgImage sd_setImageWithURL:[NSURL URLWithString:self.dic[@"image"]]];
    
    [self.view addSubview:bgImage];
     bgImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(webAction:)];
    [bgImage addGestureRecognizer:tap];
    
    
    UIButton *btn = [[UIButton alloc]init];
   
    [btn addTarget:self action:@selector(tuichuAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"rec_popup_error"] forState:UIControlStateNormal];
    [bgImage addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20*KWidth_Scale));
        make.top.equalTo(@(40 * KHeight_Scale));
        make.height.equalTo(@(50 * KWidth_Scale));
        make.width.equalTo(@(50 * KWidth_Scale));
    }];
    
}


-(void)tuichuAction:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webAction:(UIGestureRecognizer *)sender{
    if ([self.dic[@"link"] containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.dic[@"link"]]];
    }else {
        
//        if ([self.dic[@"link"] containsString:@"www"] || [self.dic[@"link"] containsString:@"http://"] || [self.dic[@"link"] containsString:@"https://"]) {
        
            adViewController *ad = [[adViewController alloc]init];
            ad.adURL = self.dic[@"link"];
            [self.navigationController pushViewController:ad animated:YES];
//        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end

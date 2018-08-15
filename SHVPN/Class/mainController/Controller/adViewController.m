//
//  adViewController.m
//  SHVPN
//
//  Created by Tommy on 2018/1/19.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "adViewController.h"
#import <WebKit/WebKit.h>
@interface adViewController ()

@end

@implementation adViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
    
    if (self.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back1)];
    }
}

-(void)back1{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    WKWebView *web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight )];
    if ([self.adURL containsString:@"itunes.apple.com"]) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.adURL]];
        
    }else if ([self.adURL containsString:@"http://"] || [self.adURL containsString:@"www"]) {
        NSURLRequest *request = nil;
        
        if ([self.adURL containsString:@"http://"]) {
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adURL]];
        }else{
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.adURL]]];
        }
        
        [web loadRequest:request];
        
        [self.view addSubview:web];
    }
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated: YES];
}


@end

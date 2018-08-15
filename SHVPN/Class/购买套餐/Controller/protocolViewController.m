//
//  protocolViewController.m
//  SHVPN
//
//  Created by Tommy on 2018/1/31.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "protocolViewController.h"

@interface protocolViewController ()

@end

@implementation protocolViewController

-(void)viewWillAppear:(BOOL)animated{
    
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *web = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urltring] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [web loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:[NSURL URLWithString:self.urltring]];
    [self.view addSubview:web];
}



@end

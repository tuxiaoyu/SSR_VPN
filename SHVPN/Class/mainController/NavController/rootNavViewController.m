//
//  rootNavViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/14.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "rootNavViewController.h"
#import "vpnLinkViewController.h"
@interface rootNavViewController ()

@end

@implementation rootNavViewController


+(void)initialize{

    UINavigationBar *bar = [UINavigationBar appearance];
    //字体为白色
    [bar setTintColor:[UIColor whiteColor]];

    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
     [bar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];

    
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
       
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = CGRectMake(0, 0, 60, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    [super pushViewController:viewController animated:animated];
}




//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//
//    
//
//     
//    [self.navigationBar setTintColor:[UIColor whiteColor]];
//
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//   
//    
//    self.navigationItem.hidesBackButton = YES;
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    
//    self.navigationItem.leftItemsSupplementBackButton = YES;
//}




-(void)back{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
       [self popViewControllerAnimated:YES];
    }
}



@end

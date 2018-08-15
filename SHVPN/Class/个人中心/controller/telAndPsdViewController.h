//
//  telAndPsdViewController.h
//  newSHVPN
//
//  Created by Tommy on 2018/1/23.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface telAndPsdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *TelTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UITextField *coderTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCoderBtn;

@property(nonatomic,strong)NSString *navTitle;
@end

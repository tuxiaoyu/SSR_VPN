//
//  loginView.h
//  SHVPN
//
//  Created by Tommy on 2018/3/30.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  userloginDelegate<NSObject>

-(void)userLoginWithuserName:(NSString *)userName  psd:(NSString *)password;

@end

@interface loginView : UIView
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property(nonatomic,weak)id <userloginDelegate> delgate;
@end

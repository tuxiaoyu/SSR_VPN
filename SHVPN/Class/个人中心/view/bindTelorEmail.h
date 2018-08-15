//
//  bindTelorEmail.h
//  SHVPN
//
//  Created by Tommy on 2018/1/9.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  refreshCoderDelegate<NSObject>

-(void)removeView;
-(void)refreshCoder;

@end

@interface bindTelorEmail : UIView
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *coderTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,copy)NSString *version;
@property(nonatomic,weak)id <refreshCoderDelegate> delgate;
@end

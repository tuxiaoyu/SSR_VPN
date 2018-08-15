//
//  tipsView.h
//  SHVPN
//
//  Created by Tommy on 2018/3/30.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  tipsdelegate<NSObject>

-(void)bindTelorEmail;

@end

@interface tipsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(weak,nonatomic)id<tipsdelegate> delegate;
@end

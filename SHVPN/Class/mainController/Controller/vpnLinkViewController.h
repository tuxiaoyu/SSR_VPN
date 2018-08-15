//
//  vpnLinkViewController.h
//  SHVPN
//
//  Created by Tommy on 2017/12/13.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vpnLinkViewController : UIViewController

@property(nonatomic,assign)BOOL isOpenAd;
-(void)getData;
//激活
-(void)userCountActiveWithUUID:(NSString *)uuID  bundle_id:(NSString *)bundle_ID Token:(NSString *)token;
//登录
-(void)userlogin:(NSString *)uuid password:(NSString *)psd telorEmail:(NSString *)tel vip_uuid:(NSString *)vipuuid;

@end

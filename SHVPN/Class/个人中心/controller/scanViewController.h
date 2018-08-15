//
//  scanViewController.h
//  SHVPN
//
//  Created by Tommy on 2017/12/27.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "LBXScanViewController.h"

@protocol  userLoginDelegate<NSObject>

-(void)userloginCount:(NSString *)uuid password:(NSString *)psd  telorEmail:(NSString *)tel vip_uuid:(NSString *)vipuuid;

@end

@interface scanViewController : LBXScanViewController

@property(nonatomic,assign)id <userLoginDelegate> userdelgate;

@property(nonatomic,strong)NSMutableDictionary *loginDic;

@end

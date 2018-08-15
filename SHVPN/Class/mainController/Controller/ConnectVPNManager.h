//
//  ConnectVPNManager.h
//  闪电 VPN
//
//  Created by 王树超 on 2018/3/7.
//  Copyright © 2018年 王鹏. All rights reserved.
//

#import <Foundation/Foundation.h>



@class routeModel;
@interface ConnectVPNManager : NSObject
@property(nonatomic,strong)routeModel* currentRouteModel;//当前线路
@property(nonatomic,strong)NSMutableArray *routeArrary;//备用线路数组；
@property(nonatomic,assign)int linkTime;//连接次数（点击链接按钮以后的）
+(instancetype)sharedManager;


//根据IP
-(void)statisticalLinkRateWihtIP:(NSString *) ip With:(BOOL)isSuccess;
//通过本地的国家名称获取线路和密码
-(void)GetVPNDataWithAreaName;

//设置当前线路
-(void)setCurrentRouteWith:(NSArray *)array;


//处理链接成功的情况
-(void)dealConnectedState;
//处理未链接的状态
-(BOOL)dealDisConnectedState;

//加载备用线路
-(void)loadSpareRoute;



@end


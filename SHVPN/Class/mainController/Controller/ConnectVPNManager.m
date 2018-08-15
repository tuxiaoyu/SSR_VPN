//
//  ConnectVPNManager.m
//  闪电 VPN
//
//  Created by 王树超 on 2018/3/7.
//  Copyright © 2018年 王鹏. All rights reserved.
//

#import "ConnectVPNManager.h"
#import "routeModel.h"
#import "STDPingServices.h"

@interface ConnectVPNManager()
@property (nonatomic,strong) NSArray * URLArray;

@property (nonatomic, strong) STDPingServices * pingServices;

@end
@implementation ConnectVPNManager

+(instancetype)sharedManager{
    static ConnectVPNManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        
    });
    return manager;
}


#pragma mark 懒加载
-(routeModel *)currentRouteModel{
    if (_currentRouteModel == nil) {
        _currentRouteModel = [[routeModel alloc] init];
    }
    return _currentRouteModel;
}
-(NSMutableArray *)routeArrary{
    if (_routeArrary == nil) {
        _routeArrary = [[NSMutableArray alloc] init];
    }
    return _routeArrary;
}

#pragma mark 处理链接情况
//处理链接成功的情况
-(void)dealConnectedState{
    if ([ConnectVPNManager sharedManager].linkTime > 0) {
        //统计链接率
        [self statisticalLinkRateWith:YES];
        //重置链接次数
        [ConnectVPNManager sharedManager].linkTime = 0;
    }
}
//处理未链接的状态
-(BOOL)dealDisConnectedState{
    //如果是点击链接按钮以后的链接失败
    if ([ConnectVPNManager sharedManager].linkTime >0) {
        //启动循环连接
        return [self goNextLink];
    }
    return NO;
}

//切换下个线路
-(BOOL)goNextLink{

    //统计链接率
    [self statisticalLinkRateWith:NO];
    
   
    if (self.linkTime > self.routeArrary.count) {
        self.linkTime = 0;
        return NO;
    }
    self.currentRouteModel = self.routeArrary[self.linkTime - 1];
    
    self.linkTime ++;
    return YES;
}


//设置当前线路
-(void)setCurrentRouteWith:(NSArray *)array{
    self.currentRouteModel.vps_addr = array[0][@"IP"];
    self.currentRouteModel.remote_id = array[0][@"remoteId"];
    self.currentRouteModel.vps_username = array[0][@"name"];
    self.currentRouteModel.vps_password = array[0][@"pass"];
}
//统计链接率
-(void)statisticalLinkRateWith:(BOOL)isSuccess{
    if (isSuccess) {
         NSLog(@"统计成功");
    }else{
        NSLog(@"统计失败");
    }
    
    [self getPingWith:self.currentRouteModel.vps_addr AndIsSuccess:isSuccess];
}

//根据IP
-(void)statisticalLinkRateWihtIP:(NSString *) ip With:(BOOL)isSuccess{
    [self getPingWith:ip AndIsSuccess:isSuccess];
}

//获取2次ping值 求平均数
-(void)getPingWith:(NSString *)IP AndIsSuccess:(BOOL)isSuccess{
    self.pingServices = [STDPingServices startPingAddress:IP callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItems.count  == 2) {
            
            double  ping1 = pingItem.timeMilliseconds;
            pingItem = (STDPingItem *)pingItems[1];
            double  ping2 = pingItem.timeMilliseconds;
            double
            ping = 0;
            if (ping1 != 0 && ping2 != 0) {
                ping = (ping2 + ping1)/2;
            }else if(ping2 + ping1 > 0){
                ping =(ping2 + ping1);
            }
            NSLog(@"%f",ping);
            NSString *pingStr = [NSString stringWithFormat:@"%.2f",ping];
            NSString *isSuccessStr = @"0";
            if (isSuccess) {
                isSuccessStr = @"1";
            }
            
            [self getLinkSuccessWithvpn_ip:IP is_success:isSuccessStr Ping:pingStr];
        }
    }];
}
#pragma mark 统计连接的成功率
-(void)getLinkSuccessWithvpn_ip:(NSString *)ip is_success:(NSString *)isSuccess Ping:(NSString *)ping{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    NSDictionary *dic = @{@"uuid":[UUID getUUID],@"vpn_ip":ip,@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"is_success":isSuccess,@"user_lan":language,@"operator":[CommUtls getCarrierName],@"net":[CommUtls getNetworkType],@"is_ping":ping};
    NSString *URL = [rootUrl stringByAppendingString:countUrl];
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        
        NSLog(@"统计%@",str);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败:%@",error);

    }];
}
//加载备用线路
-(void)loadSpareRoute{
    
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *name = [defaults objectForKey:@"areaname"];
//    if (name)
//    {
//        NSString * roadString = [NSString stringWithFormat:@"%@/lygamesService.asmx/GetExcellentIP?apikey=lygames_0953&Area=%@&Networkstate=%@&Operator=%@",GONGYOUURL,name,@"4G",@"美国"];
//        NSString *keyword = [roadString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:keyword];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
//        NSURLResponse *response = nil;
//        NSError *error = nil;
//        NSData *userdata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        if (userdata)
//        {
//            NSString *str = [[NSString alloc]initWithData:userdata encoding:NSUTF8StringEncoding];
//            if ([str rangeOfString:@"数据源"].location !=NSNotFound) {
//                [self GetVPNDataMessage];
//            }else
//            {
//                NSData *data = [[desFile decryptWithText:str] dataUsingEncoding:NSUTF8StringEncoding];
//                NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                //                NSArray * array = [NSJSONSerialization JSONObjectWithData:userdata options:NSJSONReadingMutableContainers error:nil];
//
//                if (array)
//                {
//                    for (NSDictionary *dict in array) {
//                        routeModel *model = [[routeModel alloc] init];
//                        model.Area =dict[@"Area"];
//                        model.IP = dict[@"IP"];
//                        model.remoteId = dict[@"remoteId"];
//                        model.name = dict[@"name"];
//                        model.pass = dict[@"pass"];
//                        model.currentTime = dict[@"currentTime"];
//                        [self.routeArrary addObject:model];
//                    }
//                }else
//                {
//                    //                    [self GetVPNDataMessage];
//                }
//            }
//        }else
//        {
//            //            [self GetVPNDataMessage];
//        }
//    }else
//    {
//        //        [self GetVPNDataMessage];
//    }
//
}


@end


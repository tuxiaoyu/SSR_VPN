
//
//  AppDelegate.m
//  LyVpn
//
//  Created by 王雷 on 2017/2/8.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "rootNavViewController.h"
#import "vpnLinkViewController.h"
#import "NetWorkReachability.h"
#import <NetworkExtension/NetworkExtension.h>
#import "rountChooseViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "desFile.h"
#import "scanViewController.h"

#import "packageViewController.h"

#import "LaunchIntroductionView.h"
#import "appLunachAd.h"
#import "adViewController.h"
//ALHelp客服
#import <ElvaChatServiceSDK/ECServiceSdk.h>

typedef struct objc_method *Method;


@interface AppDelegate ()<UNUserNotificationCenterDelegate,openAppAdDeleate>

@property (nonatomic,assign)BOOL isConect;

@property (nonatomic,assign)BOOL  bolgConnect;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //ALHelp客服
    
    //临时测试参数
    NSString *appSecret = @"BEIJING_app_c522422fe80b44f4b121d3facc85c996";
    NSString *domain = @"Beijing.CS30.NET";
    NSString *appId = @"Beijing_pf_c36be81c5df14f6b9a285f840a7446e7";
    //初始化客服
    [AIHelpeManager init:appSecret Domain:domain AppId:appId];
    
    
    
    if ([UUID getUUID] != nil) {
      [[packageViewController sharePay] getSubscribeTime];
       
    }
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    vpnLinkViewController * newVc = [[vpnLinkViewController alloc] init];

    rootNavViewController *nav = [[rootNavViewController alloc] init];
    
    [nav  addChildViewController:newVc];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
 
    self.isConect = NO;
    

    
    //启动轮播图（测试数据）
     [LaunchIntroductionView sharedWithImages:@[@"iphone1.png",@"iphone2.png",@"iphone3.png"]];

    //获取可以使用的域名
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"rootIP" ofType:@"plist"]];
    NSString *str = [[NSString alloc]initWithData:[JoDess decodeBase64WithString:arr[0]] encoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://%@",str];
    [[NSUserDefaults standardUserDefaults]setValue:url forKey:@"ip"];
    
    //网络判断
    if ([NetWorkReachability internetStatus]) {
        //更新域名池
        [self getAvailableIP:url];
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key9", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           vpnLinkViewController * VC = (vpnLinkViewController *)[self currentViewController];
            [VC getData];
        }];
        [alert addAction:action];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }

    
    //推送注册
    
    if (iOS10Later) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center setDelegate:self];
        
        UNAuthorizationOptions type = UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:type completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"注册成功");
            }else{
                NSLog(@"注册失败");
            }
        }];

          [self addLocalNotification];
        
    }else if(iOS8Later){
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert;
        
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:notificationTypes];
  
    }
    //获取device  token
    [application  registerForRemoteNotifications];
    
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLoginInfo" object:userInfo];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

 
    //开屏广告
//        appLunachAd *ad = [[appLunachAd alloc]initWithFrame:self.window.frame];
//    
//        ad.delegate = self;
//        [self.window addSubview:ad];
 
    
    return YES;

}

// 注册deviceToken成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    //进行网络请求
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults]setValue:deviceTokenStr forKey:@"deviceTokenStr"];
    
    if ([[UUID getUUID] length] > 0) {
        [self requsetPostWithUrl:deviceTokenUrl parameters:@{@"uuid":[UUID getUUID],@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"token":deviceTokenStr,@"env":pushBOX}];
    }else{
           [[NSUserDefaults standardUserDefaults]setValue:deviceTokenStr forKey:@"deviceTokenStr"];
    }

    
}


// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//处理推送的消息 在前台的状态
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    NSLog(@"%@",notification.request.content.userInfo);
    NSDictionary *dic = notification.request.content.userInfo;
    
    [self pushConfig:dic];
    
    if ([dic[@"extra"][@"login_tag"] integerValue] != 1 || [dic[@"extra"][@"login_tag"] integerValue] != 2) {
        
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
}


//点开消息需要做的处理
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self pushConfig:response.notification.request.content.userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLoginInfo" object:response.notification.request.content.userInfo];
    
    completionHandler();
}


//iOS 8.0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    

    
    if (application.applicationState == UIApplicationStateActive) {
        
        //应用程序在前台
        [self pushConfig:userInfo];

        
    }else{
        
        //其他两种情况，一种在后台程序没有被杀死，另一种是在程序已经杀死。用户点击推送的消息进入app的情况处理。
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLoginInfo" object:userInfo];
        
    }
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {



}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //用于验证支付结果
//    [[GameManager sharedManager] handleApplicationWillEnterForeground];
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
      

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

    
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
}

-(void)addLocalNotification{
    
    //定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    if ([self getUserTime] != nil) {
        notification.fireDate= [self getUserTime];//通知触发的时间
        //设置通知属性
        notification.alertBody= NSLocalizedString(@"key104", @"到期通知"); //通知主体
        notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    

}

//推送消息的处理
-(void)pushConfig:(NSDictionary *)dic{
    //登录标识tag (1:授权登录;2:被迫下线)
    if ([dic[@"extra"][@"login_tag"] integerValue] == 1 &&  [dic[@"extra"][@"tag"] integerValue] == 1){
        //授权登录成功
        [keyWindow  hideToastActivity];
        scanViewController * scan = [[scanViewController alloc] init];
        
        scanViewController * VC = (scanViewController *)[self currentViewController];
        
        if ([[NSString stringWithUTF8String:object_getClassName(VC)] isEqual:[NSString stringWithUTF8String:object_getClassName(scan)]])
        {
            
            [VC.userdelgate userloginCount:[UUID getUUID] password:nil telorEmail:nil vip_uuid:dic[@"extra"][@"uuid"]];
            [VC.navigationController popViewControllerAnimated:YES];
        }
        
    }else if([dic[@"extra"][@"login_tag"] integerValue] == 2 &&  [dic[@"extra"][@"tag"] integerValue] == 1){
      //授权登录失败
        [keyWindow  hideToastActivity];
        scanViewController * scan = [[scanViewController alloc] init];
        
        scanViewController * VC = (scanViewController *)[self currentViewController];
        
        if ([[NSString stringWithUTF8String:object_getClassName(VC)] isEqual:[NSString stringWithUTF8String:object_getClassName(scan)]])
        {
            
            [keyWindow makeToast:NSLocalizedString(@"key72", @"授权失败") duration:tipsSeecond position:@"center"];
            
            [VC.navigationController popViewControllerAnimated:YES];
        }
    }else if([dic[@"extra"][@"tag"] integerValue] == 1 && [dic[@"extra"][@"login_tag"] integerValue] == 0){
        //请求授权登录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key73", @"是否同意对方登录") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key17", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //拒绝授权登录
            [self accreditLogin:@{@"vip_uuid":dic[@"extra"][@"uuid"],@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"isDev":pushBOX,@"tag":@"1",@"uuid":[UUID getUUID],@"login_tag":@"2"}];
        }];
        UIAlertAction *action1 = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //同意授权登录
            [self accreditLogin:@{@"vip_uuid":dic[@"extra"][@"uuid"],@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"isDev":pushBOX,@"tag":@"1",@"uuid":[UUID getUUID],@"login_tag":@"1",@"env":pushBOX}];
            
            
            
        }];
        [alert addAction:action1];
        [alert addAction:action];
        
        [self.window.rootViewController  presentViewController:alert animated:YES completion:nil];
    }else if([dic[@"extra"][@"tag"] integerValue] == 2 && [dic[@"extra"][@"login_tag"] integerValue] == 0){
        //单点登录
        vpnLinkViewController * scan = [[vpnLinkViewController alloc] init];
        
        vpnLinkViewController * VC = (vpnLinkViewController *)[self currentViewController];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key74", @"您的账号在别处登录已下线，是否重新登录?") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //走激活接口  重新生成新的UUID 产生新的账户
            [KeyChainStore  deleteKeyData:KEY_USERNAME_TOKEN];
            
            [KeyChainStore  deleteKeyData:KEY_USERNAME_PASSWORD];
            
            if ([[NSString stringWithUTF8String:object_getClassName(VC)] isEqual:[NSString stringWithUTF8String:object_getClassName(scan)]])
            {
                VC.isOpenAd = NO;
                [VC  userCountActiveWithUUID:nil bundle_id:[NSBundle mainBundle].bundleIdentifier Token:nil];
          
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"activeNewCount" object:nil];
                
                [VC.navigationController popToRootViewControllerAnimated:YES];
                
            }
          
        }];
    
        [alert addAction:action];
        
        [self.window.rootViewController  presentViewController:alert animated:YES completion:nil];
        
    }else if([dic[@"extra"][@"tag"] integerValue] == 3){
        //fullReduction,discount,immReduce,send
        
        packageViewController * package = [[packageViewController alloc] init];
        rootNavViewController *nav = [[rootNavViewController alloc]init];
        [nav  addChildViewController:package];
        
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
//    }else if([dic[@"extra"][@"tag"] integerValue] == 4){
//        //discount
//    }else if([dic[@"extra"][@"tag"] integerValue] == 5){
//        //immReduce
//    }else if([dic[@"extra"][@"tag"] integerValue] == 6){
//        //send
    }
}

//获取Window当前显示的ViewController
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}


#pragma mark 授权登录 发送消息
-(void)accreditLogin:(NSDictionary *)dic{
    
    NSString *URL = [rootUrl stringByAppendingString:pushSendUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        str = [JoDess decode:str key:keyDES];
        NSLog(@"成功%@",str);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败:%@",error);
        
    }];
}



#pragma mark today页面的切换处理

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
 
    if ([url.absoluteString hasPrefix:@"App"]) {
        
        if ([url.absoluteString hasSuffix:@"routeList"]) {
            NSLog(@"线路");
            rootNavViewController *nav = [[rootNavViewController alloc]init];
            rountChooseViewController *rount = [[rountChooseViewController alloc]init];
            [nav  addChildViewController:rount];
    
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        
        if ([url.absoluteString hasSuffix:@"connect"]) {
            NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
            NSString *str = [share  valueForKey:@"connectToday"];
            
            if (str.length > 0) {
                
                NSDictionary *dic =@{@"state":str};
                NSNotification *notification =[NSNotification notificationWithName:@"todayNotification" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

            }
        }
    }
    return YES;
}

#pragma mark deviceToken（推送deviceToken存储）
-(void)requsetPostWithUrl:(NSString *)url  parameters:(NSDictionary *)dic{
    
    NSString *URL = [rootUrl stringByAppendingString:url];
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSLog(@"成功%@",str);
        
        if ([[str jsonDictionary][@"error_code"] integerValue] != 0) {
            [[NSUserDefaults standardUserDefaults]setValue:dic[@"token"] forKey:@"deviceTokenStr"];
          
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [[NSUserDefaults standardUserDefaults]setValue:dic[@"token"] forKey:@"deviceTokenStr"];
        NSLog(@"失败%@",error);
    }];
    
}


#pragma mark 获取域名池
NSInteger i = 0;

-(void)getAvailableIP:(NSString *)url{
   
    NSString *URL = [url stringByAppendingString:IPPoolurl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data) {
        //data存在则更新本地的域名池
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (str != nil) {
            str = [JoDess  decode:str key:keyDES];
            NSDictionary *dic = [str jsonDictionary];
            NSLog(@"域名池%@",dic);
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"ipLoop"];
            [[NSUserDefaults standardUserDefaults]setValue:url forKey:@"ip"];
            self.isConect = YES;
            self.bolgConnect = YES;
        }

    }else{
        //取本地的域名池中可用的域名使用
        NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"ipLoop"][@"ips"];
        if (i < arr.count && self.isConect == NO){
            NSString *urlStr = [NSString stringWithFormat:@"http://%@",arr[i]];
            i++;
            [self getAvailableIP:urlStr];
        }else if(self.isConect == NO){
            //博客中取数据
            NSString *blogurl = [[NSUserDefaults standardUserDefaults]objectForKey:@"ipLoop"][@"blog"];
            NSArray *contentArr = [self decodeContent:blogurl];
            for (NSDictionary *dic in contentArr) {
                if (self.isConect == YES) {
                    return;
                }
                [self getAvailableIP:[NSString stringWithFormat:@"%@",dic[@"LinkUrl"]]];
            }
            
        }
       
        else if(self.bolgConnect == NO){
            //text取数据
            NSString *txturl = [[NSUserDefaults standardUserDefaults]objectForKey:@"ipLoop"][@"txt"];
            NSArray *contentArr = [self decodeContent:txturl];
            for (NSDictionary *dic in contentArr) {
                if (self.isConect == YES) {
                    return;
                }
                [self getAvailableIP:[NSString stringWithFormat:@"%@",dic[@"LinkUrl"]]];
            }
        }
    }
}

//解密文本的内容
-(NSArray *)decodeContent:(NSString *)str{
    
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:nil];
    NSRange startRange = [string rangeOfString:@"........#######"];
    NSRange endRange = [string rangeOfString:@"#######......."];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [string substringWithRange:range];
    NSString *strUrl = [result stringByReplacingOccurrencesOfString:@"<wbr>" withString:@""];
    
    NSData *nsdata = [[NSData alloc]initWithBase64EncodedString:[desFile decryptWithText:strUrl] options:0];
    NSString *stringData = [[NSString alloc]initWithData:nsdata encoding:NSUTF8StringEncoding];
    
    NSArray *arr = [stringData jsonArray];
    
    return arr;
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma Mark获取用户到期时间
-(NSDate *)getUserTime{
//   userTime 到期时间key
//  user_type  用户类型
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTime"];
    if (str != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *enddate = [formatter dateFromString:str];
        NSDate *startDate = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        // 3.利用日历对象比较两个时间的差值
        NSDateComponents *cmps = [calendar components:type fromDate:startDate toDate:enddate options:0];
        // 4.输出结果
        NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
        
    
        if (cmps.day == 5 && cmps.hour == 0 && cmps.minute == 0 && cmps.second == 0 && cmps.year == 0 && cmps.month == 0) {
          
            return startDate;
        }
    }
    
    return nil;
}

#pragma mark 启动广告图
-(void)imgTapLink:(NSDictionary *)dic{
    
    
    adViewController * package = [[adViewController alloc] init];
    rootNavViewController *nav = [[rootNavViewController alloc]init];
    [nav  addChildViewController:package];
    package.adURL = dic;
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
}
@end

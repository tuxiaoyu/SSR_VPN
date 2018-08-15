//
//  vpnLinkViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/13.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "vpnLinkViewController.h"
#import "itemView.h"
#import "JSONUtils.h"
#import "UUID.h"
#import "JoDess.h"
#import <AFNetworking/AFNetworking.h>
#import "routeModel.h"
#import "rountChooseViewController.h"
#import "packageViewController.h"

#import "SHVPN-Swift.h"

#import "JSONUtils.h"
#import <NetworkExtension/NetworkExtension.h>
#import "listModel.h"
#import "userCenterViewController.h"
#import "adViewController.h"
#import "scanViewController.h"
#import "Global.h"
#import "userModel.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "adView.h"

#import "openAdViewController.h"

#import "ConnectVPNManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "STDPingServices.h"
#import "paomaView.h"
#import "popOutView.h"
@interface vpnLinkViewController ()<jumpDelegate,routeDelegate,userLoginDelegate,buySuccessDelgate,SDCycleScrollViewDelegate,removeViewDelegate,userCountLoginDelegate>{
     OSStatus statuss;

}

//ping值获取用的
@property (nonatomic, strong) STDPingServices * pingServices;
//线路view
@property(nonatomic,strong)itemView *routeView;
//购买套餐
@property(nonatomic,strong)itemView *packageView;
//有效期限
@property(nonatomic,strong)itemView *timeLimitedView;
//免费时长
@property(nonatomic,strong)itemView  *freetimeView;
@property(nonatomic,strong)UILabel  *qqlabel;
//线路模型
//@property(nonatomic,strong)routeModel  *model;

@property(nonatomic,copy)NSString *availableTime;
//连接的国家code
@property(nonatomic,copy)NSString *countryLink;

@property(nonatomic,strong)listModel *lineModel;

@property(nonatomic,strong)UIImageView *openView;
//用户信息
@property(nonatomic,strong)userModel *usermodel;

@property(nonatomic,strong)NSMutableArray *allRouteArray;
//广告轮播界面
@property(nonatomic,strong)SDCycleScrollView *adScrollView;
//存放广告
@property(nonatomic,strong)NSMutableArray *adArray;
//广告展示的界面
@property(nonatomic,strong)adView *adScanView;

@property(nonatomic,assign)NSInteger   payTypeInt;
//是否显示协议(1为显示)
@property(nonatomic,assign)NSInteger   isShowProtocal;

@property(nonatomic,copy)NSString *protocol;

@property(nonatomic,copy)NSString *service;
    
@property(nonatomic,copy)NSString *linkUrl;

    @property(nonatomic,copy)NSString *openAdUrl;
@end

@implementation vpnLinkViewController

#pragma mark 检测用户是否打开通知功能
-(BOOL)isMessageNotificationServiceOpen{
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            return NO;
        }else{
           return YES;
        }
    }else{
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            return  NO;
        }else{
           return YES;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault ];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //如果用户未打开通知 提示用户打开
    if ([self isMessageNotificationServiceOpen] == NO) {
       [self openNotificationSetting];
    }
    
    if ([UUID getUUID]) {
        [self  getTokenData];
    }else{
        [self userCountActiveWithUUID:[UUID getUUID] bundle_id:[[NSBundle mainBundle] bundleIdentifier] Token:[UUID getToken]];
    }
    
}

- (void)viewDidLoad {
     [super viewDidLoad];
    
    

    
     [self getNeedRouteInfo];
    //广告
    [self getPaomadengData];
     [[Manager sharedManager] setIsShut:true];
    
    
    //获取分流文件
    [self getShutConfige];
    //导航栏设置
    [self navSetting];
    
    //设置背景图片
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"home_backgroud"];
    [self.view insertSubview:imageView atIndex:0];
    
    
    [self centerView];
    
    [self bottomView];
    
    //广告数据
    [self getAdData];
    
    //ss连接方式的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVPNStatusAndUI:) name:@"vpnStatusNotification" object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseLineInfo:) name:@"dataChangeNotification" object:nil];
    
    //today的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getConnect) name:@"todayNotification" object:nil];
    
    //push通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushLoginCount:) name:@"pushLoginInfo" object:nil];
    
    //挤下线后不重新登录（走激活）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActiveNewCount) name:@"activeNewCount" object:nil];
    
    [self getAllRouteInfo];
    
   //添加广告页面
    [self.view addSubview:self.adScrollView];
    
    [self getPayType];
    self.isOpenAd = YES;
    
    NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
    [share setObject:@"0" forKey:@"connectState"];
    
//    弹框视图
//    [self popView];
}

#pragma mark 弹框视图
-(void)popView{
    popOutView *pop = [[popOutView alloc]initWithFrame:CGRectMake(50 * KWidth_Scale, 100 * KHeight_Scale, kWidth * 2/3, kHeight * 1.5/3)];
    pop.center = self.view.center;
    [self.view addSubview:pop];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linkAction2:)];
    [pop addGestureRecognizer:tap];
}
#pragma mark 重新登录

-(void)Login:(NSNotification *)center{
    
    [self userlogin:center.object[@"extra"][@"uuid"] password:nil telorEmail:nil vip_uuid:center.object[@"extra"][@"vip_uuid"]];
}

#pragma mark 挤下线后走不登录激活
-(void)ActiveNewCount{
    self.isOpenAd = NO;
    [self userCountActiveWithUUID:nil bundle_id:[NSBundle mainBundle].bundleIdentifier Token:nil];
}

#pragma mark 推送的授权登录和账号下线处理
-(void)pushLoginCount:(NSNotification *)center{
    NSDictionary *dic = center.object;
    //登录标识tag (1:授权登录;2:被迫下线)
    if([dic[@"extra"][@"tag"] integerValue] == 1 && [dic[@"extra"][@"login_tag"] integerValue] == 0){
        //请求授权登录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key72", @"是否同意对方登录") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key17", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //拒绝授权登录
            [self accreditLogin:@{@"vip_uuid":dic[@"extra"][@"uuid"],@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"isDev":pushBOX,@"tag":@"1",@"uuid":[UUID getUUID],@"login_tag":@"2"}];
        }];
        UIAlertAction *action1 = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //同意授权登录
            [self accreditLogin:@{@"vip_uuid":dic[@"extra"][@"uuid"],@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"isDev":pushBOX,@"tag":@"1",@"uuid":[UUID getUUID],@"login_tag":@"1"}];
  
        }];
        [alert addAction:action1];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([dic[@"extra"][@"tag"] integerValue] == 2){
        //单点登录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key74", @"您的账号在别处登录已下线，是否重新登录?") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [KeyChainStore deleteKeyData:KEY_USERNAME_PASSWORD];
            [KeyChainStore deleteKeyData:KEY_USERNAME_TOKEN];
            //走激活接口  重新生成新的UUID 产生新的账户
            self.isOpenAd = NO;
            [self userCountActiveWithUUID:nil bundle_id:[NSBundle mainBundle].bundleIdentifier Token:nil];
            
        }];
        
        [alert addAction:action];
        
        [self  presentViewController:alert animated:YES completion:nil];
        
    }
    
}

#pragma mark 数据请求
-(void)getData{
    
    //获取连接线路信息
 
    [self getNeedRouteInfo];
    

        //用户 激活
    [self userCountActiveWithUUID:[UUID getUUID] bundle_id:[[NSBundle mainBundle] bundleIdentifier] Token:[UUID getToken]];

   
}



//获取需要连接的线路
-(void)getNeedRouteInfo{
    
    NSDictionary *data = [[NSUserDefaults standardUserDefaults]valueForKey:@"lineInfo"];
    [self.lineModel setValuesForKeysWithDictionary:data];
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"connectType"];
    //如果本地有选择国家线路的数据
    if (self.lineModel.area_code.length > 0) {
        
        if (str.length == 0 ) {
            
            if ([self.lineModel.type isEqualToString:@"vip"]) {
                
                [self getVpnMessageWithType:@"vip_area" area:self.lineModel.area_code  protocolType:@"ssr" appType:appKind];
            }else{
                [self getVpnMessageWithType:@"area" area:self.lineModel.area_code  protocolType:@"ssr" appType:appKind];
            }
        }
    }else{
        
            
            [self getVpnMessageWithType:@"random" area:nil protocolType:@"ssr" appType:appKind];
        
    }
}
    
#pragma mark VPN连接状态的检测
-(void)updateVPNStatusAndUI:(NSNotification *)notification{
    
    
     NSString *status = notification.userInfo[@"status"];
    
     NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
    [share setObject:@"1" forKey:@"connectState"];
    
    if ([status isEqualToString:@"on"]){
      //连接成功
        [self connectAnimation];
        [share setObject:@"1" forKey:@"connectState"];
        
        routeModel*model = [ConnectVPNManager sharedManager].currentRouteModel;
        
        [self getPingWith:model.vps_addr AndIsSuccess:YES];
        

    }
    
    if ([status isEqualToString:@"off"]){
      //未连接
        [self.openView stopAnimating];
        [share setObject:@"0" forKey:@"connectState"];
        self.openView.image = [UIImage imageNamed:@"button_normal"];
    }
    
    if ([status isEqualToString:@"connecting"]){
        
         [share setObject:@"1" forKey:@"connectState"];
     //连接中
        [self connectingAnimation];
        
        
    }
    if ([status isEqualToString:@"disconnecting"]){
         [share setObject:@"0" forKey:@"connectState"];
    }
    
}
#pragma mark 开关按钮 线路选择 界面
-(void)centerView{

    paomaView *label = [[paomaView alloc]initWithFrame:CGRectMake(40 * KWidth_Scale, 65 * KHeight_Scale, kWidth - 80 * KWidth_Scale, 30 * KHeight_Scale)];
    self.qqlabel = label.customLab;
    [self.view addSubview:label];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linkAction:)];
    [label addGestureRecognizer:tap1];
    //连接按钮背景view
    self.openView = [[UIImageView alloc]init];
    self.openView.image = [UIImage imageNamed:@"button_normal"];
    [self.view addSubview:self.openView];
    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(80 * KHeight_Scale);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150 * KWidth_Scale));
        make.height.equalTo(@(150 * KWidth_Scale));
    }];
    self.openView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(donghua:)];
    [self.openView addGestureRecognizer:tap];
    
 
    
    
    UIView  * vpnLineChoose = [[UIView alloc]init];
    vpnLineChoose.backgroundColor = [UIColor whiteColor];
    
    vpnLineChoose.layer.masksToBounds = YES;
    vpnLineChoose.layer.cornerRadius = 10;
    
    [self.view addSubview:vpnLineChoose];
    [vpnLineChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(100*KHeight_Scale);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(40 *KHeight_Scale));
        make.width.equalTo(@(kWidth/2));
    }];
    //线路选择
    self.routeView = [[itemView alloc]init];
    
    if (self.lineModel.area_code.length > 0) {
        
        self.routeView.titleLabel.text = self.lineModel.area_name;
        [self.routeView.imgView sd_setImageWithURL:[NSURL URLWithString:self.lineModel.flag]];
        
    }else{
        
       self.routeView.titleLabel.text = NSLocalizedString(@"key11", @"默认");
    }
    
    //页面跳转代理
    self.routeView.delegate = self;
    
    self.routeView.tagNum = 10001;
    self.routeView.moreButton.tag = 10001;
    
    [self.routeView.moreButton setImage:[UIImage imageNamed:@"per_button_normal"] forState:UIControlStateNormal];
    [vpnLineChoose addSubview:self.routeView];
    
    [self.routeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15 * KWidth_Scale));
        make.right.equalTo(@(-15 * KWidth_Scale));
        make.top.equalTo(@(5 * KHeight_Scale));
        make.bottom.equalTo(@(-5 * KHeight_Scale));
    }];
    
}

-(void)linkAction2:(UIGestureRecognizer *)sender{
    
    if([self.openAdUrl isEqualToString:@"buy"] ){
        packageViewController *package = [[packageViewController alloc]init];
        package.buyDelegate = self;
        package.model = self.usermodel;
        package.payTypeInt = self.payTypeInt;
        package.isShowProtocal = self.isShowProtocal;
        
        package.protocol = self.protocol;
        package.service = self.service;
        
        [self.navigationController pushViewController:package animated:YES];
    }else{
        
        adViewController *ad = [[adViewController alloc]init];
        ad.adURL = self.openAdUrl;
        [self.navigationController pushViewController:ad animated:YES];
    }
    
}
    
-(void)linkAction:(UIGestureRecognizer *)sender{

    if([self.linkUrl isEqualToString:@"buy"] ){
        packageViewController *package = [[packageViewController alloc]init];
        package.buyDelegate = self;
        package.model = self.usermodel;
        package.payTypeInt = self.payTypeInt;
        package.isShowProtocal = self.isShowProtocal;
        
        package.protocol = self.protocol;
        package.service = self.service;
        
        [self.navigationController pushViewController:package animated:YES];
    }else{
        
        adViewController *ad = [[adViewController alloc]init];
        ad.adURL = self.linkUrl;
        [self.navigationController pushViewController:ad animated:YES];
    }
    
}
    
#pragma mark 点击广告轮播回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if([self.linkUrl isEqualToString:@"buy"] ){
        packageViewController *package = [[packageViewController alloc]init];
        package.buyDelegate = self;
        package.model = self.usermodel;
        package.payTypeInt = self.payTypeInt;
        package.isShowProtocal = self.isShowProtocal;
        
        package.protocol = self.protocol;
        package.service = self.service;
        
        [self.navigationController pushViewController:package animated:YES];
    }else{
        
        adViewController *ad = [[adViewController alloc]init];
        ad.adURL = self.adArray[index];
        [self.navigationController pushViewController:ad animated:YES];
    }
  
    
}
#pragma mark 导航栏的设置
-(void)navSetting{
    self.navigationItem.title = NSLocalizedString(@"key1", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"key2", nil) style:UIBarButtonItemStyleDone target:self action:@selector(more)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav"] style:UIBarButtonItemStyleDone target:self action:@selector(userCenter)];
}

#pragma mark 界面UI搭建
-(void)bottomView{
    
    __weak typeof(self) weakSelf = self;
    UIView *bgview = [[UIView alloc]init];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = 10;
    [self.view addSubview: bgview];
    
    [bgview  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15*KWidth_Scale));
        make.right.equalTo(@(-15 * KWidth_Scale));
        make.bottom.equalTo(@(-30 * KHeight_Scale));
        make.height.equalTo(@(150 * KHeight_Scale));
    }];

    //购买套餐view
    [bgview  addSubview:self.packageView];
    
    self.packageView.imgView.image = [UIImage imageNamed:@"Home_icon_time"];
    [self.packageView.moreButton setImage:[UIImage imageNamed:@"per_button_normal"] forState:UIControlStateNormal];
    
    self.packageView.titleLabel.text =NSLocalizedString(@"key3", nil);
    if (self.usermodel) {
        self.packageView.detailLbel.text = self.usermodel.user_type;
    }
    //页面跳转代理
    self.packageView.delegate = self;
    self.packageView.moreButton.tag = 10002;
    self.packageView.tagNum = 10002;
    [self.packageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5 * KHeight_Scale));
        make.left.equalTo(@(10 * KWidth_Scale));
        make.right.equalTo(@(-10 * KWidth_Scale));
    }];
    //有效时长
    [bgview addSubview:self.timeLimitedView];
    self.timeLimitedView.imgView.image = [UIImage imageNamed:@"Home_icon_ontrial"];
    [self.timeLimitedView.moreButton setImage:[UIImage imageNamed:@"per_button_normal"] forState:UIControlStateNormal];
    self.timeLimitedView.titleLabel.text = NSLocalizedString(@"key4", nil);
    if (self.usermodel) {
        self.timeLimitedView.detailLbel.text = self.usermodel.user_expiration_date;
    }
    self.timeLimitedView.moreButton.hidden = YES;
    
    [self.timeLimitedView.detailLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10 * KWidth_Scale));
    }];
    
    [self.timeLimitedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.packageView.mas_left);
        make.right.equalTo(weakSelf.packageView.mas_right);
        make.top.equalTo(weakSelf.packageView.mas_bottom);
        make.height.equalTo(weakSelf.packageView.mas_height);
//        make.bottom.equalTo(bgview.mas_bottom).with.offset(-5 * KHeight_Scale);
    }];
    
    [self.view layoutIfNeeded];
    //免费试用
    [bgview addSubview:self.freetimeView];
    //页面跳转代理
    self.freetimeView.delegate = self;
    self.freetimeView.moreButton.tag = 10003;
    self.freetimeView.tagNum = 10003;

    self.freetimeView.imgView.image = [UIImage imageNamed:@"Home_icon_package"];
//    [self.freetimeView.moreButton setImage:[UIImage imageNamed:@"per_button_normal"] forState:UIControlStateNormal];

    self.freetimeView.titleLabel.text = NSLocalizedString(@"key5", nil);
//    self.freetimeView.detailLbel.text = NSLocalizedString(@"key12", nil);
    [self.freetimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.packageView);
        make.trailing.equalTo(weakSelf.packageView);
        make.top.equalTo(weakSelf.timeLimitedView.mas_bottom);
        make.bottom.equalTo(bgview.mas_bottom).with.offset(-5 * KHeight_Scale);
        make.height.equalTo(weakSelf.packageView.mas_height);
    }];
    
    UISwitch *switchView = [[UISwitch alloc]init];
    [self.freetimeView  addSubview:switchView];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10 * KHeight_Scale));
        make.width.equalTo(@(50 * KWidth_Scale));
        make.centerY.equalTo(weakSelf.freetimeView.mas_centerY);
        
    }];
    switchView.on = NO;
    
    [switchView addTarget:self action:@selector(patternChange:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark 页面跳转代理的实现
-(void)buttonJump:(NSInteger)sender{
    
    switch (sender) {
        case 10001:{
            //线路选择
            rountChooseViewController *rount = [[rountChooseViewController alloc]init];
            rount.Delegate = self;
            
            rount.usermoder = self.usermodel;
            
            [self.navigationController pushViewController:rount animated:YES];
            NSLog(@"10001");
        }
            break;
        case 10002:{
            //套餐选择
            packageViewController *package = [[packageViewController alloc]init];
            package.buyDelegate = self;
            package.model = self.usermodel;
            package.payTypeInt = self.payTypeInt;
            package.isShowProtocal = self.isShowProtocal;
            
            package.protocol = self.protocol;
            package.service = self.service;
            
            [self.navigationController pushViewController:package animated:YES];
            NSLog(@"10002");
        }
            break;
        case 10003:
            //使用时长
            NSLog(@"10003");
            break;
        default:
            break;
    }
}

//选择线路（today中跳转）
-(void)chooseLineInfo:(NSNotification *)center {
    
    listModel *model = center.userInfo[@"data"];
    [self chooseRouteInfo:model];
    
}

//代理事件(线路选择)
-(void)chooseRouteInfo:(listModel *)model{
    
    self.routeView.titleLabel.text = model.area_name;
    self.countryLink = model.area_code;
    
        if ([model.type isEqualToString:@"vip"] ) {
            [self getVpnMessageWithType:@"vip_area" area:model.area_code protocolType:@"ssr" appType:appKind];
        }else{
            
            [self getVpnMessageWithType:@"area" area:model.area_code protocolType:@"ssr" appType:appKind];
        }
        
    
}

#pragma mark  扫一扫
-(void)more{
    scanViewController *coder = [[scanViewController alloc]init];
    coder.style = [self OnStyle];
    coder.isOpenInterestRect = YES;
    coder.libraryType = [Global sharedManager].libraryType;
    coder.scanCodeType = [Global sharedManager].scanCodeType;
    coder.isNeedScanImage = YES;
    coder.userdelgate = self;
    [self.navigationController pushViewController:coder animated:YES];
}

#pragma mark 用户中心
-(void)userCenter{
    
    userCenterViewController *center = [[userCenterViewController alloc]init];
    center.usermodel = self.usermodel;
    center.delegate = self;
    [self.navigationController pushViewController:center animated:YES];
}


#pragma mark 用户中心通过账号登录  代理方法
-(void)userLoginByCount:(NSString *)count passsword:(NSString *)psd{
   
    [self userlogin:nil password:psd telorEmail:count vip_uuid:nil];
}


#pragma mark 二维码扫描
- (LBXScanViewStyle*)OnStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    UIImage *imgPartNet = [UIImage imageNamed:@"scan_line"];
    style.animationImage = imgPartNet;
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    return style;
}

//获取当前的时间
-(BOOL)getCurrentTime{
    //有效期转化为时间戳
    NSDateFormatter  *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:self.usermodel.user_expiration_date];
    
    long  time = [date timeIntervalSince1970] * 1000;
    
    //获取当前的时间戳
    long current = [[NSDate date]  timeIntervalSince1970] * 1000;
    
    if (time >= current) {
        
        return YES;
    }
    return NO;
}


#pragma mark 按钮响应事件
-(void)donghua:(UIGestureRecognizer *)sender{

    if ([NetWorkReachability internetStatus] == NO) {

       //未联网不能点击连接
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key9", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self  presentViewController:alert animated:YES completion:nil];

    }else if([self getCurrentTime] == NO){

       

        [[Manager sharedManager] stopVPN];
       
        //试用期过期  购买套餐
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key49", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key17", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key18", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            packageViewController *package = [[packageViewController alloc]init];
            package.buyDelegate = self;
            package.model = self.usermodel;
            [self.navigationController pushViewController:package animated:YES];
        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
    }else{

        [self ssLink];

    }
}


//ss配置
-(void)ssConfig{

    Proxy *prox =  [[Proxy alloc]init];

    routeModel*model = [ConnectVPNManager sharedManager].currentRouteModel;

//    prox.host = model.vps_addr;
//    prox.password =model.ss_pass;
////    prox.name = model.vps_username;
//    prox.authscheme = model.encrypt;
//    prox.port = model.port.integerValue;
//    prox.ssrProtocol = model.ss_protocol;
//    prox.ssrObfs = model.ss_mix;
//    prox.typeRaw = @"SSR";
    
    prox.typeRaw = @"SSR";
    prox.host = @"45.79.98.134";
    prox.password = @"CespiNpVsoi2016";
    prox.name = @"ipsEC@ioS%vPn";
    prox.authscheme = @"chacha20";
    prox.ssrObfs = @"tls1.2_ticket_auth";
    prox.ssrProtocol = @"origin";
    prox.port = 22610;
    [[Manager sharedManager] setPro:prox];
    
}


#pragma mark ss 连接方式
-(void)ssLink{
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"Alert"]) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Alert"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"安装VPN配置文件" message:@"亲爱的用户您好，即将为您安装VPN配置文件，这个操作不会产生任何的安全问题，它仅仅是为了能够让vpn软件正常使用，在点击确定后，请继续点击Allow按钮，并根据苹果设备的提示完成安装。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //ss链接
            [[Manager sharedManager] switchVPN:^(NETunnelProviderManager * manager, NSError * error ) {
                NSLog(@"ss连接问题%@",error.description);
            }];
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        //ss链接
        [[Manager sharedManager] switchVPN:^(NETunnelProviderManager * manager, NSError * error ) {
            NSLog(@"ss连接问题%@",error.description);
        }];
    }
}

#pragma mark是否分流
-(void)patternChange:(UISwitch *)sender{
    
    
    if (sender.isOn == YES) {
        [[Manager sharedManager]setIsShut:true];
    }else{
        [[Manager sharedManager]setIsShut:false];
    }
    
    
}

//数据请求
#pragma mark 获取线路
-(void)getVpnMessageWithType:(NSString *)type  area:(NSString *)area  protocolType:(NSString *)protocolType  appType:(NSString *)appKinds{
    
    NSString *urlString = [rootUrl stringByAppendingString:routeInfoUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:type forKey:@"type"];
    [dic setValue:area forKey:@"area_code"];
    [dic setValue:protocolType forKey:@"connect_type"];
    [dic setValue:appKinds forKey:@"area_diff"];
    __weak typeof(self) weakSelf = self;
    [manger POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       NSString *str = [JoDess decode:string key:keyDES];
  
        NSDictionary *dic = [str jsonDictionary];
        if ([dic[@"error_code"] integerValue] == 0) {
            dic = dic[@"data"];
            [[ConnectVPNManager sharedManager].currentRouteModel setValuesForKeysWithDictionary:dic];
            [weakSelf ssConfig];  

            //today直接链接
            NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
            [share setObject:str  forKey:@"routeDetail"];
            [share synchronize];
            
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"routeModel"];
           
            NSLog(@"线路信息：%@",dic);
        }
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败%@",error);
        
        [weakSelf  getCoachRoute];
    }];
           
}

-(void)getCoachRoute{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRoute"];
    //2.初始化解归档对象
    if(data != nil && data.length > 0){
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        //3.解归档
        self.allRouteArray = [unarchiver decodeObjectForKey:@"allRouteArray"];
        
        //4.完成解归档
        [unarchiver finishDecoding];
        
        //获取缓存数据
     
        NSInteger num = arc4random()%[self.allRouteArray[0] count];
        [ConnectVPNManager sharedManager].currentRouteModel = self.allRouteArray[0][num];
    }
}

#pragma mark 用户激活
-(void)userCountActiveWithUUID:(NSString *)uuID  bundle_id:(NSString *)bundle_ID Token:(NSString *)token{
   
    NSString *urlString = [rootUrl stringByAppendingString:userActiveUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic setValue:[[NSBundle mainBundle]bundleIdentifier] forKey:@"bundle_id"];

    if (uuID.length > 0) {
       [dic setValue:uuID forKey:@"uuid"];
        if (token != nil) {
            [dic setValue:token forKey:@"token"];
        }

    }
//    [dic setValue:@"0EA5ABF9-333C-3E61-AA81-680A56329805" forKey:@"uuid"];
    __weak typeof(self) weakSelf = self;
    [manger POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if(dic.allKeys.count == 1){
            [keyWindow makeToast:NSLocalizedString(@"key103", @"激活成功") duration:tipsSeecond position:@"center"];
        }
        
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        //today 中显示的数据
        NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
        [share setObject:str forKey:@"userInfo"];
        
        [share synchronize];
        
        if ( dic[@"error_code"] != nil && [dic[@"error_code"] integerValue] == 0) {
            
                weakSelf.usermodel = [[userModel alloc]init];
                [weakSelf.usermodel setValuesForKeysWithDictionary:dic[@"data"]];
                //uuid保存到钥匙串中
                [KeyChainStore save:KEY_USERNAME_PASSWORD data:dic[@"data"][@"uuid"]];
            
                //数据缓存
                [self coachDatawithkey:@"user" dataValue:weakSelf.usermodel dataKey:@"usermodel"];
        
                //存deviceToken（推送）
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTokenStr"] length] > 0 && [[UUID getUUID] length] > 0) {
                    
                    [self requsetPostWithUrl:deviceTokenUrl parameters:@{@"uuid":dic[@"data"][@"uuid"],@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTokenStr"],@"env":pushBOX}];
                    
                }
        

                    [[NSUserDefaults standardUserDefaults] setValue:dic[@"data"][@"user_type"] forKey:@"user_type"];
                    weakSelf.packageView.detailLbel.text = dic[@"data"][@"user_type"];
                    weakSelf.timeLimitedView.detailLbel.text = dic[@"data"][@"user_expiration_date"];
            
                    [[NSUserDefaults standardUserDefaults] setValue:dic[@"data"][@"user_expiration_date"] forKey:@"userTime"];
            
                    weakSelf.availableTime = dic[@"data"][@"user_expiration_date"];
            
            
        }else if([dic[@"error_code"] integerValue] == 10030){
            //账号在别处登录
            [self acountloginOtherPlace];
            
        }else{
            
            [keyWindow makeToast:NSLocalizedString(@"key52", nil) duration:tipsSeecond position:@"center"];
        }
        
        NSLog(@"激活-%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败%@",error);
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        
        if (data.length > 0 && data != nil) {
            //2.初始化解归档对象
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            
            //3.解归档
            self.usermodel = [unarchiver decodeObjectForKey:@"usermodel"];
            
            //4.完成解归档
            [unarchiver finishDecoding];
            weakSelf.timeLimitedView.detailLbel.text = self.usermodel.user_expiration_date;
            weakSelf.packageView.detailLbel.text = self.usermodel.user_type;
        }else{
            
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key95", @"加载数据") preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key95", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self getData];
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }

       
    }];
}


-(void)userActive{
    [self userCountActiveWithUUID:[UUID getUUID] bundle_id:[NSBundle mainBundle].bundleIdentifier Token:[UUID getToken]];
}

-(void)removeAdView{
    
    [self.adScanView removeFromSuperview];
}

#pragma mark 用户登录
-(void)userlogin:(NSString *)uuid password:(NSString *)psd telorEmail:(NSString *)tel vip_uuid:(NSString *)vipuuid{
    [keyWindow makeToastActivity];
    
    NSString *urlString = [rootUrl stringByAppendingString:vipLoginUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic setValue:[NSBundle mainBundle].bundleIdentifier forKey:@"bundle_id"];
    
    [dic setValue:uuid forKey:@"uuid"];
   
    [dic setValue:psd forKey:@"password"];
    
    [dic setValue:vipuuid forKey:@"vip_uuid"];
    [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTokenStr"] forKey:@"free_token"];
    if ([tel containsString:@"@"]) {
        [dic setValue:tel forKey:@"email"];
    }else if(![tel containsString:@"@"] && tel.integerValue > 10000000000){
        [dic setValue:tel forKey:@"phone"];
    }else{
        [dic setValue:tel forKey:@"user_name"];
    }
    __weak typeof(self) weakSelf = self;
    
    [manger POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        //today中显示的数据
        NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
        
        [share setObject:str forKey:@"userInfo"];
        
        [share synchronize];
        
        if ([dic[@"error_code"] integerValue] == 0) {
            [keyWindow makeToast:NSLocalizedString(@"key57", nil) duration:tipsSeecond position:@"center"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.usermodel setValuesForKeysWithDictionary:dic[@"data"]];
            });
            
            
            weakSelf.packageView.detailLbel.text = @"vip";
            NSDictionary *dict = dic[@"data"];
            NSString  *time = [NSString stringWithFormat:@"%@",dict[@"user_expiration_date"]];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
            weakSelf.timeLimitedView.detailLbel.text = [formatter stringFromDate:date];
            
            weakSelf.availableTime = dic[@"data"][@"user_expiration_date"];
            
            self.usermodel.user_type = @"vip";
            self.usermodel.goods_name = dic[@"data"][@"goods_name"];
            //存 UUID 替换激活的UUID
            [KeyChainStore save:KEY_USERNAME_PASSWORD data:dic[@"data"][@"vip_uuid"]];
            
            if ([dic[@"data"][@"token"] length] > 0) {
                
              [KeyChainStore save:KEY_USERNAME_TOKEN data:dic[@"data"][@"token"]];
            }
            
        }else{
            //登录失败提示
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key52", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self  presentViewController:alert animated:YES completion:nil];
        }
        [keyWindow  hideToastActivity];
        NSLog(@"登录-%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [keyWindow  hideToastActivity];
        NSLog(@"失败%@",error);
    }];
    
}

//连接成功动画
-(void)connectAnimation{

    [self.openView stopAnimating];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        self.openView.image = [UIImage imageNamed:[NSString stringWithFormat:@"button_com_%d",i+1]];
        [arr1 addObject:self.openView.image];
    }
    self.openView.animationImages = arr1;
    self.openView.animationDuration = 0.5;
    [self.openView startAnimating];
}


//连接中动画
-(void)connectingAnimation{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        self.openView.image = [UIImage imageNamed:[NSString stringWithFormat:@"button_press_%d",i+1]];
        [arr addObject:self.openView.image];
    }
    self.openView.animationImages = arr;
    self.openView.animationDuration = 0.5;
    [self.openView startAnimating];
    
}

#pragma mark  使用账号登录
-(void)userloginCount:(NSString *)uuid password:(NSString *)psd telorEmail:(NSString *)tel vip_uuid:(NSString *)vipuuid{
   
    [self userlogin:uuid password:psd telorEmail:tel vip_uuid:vipuuid];

}


#pragma mark   购买套餐成功后 刷新页面
-(void)UIRefreshWithToken:(NSString *)token{    
    
    [keyWindow hideToastActivity];
    self.isOpenAd = NO;
    [self  userCountActiveWithUUID:[UUID getUUID] bundle_id:[NSBundle mainBundle].bundleIdentifier Token:token];
    
}


#pragma mark 获取所有线路
-(void)getAllRouteInfo{
    NSString *urlString = [rootUrl stringByAppendingString:getAllrouteUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    NSMutableArray *ikArray = [NSMutableArray array];
    NSMutableArray *ssArray = [NSMutableArray array];
    [manger POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str = [JoDess decode:string key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
    
        if ([dic[@"error_code"] integerValue] == 0) {
            for (NSDictionary *dict in dic[@"list"]) {
                routeModel *model = [[routeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
//                if ([model.vps_connect_type isEqualToString:@"ssr"]) {
                    [ssArray addObject:model];
//                }else{
                    [ikArray addObject:model];
//                }
            }
            [self.allRouteArray addObject:ssArray];
            [self.allRouteArray addObject:ikArray];
            //缓存数据
            [self coachDatawithkey:@"allRoute" dataValue:self.allRouteArray dataKey:@"allRouteArray"];
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)coachDatawithkey:(NSString *)str  dataValue:(id)value  dataKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:str];
#pragma mark  使用归档对数据进行本地保存
    NSMutableData *data = [NSMutableData data];
    //1.初始化
    NSKeyedArchiver *archivier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //2.归档
    [archivier encodeObject:value forKey:key];
    //3.完成归档
    [archivier finishEncoding];
    //4.保存
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:str];
}


#pragma mark deviceToken（授权登录中消息推送）
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

#pragma mark 账号别处登录提示
-(void)acountloginOtherPlace{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key74", @"您的账号在别处登录已下线，是否重新登录?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction  actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [KeyChainStore  deleteKeyData:KEY_USERNAME_TOKEN];
        
        [KeyChainStore  deleteKeyData:KEY_USERNAME_PASSWORD];
        //走激活接口  重新生成新的UUID 产生新的账户
        self.isOpenAd = NO;
        [self userCountActiveWithUUID:nil bundle_id:[NSBundle mainBundle].bundleIdentifier Token:nil];
        
    }];

    [alert addAction:action];
    
    [self  presentViewController:alert animated:YES completion:nil];

}



-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"vpnStatusNotification" object:nil];
    

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"todayNotification" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushLoginInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"activeNewCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"repeatlogin" object:nil];

}
#pragma mark 懒加载

-(SDCycleScrollView *)adScrollView{
    if (_adScrollView == nil) {
        _adScrollView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0,kHeight - 330 * KHeight_Scale, kWidth, 130 * KHeight_Scale) delegate:self placeholderImage:nil];
        _adScrollView.backgroundColor = [UIColor clearColor];
    }
    return _adScrollView;
}

-(itemView *)packageView{
    if (_packageView == nil) {
        _packageView = [[itemView alloc]init];
    }
    
    return _packageView;
}

-(itemView *)timeLimitedView{
    if (_timeLimitedView == nil) {
        _timeLimitedView = [[itemView alloc]init];
    }
    return _timeLimitedView;
}

-(itemView *)freetimeView{
    if (_freetimeView == nil) {
        _freetimeView = [[itemView alloc]init];
    }
    return _freetimeView;
}

-(listModel *)lineModel{
    if (_lineModel == nil) {
        _lineModel = [[listModel alloc]init];
    }
    
    return _lineModel;
}

-(NSMutableArray *)allRouteArray{
    if (_allRouteArray == nil) {
        _allRouteArray = [NSMutableArray array];
    }
    return _allRouteArray;
}


#pragma mark 分流策略文件
-(void)getShutConfige{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * pathUrl = [rootUrl stringByAppendingString:file];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer  serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];

    [manager POST:pathUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {

            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
            [[Manager sharedManager] setVPNConfigeWithConfigString:str];
    }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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

#pragma mark广告接口
-(void)getAdData{
    NSString *str =[rootUrl stringByAppendingString:adUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    NSMutableArray *imgArr = [NSMutableArray array];
    self.adArray = [NSMutableArray array];
    [manager POST:str parameters:@{@"bundle_id":[NSBundle mainBundle].bundleIdentifier} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str  jsonDictionary];
        NSLog(@"广告==%@",dic);
        if (![dic[@"is_open"] isKindOfClass:[NSNull class]]) {
            if ([dic[@"is_open"][@"is_open"] integerValue] == 1) {
                for (NSDictionary *dict in dic[@"advertise"]) {
                    
                    [imgArr addObject:dict[@"image"]];
                    if (dict[@"link"]) {
                        [_adArray addObject:dict[@"link"]];
                    }else{
                        [_adArray  addObject:@"0"];
                    }
                    
                }
            }
        }
        
        
    
        _adScrollView.imageURLStringsGroup = imgArr;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"广告==%@",error);
    }];
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
    NSDictionary *dic = nil;
    if(ip != nil){
     
        if ([self getcarrierName].length > 0) {
            dic = @{@"uuid":[UUID getUUID],@"vpn_ip":ip,@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"is_success":isSuccess,@"user_lan":language,@"operator":[self getcarrierName],@"net":[self networktype],@"protocol":@"SSR",@"ping":ping};
        }else{
            dic = @{@"uuid":[UUID getUUID],@"vpn_ip":ip,@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"is_success":isSuccess,@"user_lan":language,@"operator":@"",@"net":[self networktype],@"protocol":@"SSR",@"ping":ping};
        }
        
    }else{
        
        dic = @{@"0":@(0)};
    }
    
    
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

#pragma mark 获取运营商的名称
-(NSString *)getcarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry = [carrier carrierName];
    return currentCountry;
}


#pragma mark 获取网络环境
-(NSString *)networktype{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *currentNetwork = nil;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
            case 0:
            NSLog(@"No wifi or cellular");
            currentNetwork = @"无服务";
            break;
            
            case 1:
            NSLog(@"2G");
            currentNetwork = @"2G";
            break;
            
            case 2:
            NSLog(@"3G");
            currentNetwork = @"3G";
            break;
            
            case 3:
            NSLog(@"4G");
            currentNetwork = @"4G";
            break;
            
            case 4:
            NSLog(@"LTE");
            currentNetwork = @"LTE";
            break;
            
            case 5:
            NSLog(@"Wifi");
            currentNetwork = @"Wifi";
            break;
            
            
        default:
            break;
    }
    
    return currentNetwork;
}



-(void)openNotificationSetting{
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", @"提示") message:NSLocalizedString(@"key84", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key17", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (!([ConnectVPNManager sharedManager].currentRouteModel.vps_addr.length > 1)) {
            [self getData];
        }
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!([ConnectVPNManager sharedManager].currentRouteModel.vps_addr.length > 1)) {
            [self getData];
        }
      //跳转到 系统设置通知的地方
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma MARK 获取token值
-(void)getTokenData{
    
    NSString *str = [UUID getUUID];
    NSDictionary *dic = @{@"uuid":str};
    
    NSString *URL = [rootUrl stringByAppendingString:getTokenURL];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        if (dic[@"token"] != nil) {
            [KeyChainStore save:KEY_USERNAME_TOKEN data:dic[@"token"]];
        }
        [self userCountActiveWithUUID:[UUID getUUID] bundle_id:[[NSBundle mainBundle] bundleIdentifier] Token:dic[@"token"]];
        NSLog(@"uuid:%@",str);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败:%@",error);
        
    }];
    
}


#pragma mark 支付的类型
-(void)getPayType{
    
    NSString *str = [rootUrl stringByAppendingString:payTypeUrl];
    NSDictionary *dic = @{@"bundle_id":[NSBundle mainBundle].bundleIdentifier};
    // 获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式为json
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    // 发出请求
    [manager POST:str parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [JoDess decode:string key:keyDES];
        NSDictionary *dict = [jsonStr jsonDictionary];
        NSString *str = dict[@"payment"];
        self.isShowProtocal = [dict[@"is_subscri"] integerValue];
        self.payTypeInt = (long)str.integerValue;
        self.protocol = dict[@"Privacy"];
        self.service = dict[@"TOS"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
        
    }];
    
}
    
    
#pragma mark 获取广告信息
-(void)getPaomadengData{
    //获取广告信息
    NSString *urlStr = [rootUrl stringByAppendingString:openAppAdURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    [manager POST:urlStr parameters:@{@"bundle_id":[NSBundle mainBundle].bundleIdentifier} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *data = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [data jsonDictionary];
        if([dic[@"marquee"][@"is_open"] isEqualToString:@"1"]){
            self.qqlabel.text = dic[@"marquee"][@"describe"];
            self.linkUrl = dic[@"marquee"][@"link"];
        }
        self.openAdUrl = dic[@"popout"][@"link"];
        NSLog(@"广告数据：%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
@end

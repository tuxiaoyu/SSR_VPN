//
//  userCenterViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/26.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "userCenterViewController.h"
#import "userCenterTableViewCell.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import "coderViewController.h"
#import "buyListViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "bindTelorEmailViewController.h"
#import <StoreKit/StoreKit.h>
#import "bindTelorEmail.h"
#import "telAndPsdViewController.h"
#import "loginView.h"
#import "tipsView.h"
#import "notificationListViewController.h"
#import <ElvaChatServiceSDK/ECServiceSdk.h>
@class vpnLinkViewController;

@interface userCenterViewController ()<UITableViewDelegate,UITableViewDataSource,refreshCoderDelegate,SKStoreProductViewControllerDelegate,userloginDelegate,tipsdelegate>

@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imgArray;
@property(nonatomic,strong)NSArray *detailArray;

//二维码
@property(nonatomic, strong)CIImage *coderImg;

//
@property(nonatomic,strong)UIImageView *imgView;

//二维码扫描
@property(nonatomic,strong)AVCaptureSession *session;

//分享字段
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *linkUrl;

@property(nonatomic,strong)bindTelorEmail *bindView;

@property(nonatomic,copy)NSString *userType;
@property(nonatomic,copy)NSString *phone;

@property(nonatomic,strong)loginView  *login;
@end

@implementation userCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault ];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    //获取用户的信息
    if ([UUID getUUID]) {
        [self getUserInfo];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = colorRGB(239, 239, 239);
    [self headerView];
    
    [self creatTable];
    //生成含有UUID的二维码
    if ([UUID getUUID]) {
        [self coderAndUUIDwithData:@{@"uuID":[UUID getUUID],
                                     @"bundleID":[NSBundle mainBundle].bundleIdentifier,
                                     @"version":[NSString stringWithFormat:@"%@",self.usermodel.version]
                                     }];
    }
    
    if (self.usermodel.apple_id && self.usermodel.apple_id.length > 0) {
        self.titleArray = @[@[NSLocalizedString(@"key35", nil),NSLocalizedString(@"key36", nil),NSLocalizedString(@"key37", nil),NSLocalizedString(@"key39", nil)],@[NSLocalizedString(@"key38", nil)],@[NSLocalizedString(@"key40", nil),NSLocalizedString(@"key41", nil),NSLocalizedString(@"key42", nil)],@[@"客服",@"消息"]];
    }else{
        self.titleArray = @[@[NSLocalizedString(@"key35", nil),NSLocalizedString(@"key36", nil),NSLocalizedString(@"key37", nil),NSLocalizedString(@"key39", nil)],@[NSLocalizedString(@"key38", nil)],@[NSLocalizedString(@"key40", nil),NSLocalizedString(@"key41", nil)],@[@"客服",@"消息"]];
    }
    
    
    
    if (self.usermodel.user_name) {
        self.userType = self.usermodel.user_name;
    }else{
        self.userType = @"free";
    }
    
    
    if (self.usermodel.phone) {
        self.phone = NSLocalizedString(@"key44", nil);
    }else{
        self.phone = NSLocalizedString(@"key45", nil);
    }
    
    self.detailArray = @[@[self.userType,self.phone,@"",@""],@[@""],@[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],NSLocalizedString(@"key46", nil),NSLocalizedString(@"key46", nil)],@[@"",@""]];
    
    if (self.usermodel.apple_id) {
        self.imgArray = @[@[@"per_icon_state",@"per_icon_security",@"per_icon_modify",@"per_icon_record"],@[@"per_icon_clause"],@[@"per_icon_edition",@"per_icon_share",@"per_icon_score"],@[@"per_icon_clause",@"per_icon_edition"]];
    }else{
        self.imgArray = @[@[@"per_icon_state",@"per_icon_security",@"per_icon_modify",@"per_icon_record"],@[@"per_icon_clause"],@[@"per_icon_edition",@"per_icon_share"],@[@"per_icon_clause",@"per_icon_edition"]];
    }
    
    
    
    
    if ([self.usermodel.user_type isEqualToString:@"vip"] && self.usermodel.phone != nil) {
        //二维码刷新
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshCoder:)];
        
        [self.imgView addGestureRecognizer:tap];
        
    }else if([self.usermodel.user_type isEqualToString:@"vip"] && self.usermodel.phone == nil){
        //未绑定手机号（提示绑定手机号）
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bindTelTips:)];
        
        [self.imgView addGestureRecognizer:tap];
        
    }else{
        
        //通过账户登录
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userLogin)];
        
        [self.imgView addGestureRecognizer:tap];
    }
    
    
    
}

-(void)headerView{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    UIImageView *bgimg = [[UIImageView alloc]init];
    if ([deviceType isEqualToString:@"iPad"]) {
        bgimg.frame = CGRectMake(0, 0, kWidth, kHeight/2.5);
    }else{
        bgimg.frame = CGRectMake(0, 0, kWidth, 200 * KHeight_Scale);
    }
    
    
    
    bgimg.image = [UIImage imageNamed:@"per_Backgroud"];
    bgimg.userInteractionEnabled = YES;
    [self.view addSubview:bgimg];
    
#pragma mark 二维码位置
    self.imgView = [[UIImageView alloc]init];
    self.imgView.userInteractionEnabled = YES;
    self.imgView.image = [UIImage imageNamed:@"per_icon_user"];
    [bgimg addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgimg.mas_centerX);
        make.width.equalTo(@(100 * KWidth_Scale));
        make.height.equalTo(@(100 * KWidth_Scale));
        make.top.equalTo(@(65 * KHeight_Scale));
        make.width.equalTo(self.imgView.mas_height);
        
    }];
    
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    [bgimg addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.top.equalTo(self.imgView.mas_bottom).with.offset(10 * KHeight_Scale);
    }];
    
    if (![self.usermodel.user_type isEqualToString:@"vip"]) {
        tipsLabel.text = NSLocalizedString(@"key100", @"点击登录");
    }else if ([self.usermodel.user_type isEqualToString:@"vip"] && self.usermodel.phone == nil){
        if (self.usermodel.user_name != nil) {
            tipsLabel.text = NSLocalizedString(@"key98", @"请绑定手机号或邮箱");
        }
    }else if([self.usermodel.user_type isEqualToString:@"vip"] && self.usermodel.phone != nil){
        tipsLabel.text = NSLocalizedString(@"key47", @"点击二维码刷新");
    }
}
#pragma mark 提示绑定手机号
-(void)bindTelTips:(UIGestureRecognizer *)sender{
    
    
    tipsView *tip = [[[NSBundle mainBundle] loadNibNamed:@"tipsView" owner:nil options:nil] firstObject];
    tip.layer.masksToBounds = YES;
    tip.layer.cornerRadius = 4;
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        tip.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 400);
    }else{
        tip.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 380 * KHeight_Scale);
    }

    tip.delegate = self;
    [self.view addSubview:tip];
    
    
    
}

-(void)bindTelorEmail{
    
    telAndPsdViewController *bind = [[telAndPsdViewController alloc]init];
    [self.navigationController pushViewController:bind animated:YES];
    
}
#pragma mark 二维码刷新
-(void)refreshCoder:(UIGestureRecognizer *)sender{
    //使用手机号验证
    self.bindView.version = self.usermodel.version;
    
    [self.view addSubview:self.bindView];
    
    self.bindView.delgate = self;
}

#pragma mark  bindView代理
-(void)refreshCoder{
    
    [self.bindView  removeFromSuperview];
    NSString *version = self.usermodel.version;
    float currentVersion = version.floatValue + 1.0;
    //生成新的二维码
    [self coderAndUUIDwithData:@{@"uuID":[UUID getUUID],
                                 @"bundleID":[NSBundle mainBundle].bundleIdentifier,
                                 @"version":@(currentVersion)
                                 }];
}

-(void)removeView{
    
    [self.bindView removeFromSuperview];
    
}



-(void)creatTable{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(10 * KWidth_Scale, kHeight/2.5, kWidth - 20 * KWidth_Scale, kHeight - 30 -  kHeight/2.5 ) style:UITableViewStylePlain];
    }else{
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(10 * KWidth_Scale, 220 * KHeight_Scale, kWidth - 20 * KWidth_Scale, kHeight - 230 * KHeight_Scale ) style:UITableViewStylePlain];
    }
    
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.table];
    
    [self.table registerNib:[UINib nibWithNibName:@"userCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"user"];
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20 * KHeight_Scale;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [self.titleArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  50 * KHeight_Scale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    userCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user" forIndexPath:indexPath];
    
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0)) {
        cell.moreIMG.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.imgView.image = [UIImage imageNamed:self.imgArray[indexPath.section][indexPath.row]];

    cell.detailLabel.text = self.detailArray[indexPath.section][indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //用户名复制
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([self.usermodel.user_type isEqualToString:@"vip"]) {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.usermodel.user_name;
            [keyWindow makeToast:NSLocalizedString(@"key99", nil) duration:tipsSeecond position:@"center"];
            
        }
    }
    
    
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        /*
         1000 绑定手机号
         1001 修改手机号
         1002 找回密码
         */
        //绑定手机号或邮箱
        //绑定手机号
        if ([self.usermodel.user_type isEqualToString:@"vip"]) {
            
            if (self.usermodel.phone) {
                //修改手机号
                bindTelorEmailViewController *bind = [[bindTelorEmailViewController alloc]init];
                bind.model = self.usermodel;
                bind.tag  = 1001;
                bind.navTitle = NSLocalizedString(@"key75", @"修改手机号");
                [self.navigationController  pushViewController:bind animated:YES];
            }else{
                //绑定手机号
                telAndPsdViewController *tel = [[telAndPsdViewController alloc]init];
                
                tel.navTitle = NSLocalizedString(@"key68", @"绑定手机号");
                [self.navigationController pushViewController:tel animated:YES];
            }
            
            
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key69", nil) duration:tipsSeecond position:@"center"];
        }
        
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        //修改密码
        if ([self.usermodel.user_type isEqualToString:@"vip"]) {
            
            [self psdChange];
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key69", nil) duration:tipsSeecond position:@"center"];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        //购买记录
        if ([self.usermodel.user_type isEqualToString:@"vip"]) {
            buyListViewController *buy = [[buyListViewController alloc]init];
            [self.navigationController pushViewController:buy animated:YES];
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key69", nil) duration:tipsSeecond position:@"center"];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        //找回密码
        if ([self.usermodel.user_type isEqualToString:@"vip"]) {
            [self findPsd];
            
        }else{
            
            [keyWindow makeToast:NSLocalizedString(@"key69", nil) duration:tipsSeecond position:@"center"];
        }
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        //获取分享数据
        NSString *deviceType = [UIDevice currentDevice].model;
        if (![deviceType isEqualToString:@"iPad"]) {
            
            if ([UUID getUUID]) {
                [self shareData];
                
            }
        }
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        
        if (self.usermodel.apple_id) {
            NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",self.usermodel.apple_id];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
            
            [self addtime];
        }
    }
    //客服
    if (indexPath.section == 3 && indexPath.row == 0) {
        //保存用户信息
        [self getServiceInfo];
        
        NSMutableDictionary *config = [NSMutableDictionary dictionary];
        NSMutableDictionary *customData = [NSMutableDictionary dictionary];
        [customData setObject:[AIHelpeManager getAIHelp_tags] forKey:[AIHelpeManager getAIHelp_VersionCode]];
        [customData setObject:@"1.0.0" forKey:@"VersionCode"];
        [config setObject:customData forKey:@"AIHelp-custom-metadata"];
        
        [ECServiceSdk showElvaOP:[AIHelpeManager getAI_UserName]
                       PlayerUid:[AIHelpeManager getAI_UserID]
                        ServerId:[AIHelpeManager getAI_ServerId]
                   PlayerParseId:@""
      PlayershowConversationFlag:@"1"
                          Config:config];
    }
    
    //消息的界面
    if (indexPath.section == 3 && indexPath.row == 1) {
        
        notificationListViewController *notice = [[notificationListViewController alloc]init];
        [self.navigationController  pushViewController:notice animated:YES];
        
    }
}

//添加时长
-(void)addtime{
    NSString *str = [rootUrl stringByAppendingString:addtimeUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //tag为1是修改密码  为2是找回密码
    
    [manager POST:str parameters:@{@"uuid":[UUID getUUID]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        NSLog(@"---%@",dic);
        if ([dic[@"error_code"] integerValue] == 0) {
            
            [self.delegate userActive];
            
            [keyWindow makeToast:NSLocalizedString(@"key93", nil) duration:tipsSeecond position:@"center"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        
    }];
    
    
}

#pragma mark 修改密码ui
-(void)psdChange{
    //修改密码
    NSString *title1 = nil;
    //已经设置过密码
    NSString *title2 = nil;
    //是新用户
    if ([self.usermodel.password isEqualToString:[self md5:@"1"]]) {
        title1 = NSLocalizedString(@"key58", nil);
        title2 = NSLocalizedString(@"key59", nil);
    }else{
        title1 = NSLocalizedString(@"key60", nil);
        title2 = NSLocalizedString(@"key58", nil);
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key65", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = title1;
        textField.secureTextEntry = YES;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = title2;
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key17", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //第一次设置密码
        if ([title1 isEqualToString:NSLocalizedString(@"key58", nil)]) {
            if ([alert.textFields[0].text isEqualToString:alert.textFields[1].text]) {
                if (alert.textFields[0].text.length >= 8) {
                    [self changePasswordWithpassword1:self.usermodel.password password2:[self md5:alert.textFields[1].text]];
                }else{
                    
                    [keyWindow makeToast:NSLocalizedString(@"key62", nil) duration:tipsSeecond position:@"center"];
                }
                
            }else{
                [keyWindow makeToast:NSLocalizedString(@"key61", nil) duration:tipsSeecond position:@"center"];
            }
            
        }else{
            if (alert.textFields[1].text.length >= 8) {
                [self changePasswordWithpassword1:[self md5:alert.textFields[0].text] password2:[self md5:alert.textFields[1].text]];
            }else{
                
                [keyWindow makeToast:NSLocalizedString(@"key62", nil) duration:tipsSeecond position:@"center"];
            }
            
        }
        
    }];
    
    [alert addAction:action1];
    [alert addAction: action2];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark 修改密码
-(void)changePasswordWithpassword1:(NSString *)str1  password2:(NSString *)str2{
    NSString *str = [rootUrl stringByAppendingString:changePsdUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //tag为1是修改密码  为2是找回密码
    NSDictionary *dic = @{@"uuid":[UUID getUUID],@"old_pass":str1,@"new_pass":str2, @"tag":@"1"};
    
    [manager POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        NSLog(@"---%@",dic);
        if ([dic[@"error_code"] integerValue] == 0) {
            [keyWindow makeToast:NSLocalizedString(@"key63", nil) duration:tipsSeecond position:@"center"];
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key64", nil) duration:tipsSeecond position:@"center"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [keyWindow makeToast:NSLocalizedString(@"key64", nil) duration:tipsSeecond position:@"center"];
        
    }];
}
#pragma mark 分享接口
-(void)shareData{
    
    NSString *str = [rootUrl stringByAppendingString:shareUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *dic = @{@"uuid":[UUID getUUID]};
    
    [manager POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        NSLog(@"---%@",dic);
        if ([dic[@"error_code"] integerValue] == 0) {
            self.shareTitle = dic[@"data"][@"title"];
            self.imageUrl = dic[@"data"][@"img"];
            self.linkUrl = dic[@"data"][@"link"];
        }else{
            
            self.title = nil;
            self.imageUrl = nil;
            self.linkUrl = nil;
        }
        
        if (self.shareTitle.length > 0) {
            NSString *info = self.shareTitle;
            UIImage *image=[UIImage imageNamed:@"tu"];
            NSURL *url = nil;
            if ([self.linkUrl containsString:@"http://"]) {
                url = [NSURL URLWithString:self.linkUrl];
                
            }else{
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.linkUrl]];
            }
            
            NSArray *postItems = @[info, image ,url];
            
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
            [self presentViewController:controller animated:YES completion:nil];
            
            controller.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError){
                NSLog(@"分享错误：%@",activityError.description);
                if (completed) {
                    //分享成功
                    [self addtime];
                }else{
                    
                }
            };
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}



#pragma mark 生成自己的二维码
-(void)coderAndUUIDwithData:(NSDictionary *)dic{
    
    
    //创建滤镜
    CIFilter *filer = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filer  setDefaults];
    
    //用于区分其他的二维码bundleID
    //二维码中存放的信息
    NSString *str = [dic jsonString];
    //使用base64加密
    NSString *base64 = [JoDess encodeBase64WithString:str];
    //使用DES再次加密
    //    NSString *strDES = [JoDess  encode:base64 key:keyDES];
    
    NSData *value = [base64 dataUsingEncoding:NSUTF8StringEncoding];
    [filer setValue:value forKeyPath:@"inputMessage"];
    
    //生成二维码
    CIImage *outImage = [filer outputImage];
    
    self.coderImg = outImage;
    
}

//对生成的二维码进行高清处理
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

//二维码放大
-(void)userCoderBig:(UIGestureRecognizer *)sender{
    
    coderViewController *coder = [[coderViewController alloc]init];
    
    [self.navigationController pushViewController:coder animated:YES];
}
#pragma mark 找回密码
-(void)findPsd{
    //绑定手机号
    bindTelorEmailViewController *bind = [[bindTelorEmailViewController alloc]init];
    bind.tag = 1002;
    bind.navTitle = NSLocalizedString(@"key76", @"找回密码");
    bind.model = self.usermodel;
    [self.navigationController  pushViewController:bind animated:YES];
}
//懒加载
-(AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}

-(bindTelorEmail *)bindView{
    
    if (_bindView == nil) {
        
        _bindView = [[[NSBundle mainBundle] loadNibNamed:@"bindTelorEmail" owner:nil options:nil] firstObject];
        //        _bindView.backgroundColor = [UIColor clearColor];
        _bindView.layer.masksToBounds = YES;
        _bindView.layer.cornerRadius = 4;
        
        NSString *deviceType = [UIDevice currentDevice].model;
        if ([deviceType isEqualToString:@"iPad"]) {
            _bindView.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 400);
        }else{
            _bindView.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 380 * KHeight_Scale);
        }
    }
    return _bindView;
}


-(void)userLogin{
    
    loginView *login = [[[NSBundle mainBundle] loadNibNamed:@"loginView" owner:nil options:nil] firstObject];
    login.layer.masksToBounds = YES;
    login.layer.cornerRadius = 4;
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        login.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 400);
    }else{
        login.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 380 * KHeight_Scale);
    }
    
    login.delgate = self;
    self.login = login;
    [self.view addSubview:login];
    
}


-(void)userLoginWithuserName:(NSString *)userName psd:(NSString *)password{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.login removeFromSuperview];
        
        [self.navigationController  popToRootViewControllerAnimated:YES];
    });
    
    [self.delegate  userLoginByCount:userName passsword:[JoDess md5:password]];
    
    
    
}


-(void)getUserInfo{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:[rootUrl stringByAppendingString:userInfoUrl] parameters:@{@"uuid":[UUID getUUID]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess  decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        [self.usermodel setValuesForKeysWithDictionary:dic[@"data"]];
        //对生成的二维码进行高清处理
        if ([self.usermodel.user_type isEqualToString:@"vip"]  && self.usermodel.phone != nil) {
            self.imgView.image = [self createNonInterpolatedUIImageFormCIImage:self.coderImg withSize:100*KWidth_Scale];
        }
        
        
        if (self.usermodel.user_name) {
            self.userType = self.usermodel.user_name;
        }else{
            self.userType = @"free";
        }
        
        
        if (self.usermodel.phone) {
            self.phone = NSLocalizedString(@"key44", nil);
        }else{
            self.phone = NSLocalizedString(@"key45", nil);
        }
        
        self.detailArray = @[@[self.userType,self.phone,@"",@""],@[@""],@[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],NSLocalizedString(@"key46", nil),NSLocalizedString(@"key46", nil)],@[@"",@""]];
        
        [self.table reloadData];
        
        NSLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark 客服获取用户信息
-(void)getServiceInfo{
    //用户的id
    [AIHelpeManager  setAI_UserID:[UUID getUUID]];
    //用户名
    if (self.usermodel.user_name) {
        [AIHelpeManager  setAI_UserName:self.usermodel.user_name];
    }else{
        [AIHelpeManager setAI_UserName:[UUID getUUID]];
    }
    
    //用户服务器
    [AIHelpeManager setAI_ServerId:rootUrl];
    //tags
    [AIHelpeManager setAIHelp_tags:[NSBundle mainBundle].bundleIdentifier];
    //版本
    NSString *str = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    [AIHelpeManager setAIHelp_VersionCode:str];
}
@end

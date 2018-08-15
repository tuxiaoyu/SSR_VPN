//
//  scanViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/27.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "scanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "coderViewController.h"
#import "loginView.h"
@interface scanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,userLoginDelegate>
//捕获设备
@property(nonatomic,strong)AVCaptureDevice *device;

//输入设备
@property(nonatomic,strong)AVCaptureDeviceInput *input;

//输出数据
@property(nonatomic,strong)AVCaptureMetadataOutput *output;


@property(nonatomic,strong)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic,strong)loginView  *login;

@property(nonatomic,copy)NSString *vip_uuid;
@end

@implementation scanViewController

-(void)viewWillAppear:(BOOL)animated{

  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault];

   
}

- (void)viewDidLoad {

    [super viewDidLoad];
     self.navigationItem.title = NSLocalizedString(@"key48", nil);
    
    [self creatCaptureDevice];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"key50", nil) style:UIBarButtonItemStyleDone target:self action:@selector(albumAction)];

}



-(void)creatFootView{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kHeight - 108 * KHeight_Scale, kWidth, 44 * KHeight_Scale)];
    [self.view  addSubview:btn];
    btn.titleLabel.text = NSLocalizedString(@"key51", nil);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn   setBackgroundColor:[UIColor cyanColor]];
    [btn  addTarget:self action:@selector(myCoder) forControlEvents:UIControlEventTouchUpInside];
}

-(void)myCoder{
    
    coderViewController *coder = [[coderViewController alloc]init];
    
    [self.navigationController  pushViewController:coder animated:YES];
}


- (void)creatCaptureDevice{

    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }

    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //设置扫描信息的识别区域
    [self.output setRectOfInterest:CGRectMake(0 ,0 , 1,1)];
 
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, -64 * KHeight_Scale,kWidth , kHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
}

#pragma mark 输出的代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //停止扫描
    [self.session stopRunning];
    if ([metadataObjects count] >= 1) {
        
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];

        //base64解密
        NSData *base64 = [JoDess  decodeBase64WithString:qrObject.stringValue];
        
        NSDictionary *dic = [[[NSString alloc]initWithData:base64 encoding:NSUTF8StringEncoding]  jsonDictionary];
        
        //二维码内容
        NSLog(@"二维码内容：%@",dic);
//        拿到扫描内容处理
        if ([dic[@"bundleID"] isEqualToString:[NSBundle mainBundle].bundleIdentifier]) {
            //二维码版本号验证 之后进行登录
            [self getCoderVersionUUID:dic];
            [keyWindow  makeToastActivity];

        }else{
            //无法识别二维码提示 
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key55", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
      
    }
}

#pragma Mark  使用相册中的二维码
//调用相册
-(void)albumAction{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    //选中的图片
    [self coderImage:info[@"UIImagePickerControllerOriginalImage"]];
}

//二维码识别
-(void)coderImage:(UIImage *)image{
    
    CIDetector *detector = [CIDetector  detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray  *dataArray = [detector  featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
   
    for (int index = 0; index < dataArray.count; index ++) {
        CIQRCodeFeature *feature = [dataArray objectAtIndex:index];
        //des解密
//        NSString  *str = [JoDess  decode:feature.messageString key:keyDES];
        //base64解密
        NSData *base64 = [JoDess decodeBase64WithString:feature.messageString];
        
        NSString *base64Str = [[NSString alloc]initWithData:base64 encoding:NSUTF8StringEncoding];
        NSDictionary *result = [base64Str jsonDictionary];
         NSLog(@"------%@",result);
        [self  dismissViewControllerAnimated: YES completion:nil];
       //拿到UUID  进行登录
        if ([result[@"bundleID"] isEqualToString:[NSBundle mainBundle].bundleIdentifier]) {
           //二维码版本号验证 之后进行登录
            [self getCoderVersionUUID:result];
            [keyWindow  makeToastActivity];
        
        }else{
            
            //无法识别二维码提示
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key55", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }

}


-(void)loginWithUUID:(NSString *)uuid{

    [self.session startRunning];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //授权登录
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"授权登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //向对方发送消息
        //登录标识 (1:授权登录;2:被迫下线)
        //idDev 判断是生产环境 还是测试环境
        [self accreditLogin:@{@"vip_uuid":uuid,@"bundle_id":[[NSBundle mainBundle] bundleIdentifier],@"isDev":pushBOX,@"tag":@"1",@"uuid":[UUID getUUID],@"login_tag":@"0"}];
        
        [keyWindow makeToastActivity];
        
     //如果对方没有任何反应则提示授权失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *vc = [self currentViewController];
            scanViewController *scan = [[scanViewController alloc]init];
            
            if ([[NSString stringWithUTF8String:object_getClassName(vc)] isEqualToString:[NSString stringWithUTF8String:object_getClassName(scan)]]) {
                [keyWindow hideToastActivity];
                [keyWindow makeToast:NSLocalizedString(@"key85", @"授权失败") duration:tipsSeecond position:@"center"];
                [self.session startRunning];
                
            }
            NSLog(@"当前视图:%@",[self currentViewController]);

        });

    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key101", @"账号登录") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loginByUsernameAndPsd:uuid];
        
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark 请求授权登录
-(void)accreditLogin:(NSDictionary *)dic{
    
    NSString *URL = [rootUrl stringByAppendingString:pushSendUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功%@",str);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败:%@",error);
       
    }];
}

#pragma mark 用户名和密码登录
-(void)loginByUsernameAndPsd:(NSString *)uuid{
   
    self.vip_uuid = uuid;
    
    [self userLogin];
    
}

-(void)userLogin{
    
    loginView *login = [[[NSBundle mainBundle] loadNibNamed:@"loginView" owner:nil options:nil] firstObject];
    login.layer.masksToBounds = YES;
    login.layer.cornerRadius = 4;
//    login.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (300 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 380 * KHeight_Scale);
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
    
     [self.userdelgate  userloginCount:[UUID getUUID] password:[JoDess md5:password] telorEmail:userName vip_uuid:self.vip_uuid];
    
}
#pragma mark 获取版本号
-(void)getCoderVersionUUID:(NSDictionary *)result{
    
    NSString *URL = [rootUrl stringByAppendingString:versionUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];

    [manger POST:URL  parameters:@{@"uuid":result[@"uuID"]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [keyWindow hideToastActivity];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"版本号：%@",dic);
        if ([result[@"version"] isEqualToString:dic[@"version"]]) {
            
            [self loginWithUUID:result[@"uuID"]];
            
        }else{
            [keyWindow  makeToast:@"二维码已过期" duration:tipsSeecond position:@"center"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [keyWindow hideToastActivity];
        
    }];
}
-(NSMutableDictionary *)loginDic{
    if (_loginDic == nil) {
        _loginDic = [NSMutableDictionary dictionary];
    }
    
    return _loginDic;
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

@end

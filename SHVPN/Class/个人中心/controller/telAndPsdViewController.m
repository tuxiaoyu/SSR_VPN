//
//  telAndPsdViewController.m
//  newSHVPN
//
//  Created by Tommy on 2018/1/23.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "telAndPsdViewController.h"

@interface telAndPsdViewController ()
@property(nonatomic,assign)BOOL isClick;
@end

@implementation telAndPsdViewController

-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isClick = YES;
    self.navigationItem.title = NSLocalizedString(@"key89", @"绑定手机号");
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCoderBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.getCoderBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getCoderBtn setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
                
                self.getCoderBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 发送验证码
- (IBAction)sendCoderAction:(UIButton *)sender {
    
    self.isClick = NO;
    if ([self isValidateEmail:self.TelTextField.text] || self.TelTextField.text.length > 0) {
        [self openCountdown];
        if ([self.TelTextField.text containsString:@"@"]) {
            //邮箱验证
            [self bindTelorEmailWithParameters:@{@"email":self.TelTextField.text} url:emailCodelUrl];
        }else{
            //手机号验证
            [self bindTelorEmailWithParameters:@{@"phone":self.TelTextField.text} url:TelCoderUrl];
        }
    }
}

#pragma mark 确认绑定
- (IBAction)bindAction:(UIButton *)sender {
    self.isClick = YES;
    [self bindtelorEmail];
}


#pragma mark 绑定手机号
-(void)bindtelorEmail{
    if ([self isValidateEmail:self.TelTextField.text] || self.TelTextField.text.length > 0) {
        //tag 为1是修改密码   为2是找回密码
        if (self.psdTextField.text > 0) {
            if ([self.TelTextField.text containsString:@"@"]) {
                //邮箱绑定
                [self bindTelorEmailWithParameters:@{@"email":self.TelTextField.text,@"emailcode":self.coderTextField.text,@"uuid":[UUID getUUID],@"password":[JoDess md5:self.psdTextField.text],@"bundle_id":[NSBundle mainBundle].bundleIdentifier} url:bindEmailUrl];
            }else{
                //手机号绑定
                [self bindTelorEmailWithParameters:@{@"phone":self.TelTextField.text,@"msgcode":self.coderTextField.text,@"uuid":[UUID getUUID],@"password":[JoDess md5:self.psdTextField.text],@"bundle_id":[NSBundle mainBundle].bundleIdentifier} url:bindTelUrl];
            }
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key88", @"请设置账户密码") duration:tipsSeecond position:@"center"];
        }
        
    }
}
#pragma mark 邮箱格式验证
-(BOOL)isValidateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

#pragma Mark 手机号格式验证
-(BOOL)isValidateMobile:(NSString *)mobile{
    
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
    
}

#pragma mark 手机号或邮箱发送验证码
-(void)bindTelorEmailWithParameters:(NSDictionary *)dic  url:(NSString *)subURL{
    
    NSString *URL = [rootUrl stringByAppendingString:subURL];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        
        if (dic[@"error_code"] != nil && [dic[@"error_code"] integerValue] == 0) {
           
                [keyWindow makeToast:NSLocalizedString(@"key71", @"成功") duration:tipsSeecond position:@"center"];
            if (self.isClick == YES) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tipsSeecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            
            
        }else if([dic[@"error_code"] integerValue] == 10032){
            [keyWindow makeToast:NSLocalizedString(@"key91", @"该手机号或邮箱已绑定账号") duration:tipsSeecond position:@"center"];
        }else{
            
             [keyWindow makeToast:NSLocalizedString(@"key90", @"失败") duration:tipsSeecond position:@"center"];
        }
        NSLog(@"成功oooo%@",str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [keyWindow makeToast:NSLocalizedString(@"key78", @"失败") duration:tipsSeecond position:@"center"];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.TelTextField resignFirstResponder];
    [self.coderTextField resignFirstResponder];
    
}

@end

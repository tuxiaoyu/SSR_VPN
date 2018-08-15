//
//  bindTelorEmailViewController.m
//  SHVPN
//
//  Created by Tommy on 2018/1/8.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "bindTelorEmailViewController.h"
#import "newtelViewController.h"
@interface bindTelorEmailViewController ()

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)BOOL isClick;

@end

@implementation bindTelorEmailViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
  
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navTitle;

    if (self.tag == 1001) {
        self.telorEmailTextfield.placeholder = NSLocalizedString(@"key79", @"输入原始的手机号");
    }
   
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
                [self.sendmsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
              
                self.sendmsgBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.sendmsgBtn setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
               
                self.sendmsgBtn.userInteractionEnabled = NO;
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
    
    if ([self isValidateEmail:self.telorEmailTextfield.text] || [self isValidateMobile:self.telorEmailTextfield.text]) {
        if (self.tag == 1001 || self.tag == 1002) {
            if ([self.telorEmailTextfield.text  isEqualToString:[NSString stringWithFormat:@"%@",self.model.phone]]) {
                [self openCountdown];
                if ([self.telorEmailTextfield.text containsString:@"@"]) {
                    //邮箱验证
                    [self bindTelorEmailWithParameters:@{@"email":self.telorEmailTextfield.text} url:emailCodelUrl];
                }else{
                    //手机号验证
                    [self bindTelorEmailWithParameters:@{@"phone":self.telorEmailTextfield.text} url:TelCoderUrl];
                }
            }else{
                [keyWindow makeToast:NSLocalizedString(@"key81", @"手机号或邮箱与原始的不一样") duration:tipsSeecond position:@"center"];
            }
        }else{
            
            [self openCountdown];
            if ([self.telorEmailTextfield.text containsString:@"@"]) {
                //邮箱验证
                [self bindTelorEmailWithParameters:@{@"email":self.telorEmailTextfield.text} url:emailCodelUrl];
            }else{
                //手机号验证
                [self bindTelorEmailWithParameters:@{@"phone":self.telorEmailTextfield.text} url:TelCoderUrl];
            }
        }
        
        
    }else{
        
        [keyWindow makeToast:NSLocalizedString(@"key80", @"手机号或邮箱格式错误") duration:tipsSeecond position:@"center"];
    }
    
    if (sender.selected) {
        
        sender.titleLabel.text = @"已发送";
        
    }
}

#pragma mark 确认绑定
- (IBAction)bindAction:(UIButton *)sender {

    [self bindtelorEmail];
}


#pragma mark 绑定手机号
-(void)bindtelorEmail{
    
    self.isClick = YES;
    if ([self isValidateEmail:self.telorEmailTextfield.text] || [self isValidateMobile:self.telorEmailTextfield.text]) {
        //tag 为1是修改密码   为2是找回密码
        if ([self.telorEmailTextfield.text containsString:@"@"]) {
            //邮箱绑定
            [self bindTelorEmailWithParameters:@{@"email":self.telorEmailTextfield.text,@"emailcode":self.coderTextfield.text,@"uuid":[UUID getUUID],@"bundle_id":[NSBundle mainBundle].bundleIdentifier} url:bindEmailUrl];
        }else{
            //手机号绑定
            [self bindTelorEmailWithParameters:@{@"phone":self.telorEmailTextfield.text,@"msgcode":self.coderTextfield.text,@"uuid":[UUID getUUID],@"bundle_id":[NSBundle mainBundle].bundleIdentifier} url:bindTelUrl];
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
            
            if (self.tag == 1000 && self.isClick == YES) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            if (self.tag == 1001 && self.isClick == YES) {
                //更换手机号
                self.isClick = NO;
                newtelViewController *new = [[newtelViewController alloc]init];
                [self.navigationController pushViewController:new animated:YES];
            }
            if (self.tag == 1002  && self.isClick == YES) {
                //找回密码
                self.isClick = NO;
                [self findPsd];
            }
    
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key72", @"失败") duration:tipsSeecond position:@"center"];
        }
        
        NSLog(@"成功%@",str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [keyWindow makeToast:NSLocalizedString(@"key72", @"失败") duration:tipsSeecond position:@"center"];
    }];
}

//找回密码
-(void)findPsd{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key58", @"输入新的密码") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"key58", @"输入新的密码");
        textField.secureTextEntry = YES;
    } ];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key17", @"取消") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key10", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //更新密码
        [self changePasswordWithpassword1:[self md5:[alert.textFields[0] text]] password2:[self md5:[alert.textFields[0] text]]];
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.telorEmailTextfield resignFirstResponder];
    [self.coderTextfield resignFirstResponder];
    
}


#pragma mark 修改密码
-(void)changePasswordWithpassword1:(NSString *)str1  password2:(NSString *)str2{
    NSString *str = [rootUrl stringByAppendingString:changePsdUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //tag为1是修改密码  为2是找回密码
    NSDictionary *dic = @{@"uuid":[UUID getUUID],@"re_pass":str1,@"new_pass":str2, @"tag":@"2"};
    
    [manager POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        NSLog(@"---%@",dic);
        if ([dic[@"error_code"] integerValue] == 0) {
            [keyWindow makeToast:NSLocalizedString(@"key63", nil) duration:tipsSeecond position:@"center"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tipsSeecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [keyWindow makeToast:NSLocalizedString(@"key64", nil) duration:tipsSeecond position:@"center"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [keyWindow makeToast:NSLocalizedString(@"key64", nil) duration:tipsSeecond position:@"center"];
        
    }];
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
@end

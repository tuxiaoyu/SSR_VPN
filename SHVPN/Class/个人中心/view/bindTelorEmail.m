//
//  bindTelorEmail.m
//  SHVPN
//
//  Created by Tommy on 2018/1/9.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "bindTelorEmail.h"

@implementation bindTelorEmail

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//取消

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self.delgate removeView];
    
}

//二维码刷新
- (IBAction)sureAction:(UIButton *)sender {
   //绑定手机号或邮箱
    if ([self isValidateEmail:self.telTextField.text] || self.telTextField.text.length > 0) {
        CGFloat current = self.version.floatValue + 1.0;
        if ([self.telTextField.text containsString:@"@"]) {
            //邮箱绑定
            [self bindTelorEmailWithParameters:@{@"email":self.telTextField.text,@"emailcode":self.coderTextField.text,@"uuid":[UUID getUUID],@"version":@(current),@"bundle_id":[NSBundle mainBundle].bundleIdentifier} url:bindEmailUrl];
        }else{
            //手机号绑定
            [self    bindTelorEmailWithParameters:@{@"phone":self.telTextField.text,@"msgcode":self.coderTextField.text,@"uuid":[UUID getUUID],@"version":@(current),@"bundle_id":[NSBundle mainBundle].bundleIdentifier} url:bindTelUrl];
        }
    }
    
}

//发送验证码
- (IBAction)sendMsgAction:(UIButton *)sender {
    
    [self openCountdown];
    if ([self isValidateEmail:self.telTextField.text] || self.telTextField.text.length > 0) {
        if ([self.telTextField.text containsString:@"@"]) {
            //邮箱验证
            [self bindTelorEmailWithParameters:@{@"email":self.telTextField.text} url:emailCodelUrl];
        }else{
            //手机号验证
            [self bindTelorEmailWithParameters:@{@"phone":self.telTextField.text} url:TelCoderUrl];
        }
    }
    
    if (sender.selected) {
        
        sender.titleLabel.text = @"已发送";
        
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
                [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                
                self.sendBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.sendBtn setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
                
                self.sendBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
    __weak typeof(self) weakSelf = self;
    [manger POST:URL  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSLog(@"成功%@",str);
        
        //走二维码刷新的代理（如果无错误）
        if ([[str jsonDictionary][@"error_code"] integerValue] == 0) {
            [weakSelf.delgate  refreshCoder];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败%@",error);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.telTextField resignFirstResponder];
    
    [self.coderTextField resignFirstResponder];
}

@end

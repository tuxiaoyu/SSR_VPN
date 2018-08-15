//
//  coderViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/13.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "coderViewController.h"
#import <CoreImage/CoreImage.h>
#import "UUID.h"
#import "JSONUtils.h"
#import <AVFoundation/AVFoundation.h>

@interface coderViewController ()
//二维码
@property(nonatomic, strong)CIImage *coderImg;

//
@property(nonatomic,strong)UIImageView *imgView;

//二维码扫描
@property(nonatomic,strong)AVCaptureSession *session;

@end

@implementation coderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self  coderAndUUID];
    
}

#pragma mark 生成自己的二维码
-(void)coderAndUUID{
    //创建滤镜
    CIFilter *filer = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filer  setDefaults];
    //用于区分其他的二维码bundleID
    NSDictionary *dic = @{@"uuID":[UUID getUUID],
                          @"bundleID":[NSBundle mainBundle].bundleIdentifier
                          };
    
    //二维码中存放的信息
    NSString *str = [dic jsonString];
    //使用base64加密
    NSString *base64 = [JoDess encodeBase64WithString:str];
    //使用DES再次加密
    NSString *strDES = [JoDess  encode:base64 key:keyDES];
    //解密
    NSData *value = [strDES dataUsingEncoding:NSUTF8StringEncoding];
    
    [filer setValue:value forKeyPath:@"inputMessage"];
    //生成二维码
    CIImage *outImage = [filer outputImage];
    self.coderImg = outImage;
    
    //在界面上显示二维码
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100 * KWidth_Scale, 100 * KHeight_Scale, 200 * KWidth_Scale, 200 * KHeight_Scale)];
    self.imgView = imgView;
    //对生成的二维码进行高清处理
    imgView.image = [self createNonInterpolatedUIImageFormCIImage:outImage withSize:200];
    
    [self.view addSubview:imgView];
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

//懒加载
-(AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}



@end

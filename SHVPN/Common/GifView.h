//
//  GifView.h
//  test1
//
//  Created by 紫川秀 on 2017/7/5.
//  Copyright © 2017年 View. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface GifView : UIView

-(id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath andInterval:(float)time;
-(id)initWithFrame:(CGRect)frame data:(NSData *)data andInterval:(float)time;

@end

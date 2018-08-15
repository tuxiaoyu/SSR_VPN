//
//  adView.h
//  SHVPN
//
//  Created by Tommy on 2018/1/19.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@protocol  removeViewDelegate<NSObject>

-(void)removeAdView;

@end

@interface adView : UIView

@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong) WKWebView *adWebView;

@property(nonatomic,strong)id<removeViewDelegate> delegate;
@end

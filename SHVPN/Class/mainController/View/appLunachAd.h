//
//  appLunachAd.h
//  SHVPN
//
//  Created by Tommy on 2018/4/25.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  openAppAdDeleate<NSObject>

-(void)imgTapLink:(NSDictionary *)dic;

@end

@interface appLunachAd : UIView

@property(nonatomic,strong)UIImageView *bgImg;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,weak) id<openAppAdDeleate> delegate;
@property(nonatomic,strong)NSString *URLStr;

@end

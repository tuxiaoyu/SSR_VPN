//
//  noDataView.h
//  SHVPN
//
//  Created by Tommy on 2017/12/26.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  refreshDelegate<NSObject>

-(void)refreshUI;

@end

@interface noDataView : UIView

@property(nonatomic,assign) id <refreshDelegate>  delegate;

@end

//
//  routeTableViewCell.h
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listModel.h"
@interface routeTableViewCell : UITableViewCell
//旗子
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
//国家名字
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
//选中
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@property(nonatomic,strong) listModel *model;
@end

//
//  packageItemTableViewCell.h
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "packageModel.h"
@interface packageItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *packageNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property(nonatomic,strong) packageModel *model;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;

@property (weak, nonatomic) IBOutlet UIImageView *hotImg;

@end

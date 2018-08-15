//
//  routeTableViewCell.m
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "routeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation routeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(listModel *)model{
    
    self.countryNameLabel.text = [NSString stringWithFormat:@"%@  (%@)",model.area_name,model.area_code];
    
    [self.flagImageView  sd_setImageWithURL:[NSURL URLWithString:model.flag]];
    
}
@end

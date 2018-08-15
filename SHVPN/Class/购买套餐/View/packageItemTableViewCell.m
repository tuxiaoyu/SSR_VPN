//
//  packageItemTableViewCell.m
//  SHVPN
//
//  Created by Tommy on 2017/12/19.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "packageItemTableViewCell.h"

@implementation packageItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(packageModel *)model{
    
    self.packageNamelabel.text = model.goods_name;

    if (model.promotion_price) {
        
        NSAttributedString *attrStr =
        [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.goods_price]
                                      attributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:13],
           NSForegroundColorAttributeName:[UIColor grayColor],
           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
        
        self.oldPrice.attributedText = attrStr;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.promotion_price];
        
    }else{
    
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    }

    if (model.is_hot.integerValue == 1) {
       
        self.hotImg.hidden = NO;
    }
}


@end

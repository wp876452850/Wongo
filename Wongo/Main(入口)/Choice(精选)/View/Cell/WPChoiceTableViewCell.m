//
//  WPChoiceTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceTableViewCell.h"

@interface WPChoiceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIButton *collection;
@property (weak, nonatomic) IBOutlet UILabel *collectionNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
@implementation WPChoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    self.icon.selected                  = NO;
    self.selectionStyle                 = UITableViewCellSelectionStyleNone;
    [self.icon setImage:[UIImage imageNamed:@"collection_gray_normal"] forState:UIControlStateNormal];
    [self.icon setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateSelected];
    self.collection.layer.masksToBounds = YES;
    self.collection.layer.cornerRadius  = 12.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


-(void)setModel:(WPExchangeModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url]];
    //self.icon.selected = model.collection;
    //self.collectionNumber.text = model.collectNumber;
    self.goodsName.text = model.gname;
    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
}
- (IBAction)colletionButtonClick:(id)sender {
    [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
    return;
    self.icon.selected = !self.icon.selected;

}
@end

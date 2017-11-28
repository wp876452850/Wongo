//
//  WPShopingCarTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2016/12/19.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPShopingCarTableViewCell.h"

@interface WPShopingCarTableViewCell ()
{
    WPNumberChangeBlock _addBlock;
    WPNumberChangeBlock _cutBlock;
    WPSelectChangeBlock _selectBlock;
}
@end

@implementation WPShopingCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsNumber.layer.masksToBounds = YES;
    self.goodsNumber.layer.borderWidth = 1;
    self.goodsNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.selectButton setImage:[UIImage imageNamed:@"clickChoose_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)showDataWithModel:(WPShoppingCarModel *)model
{
    self.selectButton.selected = model.select;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsImage_url] placeholderImage:[UIImage imageNamed:@"broken"]];
    self.goodsName.text = model.goodsName;
    self.goodsNumber.text = model.goodsNumber;
    self.price.text = [NSString stringWithFormat:@"￥%ld",[model.price integerValue]];
}
-(void)numberWithAddBlock:(WPNumberChangeBlock)block
{
    _addBlock = block;
}
-(void)numberWithCutBlock:(WPNumberChangeBlock)block
{
    _cutBlock = block;
}
-(void)cellSelctWithBlock:(WPSelectChangeBlock)block
{
    _selectBlock = block;
}
- (IBAction)select:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_selectBlock) {
        _selectBlock(sender.selected);
    }
}
- (IBAction)cut:(UIButton *)sender
{
    NSInteger number = [self.goodsNumber.text integerValue];
    if (number <= 1) {
        return;
    }
    number--;
    if (_cutBlock) {
        _cutBlock(number);
    }
}
- (IBAction)add:(UIButton *)sender
{
    NSInteger number = [self.goodsNumber.text integerValue];
    number++;
    if (_addBlock) {
        _addBlock(number);
    }
}


@end

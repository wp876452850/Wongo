//
//  WPNewExchangeCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewExchangeCollectionViewCell.h"
#import "WPExchangeViewController.h"

@interface WPNewExchangeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UITextView *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *thumpUp;

@end
@implementation WPNewExchangeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setModel:(WPNewExchangeModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    //商品名
    NSString * gname = model.gname;
    if (model.gname.length >= 20) {
        gname = [NSString stringWithFormat:@"%@...",[gname substringToIndex:20]];
    }
    NSAttributedString * attributeString = [[NSAttributedString alloc]initWithString:gname];
    //判断是否官方商品
    if (model.uid.floatValue == 1.f||model.uid.floatValue == 2) {
        attributeString = [WPAttributedString attributedStringWithAttributedString:attributeString insertImage:[UIImage imageNamed:@"guanfang"] atIndex:0 imageBounds:CGRectMake(0, -1.5, 27, 12)];
    }
    //判断是否新上架
    
    
    //设置价格标识
    _goodsName.attributedText = attributeString;
    
    NSAttributedString * priceAttributeString = [[NSAttributedString alloc]initWithString:model.price];
    priceAttributeString = [WPAttributedString attributedStringWithAttributedString:priceAttributeString insertImage:[UIImage imageNamed:@"price"] atIndex:0 imageBounds:CGRectMake(0, -1, 6, 12)];
    
    _price.attributedText = priceAttributeString;
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPExchangeViewController * vc   = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_model.gid} fromOrder:NO];
    [vc showExchangeBottomView];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}
@end

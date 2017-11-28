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
//
@property (weak, nonatomic) IBOutlet UIButton *thumpUp;
//想换
@property (weak, nonatomic) IBOutlet UILabel *wantExchange;

@end
@implementation WPNewExchangeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_thumpUp setImage:[UIImage imageNamed:@"thumup_select"] forState:UIControlStateSelected];
    [_thumpUp setImage:[UIImage imageNamed:@"thumup_normal"] forState:UIControlStateNormal];
}
-(void)setModel:(WPNewExchangeModel *)model{
    _model = model;
    _wantExchange.text = [NSString stringWithFormat:@"%ld想换",[_model.praise integerValue]];
    if (model.url.length<=0) {
        model.url = @"";
    }
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    //商品名
    NSString * gname = model.gname;
    if (model.gname.length >= 20) {
        gname = [NSString stringWithFormat:@"%@...",[gname substringToIndex:20]];
    }
    NSAttributedString * attributeString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",gname]];
    //判断是否官方商品
    if (model.uid.floatValue == 1.f||model.uid.floatValue == 2) {
        attributeString = [WPAttributedString attributedStringWithAttributedString:attributeString insertImage:[UIImage imageNamed:@"goodsshowguangfang"] atIndex:0 imageBounds:CGRectMake(0, -1.2, 20, 10)];
    }else{
        //判断是否新上架
         attributeString = [WPAttributedString attributedStringWithAttributedString:attributeString insertImage:[UIImage imageNamed:@"goodsshownew"] atIndex:0 imageBounds:CGRectMake(0, -1.2, 20, 10)];
    }
    _goodsName.attributedText = attributeString;
    
    _price.text = [NSString stringWithFormat:@"￥%ld",[model.price integerValue]];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPExchangeViewController * vc   = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_model.gid} fromOrder:NO];
    [vc showExchangeBottomView];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}
- (IBAction)thumUp:(UIButton *)sender {
    [self thumbUpGoodsWithSender:sender gid:_model.gid];
}
- (IBAction)wangExchangeClick:(UIButton *)sender {
    //点赞数
    NSInteger praise = [_model.praise integerValue];
    if (!sender.selected) {
        self.wantExchange.text = [NSString stringWithFormat:@"%ld想换",praise+1];
    }else{
        self.wantExchange.text = [NSString stringWithFormat:@"%ld想换",praise];
    }
    [self thumbUpGoodsWithSender:sender gid:_model.gid];
}

@end

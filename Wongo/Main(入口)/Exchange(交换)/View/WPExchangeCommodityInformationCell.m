//
//  WPExchangeCommodityInformationCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeCommodityInformationCell.h"

@interface WPExchangeCommodityInformationCell ()

/**商品名*/
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**新旧度*/
@property (weak, nonatomic) IBOutlet UILabel *oldNew;
/**运费*/
@property (weak, nonatomic) IBOutlet UILabel *freight;
/**收藏*/
@property (weak, nonatomic) IBOutlet UIButton *collectionButoon;

@end

@implementation WPExchangeCommodityInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_collectionButoon setBackgroundImage:[UIImage imageNamed:@"1_star_1@3x"] forState:UIControlStateNormal];
    [_collectionButoon setBackgroundImage:[UIImage imageNamed:@"1_star_2@3x"] forState:UIControlStateSelected];
}

-(void)setModel:(WPExchangeDetailModel *)model{
    _model = model;
    if ([model.uid floatValue] == 1 ||[model.uid floatValue] == 2) {
        NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",model.gname]];
        _goodsName.attributedText = [WPAttributedString attributedStringWithAttributedString:attributedString insertImage:[UIImage imageNamed:@"guanfang.jpg"] atIndex:0 imageBounds:CGRectMake(0, -2, 36, 16)];
    }else{
        _goodsName.text = model.gname;
    }
    _oldNew.text    = model.neworold;
    _freight.text   = [NSString stringWithFormat:@"%@%@",model.unit,model.freight];
    _price.text     = [NSString stringWithFormat:@" %@",model.price];
    [UILabel changeWordSpaceForLabel:_price WithSpace:1.f];
    _price.attributedText = [WPAttributedString attributedStringWithAttributedString:_price.attributedText insertImage:[UIImage imageNamed:@"price"] atIndex:0 imageBounds:CGRectMake(0, -1, 10, 20)];
    //判断用户收藏的商品总是否有
    //判断是否登录
    if ([self getSelfUid].length>0) {
        __block WPExchangeCommodityInformationCell * weakSelf = self;
        [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCollectionUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            NSArray * list = responseObject[@"list"];
            for (NSDictionary * dic in list) {
                NSString * gid = dic[@"gid"];
                
                if (_model.gid.floatValue == gid.floatValue) {
                    weakSelf.collectionButoon.selected = YES;
                }
            }
        }];
    }
}
//收藏
- (IBAction)collection:(UIButton *)sender {
    [self collectionOfGoodsWithSender:sender gid:_model.gid];
}


@end

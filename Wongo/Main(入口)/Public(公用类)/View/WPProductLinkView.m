//
//  WPProductLinkView.m
//  Wongo
//
//  Created by  WanGao on 2017/7/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPProductLinkView.h"

@interface WPProductLinkView ()
@property (nonatomic,strong)UIImageView * goodsImage;
@property (nonatomic,strong)UITextView * gname;
@property (nonatomic,strong)UILabel * price;
@property (nonatomic,strong)NSString * gid;
@property (nonatomic,strong)WPExchangeDetailModel * model;
@end
@implementation WPProductLinkView

+(instancetype)productLinkWithModel:(WPExchangeDetailModel *)model frame:(CGRect)frame{
    WPProductLinkView * productLinkView = [[WPProductLinkView alloc]initWithFrame:frame];
    productLinkView.model = model;
    [productLinkView setUpProductLinkSubView];
    return productLinkView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.size = CGSizeMake(WINDOW_WIDTH - 20, 90);
        self.backgroundColor = ColorWithRGB(222, 222, 222);
    }
    return self;
}



-(void)setUpProductLinkSubView{
    UIImageView * goodsImage = [[UIImageView alloc]init];
    [self addSubview:goodsImage];
    goodsImage.layer.borderColor = ColorWithRGB(222, 222, 222).CGColor;
    goodsImage.layer.borderWidth = 2.f;
    [goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.rollPlayImages[0]] placeholderImage:nil];
    
    UITextView * gname = [[UITextView alloc]init];
    [self addSubview:gname];
    gname.text = _model.gname;
    [UITextView changeWordSpaceForLabel:gname WithSpace:1.f];
    gname.font = [UIFont systemFontOfSize:16];
    gname.userInteractionEnabled = NO;
    gname.backgroundColor = self.backgroundColor;
    
    UILabel * price = [[UILabel alloc]init];
    [self addSubview:price];
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = SelfOrangeColor;
    price.text = [NSString stringWithFormat:@"￥%@",_model.price];
    self.goodsImage = goodsImage;
    self.gname = gname;
    self.price = price;
    
    [goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [gname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImage.mas_right).offset(10);
        make.top.mas_equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH - 110, 60));
    }];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImage.mas_right).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH - 110, 25));
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end

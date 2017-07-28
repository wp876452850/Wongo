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
@property (nonatomic,strong)UILabel * gname;
@property (nonatomic,strong)UILabel * price;
@property (nonatomic,strong)NSString * gid;
@end
@implementation WPProductLinkView

+(instancetype)productLinkWithGid:(NSString *)gid frame:(CGRect)frame{
    WPProductLinkView * productLinkView = [[WPProductLinkView alloc]initWithFrame:frame];
    productLinkView.gid = gid;
    [productLinkView loadDatas];
    return productLinkView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpProductLinkSubView];
        self.size = CGSizeMake(WINDOW_WIDTH - 20, 90);
        self.backgroundColor = ColorWithRGB(247, 247, 247);
    }
    return self;
}

-(void)loadDatas{

    [WPNetWorking createPostRequestMenagerWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_gid} datas:^(NSDictionary *responseObject) {
                _gname.text = responseObject[@"gname"];
                [UILabel changeLineSpaceForLabel:_gname WithSpace:1];
                _price.text = [NSString stringWithFormat:@"￥%@",responseObject[@"price"]];
                [_goodsImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"listimg"][0][@"url"]] placeholderImage:nil];
    }];

}

-(void)setUpProductLinkSubView{
    UIImageView * goodsImage = [[UIImageView alloc]init];
    [self addSubview:goodsImage];
    
    UILabel * gname = [[UILabel alloc]init];
    [self addSubview:gname];
    gname.font = [UIFont systemFontOfSize:14];
    gname.numberOfLines = 0;
    
    
    UILabel * price = [[UILabel alloc]init];
    [self addSubview:price];
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = SelfOrangeColor;
    self.goodsImage = goodsImage;
    self.gname = gname;
    self.price = price;
    
    [goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [gname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImage.mas_right).offset(10);
        make.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.width-90, 60));
    }];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImage.mas_right).offset(10);
        make.bottom.mas_equalTo(self.bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(self.width-90, 30));
    }];
    
    
}
@end

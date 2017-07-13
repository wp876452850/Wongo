//
//  WPMyShopUserInformationView.m
//  Wongo
//
//  Created by rexsu on 2017/3/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyShopUserInformationView.h"


@implementation WPMyShopUserInformationView
-(UIImageView *)headerView{
    if (!_headerView) {
        
    }
    return _headerView;
}

-(UILabel *)signature{
    if (!_signature) {
        
    }
    return _signature;
}

-(UILabel *)goodsNumber{
    if (!_goodsNumber) {
        
    }
    return _goodsNumber;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, 300);
    }
    return self;
}

-(void)setModel:(WPMyShopUserInformationModel *)model{
    _model = model;
    
}


@end

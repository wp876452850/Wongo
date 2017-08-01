//
//  WPAdvertisingView.m
//  Wongo
//
//  Created by  WanGao on 2017/7/31.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAdvertisingView.h"

@interface WPAdvertisingView ()
@property (nonatomic,strong)UIImageView * advertisingImageView;
@property (nonatomic,strong)UIButton * passButton;
@property (nonatomic,strong)NSTimer * timer;
@end
@implementation WPAdvertisingView
-(UIImageView *)advertisingImageView{
    if (!_advertisingImageView) {
        
    }
    return _advertisingImageView;
}

-(UIButton *)passButton{
    if (!_passButton) {
        _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _passButton;
}
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
        [self addSubview:self. advertisingImageView];
        [self addSubview:self.passButton];
        
    }
    return self;
}


@end

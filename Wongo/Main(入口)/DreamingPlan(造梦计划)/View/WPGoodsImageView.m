//
//  WPGoodsImageView.m
//  Wongo
//
//  Created by rexsu on 2017/5/4.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPGoodsImageView.h"

@interface WPGoodsImageView ()
{
    DeleteGoodsImage _block;
}
@end
@implementation WPGoodsImageView

-(instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        [self createDeleteBtn];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createDeleteBtn];
    }
    return self;
}
-(instancetype)init{
    if (self) {
        [self createDeleteBtn];
    }
    return self;
}
-(void)createDeleteBtn{
    self.userInteractionEnabled = YES;
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.top.mas_equalTo(0);
    }];
}

-(void)deleteSelf{
    

    [[self findViewController:self] showAlertWithAlertTitle:@"提示" message:@"是否删除图片" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
        if (_block) {
            _block();
        }
    }];
}

-(void)getBlock:(DeleteGoodsImage)block{
    _block = block;
}

@end

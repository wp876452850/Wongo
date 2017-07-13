//
//  WPDreamingDirectoryHeadView.m
//  test1111
//
//  Created by rexsu on 2017/5/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDirectoryHeadView.h"
#import "WPPushDreamingViewController.h"
#import "Masonry.h"
@interface WPDreamingDirectoryHeadView ()

/**主题名字*/
@property (nonatomic,strong)UILabel     * subName;
/**背景图片*/
@property (nonatomic,strong)UIImageView * bgImage;
/**主题框*/
@property (nonatomic,strong)UIImageView * icon;
/**介绍(签名)*/
@property (nonatomic,strong)UILabel     * signature;
/**报名按钮*/
@property (nonatomic,strong)UIButton    * signUpButton;
/**造梦物品数量*/
@property (nonatomic,strong)UILabel     * dreamingNumber;
/**造梦人数量*/
@property (nonatomic,strong)UILabel     * dreamerNumber;
/**浏览量*/
@property (nonatomic,strong)UILabel     * views;

@end

@implementation WPDreamingDirectoryHeadView

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:self.bounds];
        _icon.image = [UIImage imageNamed:@"dreamingDirectory"];
    }
    return _icon;
}
-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgImage.frame = self.frame;
    }
    return _bgImage;
}
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220);
        [self addSubview:self.bgImage];
        [self addSubview:self.icon];
        [self addSubview:self.signUpButton];

        [self addMasonry];
        
        
    }
    return self;
}

-(void)addMasonry{
    UILabel * subName = [[UILabel alloc]init];
    subName.font = [UIFont systemFontOfSize:15];
    subName.textColor = WhiteColor;
    subName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:subName];
    
    UILabel * signature = [[UILabel alloc]init];
    signature.textColor = WhiteColor;
    signature.font = [UIFont systemFontOfSize:14.5f];
    signature.textAlignment = NSTextAlignmentCenter;
    [self addSubview:signature];
    
    UILabel * dreamerNumber = [[UILabel alloc]init];
    dreamerNumber.textColor = WhiteColor;
    dreamerNumber.font = [UIFont systemFontOfSize:13];
    [self addSubview:dreamerNumber];
    
    UILabel * dreamingNumber = [[UILabel alloc]init];
    dreamingNumber.textColor = WhiteColor;
    dreamingNumber.font = [UIFont systemFontOfSize:13];
    dreamerNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dreamingNumber];
    
    UILabel * views = [[UILabel alloc]init];
    views.textColor = WhiteColor;
    views.font = [UIFont systemFontOfSize:13];
    views.textAlignment = NSTextAlignmentRight;
    [self addSubview:views];

    UIButton * signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setBackgroundImage:[UIImage imageNamed:@"baoming"] forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:signUpButton];
    
    _subName        = subName;
    _signature      = signature;
    _signUpButton   = signUpButton;
    _views          = views;
    _dreamerNumber  = dreamerNumber;
    _dreamingNumber = dreamingNumber;
     
    [signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 20, 40));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(signature.mas_top).mas_offset(-15);
    }];
    
    [subName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 20));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(_icon.mas_centerY);
    }];
    
    [signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(98, 26));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(signature.mas_bottom).mas_offset(15);
    }];
    
    [dreamingNumber mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);;
    }];
    
    [dreamerNumber mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-10);
    }];
    
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(-10);
    }];
}

-(void)setModel:(WPDreamingDirectoryHeaderViewModel *)model
{
    _model = model;
    _dreamingNumber.text    = [NSString stringWithFormat:@"%@件造梦物品",model.productnum ];
    _dreamerNumber.text     = [NSString stringWithFormat:@"%@个造梦人",model.count];
    _views.text             = [NSString stringWithFormat:@"%@浏览",model.readview];
    _subName.text           = model.subname;
    _signature.text         = model.content;
    [_bgImage sd_setImageWithURL:[NSURL URLWithString:model.url]];
}
//报名
-(void)signUp{
    WPPushDreamingViewController * vc = [[WPPushDreamingViewController alloc]init];
    vc.subid = self.subid;
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
    vc.isPush = YES;
}


@end


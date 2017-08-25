//
//  WPStoreUserInformationView.m
//  Wongo
//
//  Created by  WanGao on 2017/8/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPStoreUserInformationView.h"
#import "WPCustomButton.h"

#define MenuTitles @[@"交换商品",@"造梦商品"]
@interface WPStoreUserInformationView ()
{
    WPCustomButton * _selectButton;
}
@property (nonatomic,strong)NSString * uid;
@property (nonatomic,strong)UIImageView * bgimage;
@property (nonatomic,strong)UIImageView * headerImage;
@property (nonatomic,strong)UILabel * uname;
@property (nonatomic,strong)UILabel * collectionNumber;
@property (nonatomic,strong)UILabel * fansNumber;
@end
@implementation WPStoreUserInformationView

#pragma mark - 懒加载
-(UIImageView *)bgimage{
    if (!_bgimage) {
        _bgimage = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgimage.height = self.height - 40;
    }
    return _bgimage;
}
-(UIImageView *)headerImage{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        _headerImage.center = CGPointMake(self.width/2, self.height / 2 - 40);
        _headerImage.layer.masksToBounds = YES;
        _headerImage.layer.cornerRadius = _headerImage.height/2.f;
        _headerImage.layer.borderColor = WhiteColor.CGColor;
        _headerImage.layer.borderWidth = 0.5f;
        
    }
    return _headerImage;
}

-(UILabel *)uname{
    if (!_uname) {
        _uname = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 30)];
        _uname.y = _headerImage.bottom + 10;
        _uname.textAlignment = NSTextAlignmentCenter;
        _uname.textColor = WhiteColor;
    }
    return _uname;
}

-(UILabel *)collectionNumber{
    if (!_collectionNumber) {
        _collectionNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH / 2, 20)];
        _collectionNumber.textAlignment = NSTextAlignmentRight;
        _collectionNumber.textColor = WhiteColor;
        _collectionNumber.y = _uname.bottom+20;
        _collectionNumber.right = WINDOW_WIDTH/2;
        [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_collectionNumber.right - 0.5f, _collectionNumber.y) moveForPoint:CGPointMake(_collectionNumber.right - 0.5f, _collectionNumber.bottom) lineColor:WhiteColor]];
    }
    return _collectionNumber;
}

-(UILabel *)fansNumber{
    if (!_fansNumber ) {
        _fansNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH / 2, 20)];
        _fansNumber.textAlignment = NSTextAlignmentLeft;
        _fansNumber.textColor = WhiteColor;
        _fansNumber.y = _uname.bottom+20;
        _fansNumber.x =  WINDOW_WIDTH/2;
    }
    return _fansNumber;
}

-(instancetype)initWithFrame:(CGRect)frame uid:(NSString *)uid{
    if (self = [super initWithFrame:frame]) {
        self.uid = uid;
        [self addSubview:self.bgimage];
        [self addSubview:self.headerImage];
        [self addSubview:self.uname];
        [self addSubview:self.collectionNumber];
        [self addSubview:self.fansNumber];
        for (UIView * view in self.subviews) {
            view.backgroundColor = RandomColor;
        }
        [self createButton];
    }
    return self;
}

-(void)createButton{
    for (int i = 0; i<2; i++) {
        WPCustomButton * menuButton = [[WPCustomButton alloc]initWithFrame:CGRectMake(i*WINDOW_WIDTH/2, 0, WINDOW_WIDTH/2, 40)];
        if (i == 0) {
            _selectButton = menuButton;
            menuButton.selected = YES;
            menuButton.backgroundColor = ColorWithRGB(0, 0, 0);
        }
        menuButton.y = self.height - 40;
        menuButton.titleLabel.font = [UIFont systemFontOfSize:15];
        menuButton.normalTitleColor = ColorWithRGB(0, 0, 0);
        menuButton.selectedTitleColor = WongoBlueColor;        
        menuButton.backgroundColor = WhiteColor;
       // menuButton.normalAttrobuteString = MenuTitles[i];
        menuButton.tag = i;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [menuButton addGestureRecognizer:tap];
        [self addSubview:menuButton];
    }
}

-(void)tap:(UITapGestureRecognizer *)tap{
    WPCustomButton * munuButton = (WPCustomButton *)tap.view;
    if (_selectButton == munuButton) {
        return;
    }
    _selectButton.selected  = !_selectButton.selected;
    _selectButton.y        -=20.f;
    _selectButton.height    = 60.f;
    munuButton.selected     = !munuButton.selected;
    munuButton.y           +=20.f;
    munuButton.height       = 40.f;
    _selectButton           = munuButton;
    
}

-(void)loadDatas{
    
}
@end

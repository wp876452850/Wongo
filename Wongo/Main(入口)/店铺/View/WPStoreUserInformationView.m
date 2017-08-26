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
    UIButton * _selectButton;
    WPStoreUserInformationBlock _blcok;
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
        [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_collectionNumber.right - 0.5f, _collectionNumber.y) moveForPoint:CGPointMake(_collectionNumber.right - 0.5f, _collectionNumber.bottom) lineColor:WhiteColor]];
        for (UIView * view in self.subviews) {
            view.backgroundColor = RandomColor;
        }
        [self createButton];
    }
    return self;
}

-(void)createButton{
    for (int i = 0; i<2; i++) {
        UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(i*WINDOW_WIDTH/2, 0, WINDOW_WIDTH/2, 40);
        menuButton.backgroundColor = ColorWithRGB(0, 0, 0);
       
        menuButton.y = self.height - 80;
        menuButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [menuButton setTitleColor:WongoBlueColor forState:UIControlStateNormal];
        [menuButton setTitleColor:ColorWithRGB(0, 0, 0) forState:UIControlStateSelected];
        [menuButton setTitle: MenuTitles[i] forState:UIControlStateNormal];
        menuButton.tag = i;
        if (i == 0) {
            _selectButton = menuButton;
            menuButton.selected         = YES;
            menuButton.backgroundColor  = WhiteColor;
            menuButton.height           = 45.f;
            _selectButton.y             -= 5.f;
        }
        [menuButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
    }
}

-(void)tap:(UIButton *)sender{
    if (_selectButton == sender) {
        return;
    }
    _selectButton.selected  = !_selectButton.selected;
    _selectButton.y        += 5.f;
    _selectButton.height    = 40.f;
    _selectButton.backgroundColor = ColorWithRGB(0, 0, 0);
    sender.selected         = !sender.selected;
    sender.y               -= 5.f;
    sender.height           = 45.f;
    sender.backgroundColor  = WhiteColor;
    _selectButton           = sender;
    if (_blcok) {
        _blcok(sender.tag);
    }
}

-(void)loadDatas{
    
}

-(void)getmuneTagWithBlock:(WPStoreUserInformationBlock)block{
    _blcok = block;
}
@end

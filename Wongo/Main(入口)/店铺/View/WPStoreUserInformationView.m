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
//#define MenuTitles @[@"交换商品",@"造梦商品",@"寄卖商品"]

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
@property (nonatomic,strong)WPStoreModel * storeModel;
@end
@implementation WPStoreUserInformationView

#pragma mark - 懒加载
-(UIImageView *)bgimage{
    if (!_bgimage) {
        _bgimage = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgimage.height = self.height - 40;
        _bgimage.contentMode = UIViewContentModeScaleAspectFill;
        _bgimage.image = [UIImage imageNamed:@"dianpubeijingtu"];
    }
    return _bgimage;
}
-(UIImageView *)headerImage{
    if (!_headerImage){
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        _headerImage.center = CGPointMake(self.width/2, self.height / 2 - 40);
        _headerImage.layer.masksToBounds = YES;
        _headerImage.layer.cornerRadius = _headerImage.height/2.f;
        _headerImage.layer.borderColor = WhiteColor.CGColor;
        _headerImage.layer.borderWidth = 0.5f;
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:_storeModel.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    }
    return _headerImage;
}

-(UILabel *)uname{
    if (!_uname) {
        _uname = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 30)];
        _uname.y = _headerImage.bottom + 10;
        _uname.text = _storeModel.uname;
        _uname.textAlignment = NSTextAlignmentCenter;
        _uname.textColor = WhiteColor;
        _uname.shadowColor = TitleGrayColor;
        //阴影偏移  x，y为正表示向右下偏移
        _uname.shadowOffset = CGSizeMake(0.4, 0.4);
    }
    return _uname;
}

-(UILabel *)collectionNumber{
    if (!_collectionNumber) {
        _collectionNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH / 2, 20)];
        _collectionNumber.text = [NSString stringWithFormat:@"关注:%@",_storeModel.attentionnum];
        _collectionNumber.textAlignment = NSTextAlignmentCenter;
        _collectionNumber.textColor = WhiteColor;
        _collectionNumber.y = _uname.bottom + 20;
        _collectionNumber.right = WINDOW_WIDTH/2;
        _collectionNumber.shadowColor = TitleGrayColor;
        //阴影偏移  x，y为正表示向右下偏移
        _collectionNumber.shadowOffset = CGSizeMake(0.4, 0.4);
    }
    return _collectionNumber;
}

-(UILabel *)fansNumber{
    if (!_fansNumber ) {
        _fansNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH / 2, 20)];
        _fansNumber.text = [NSString stringWithFormat:@"粉丝:%@",_storeModel.fansnum];
        _fansNumber.textColor = WhiteColor;
        _fansNumber.textAlignment = NSTextAlignmentCenter;
        _fansNumber.y = _uname.bottom + 20;
        _fansNumber.x =  WINDOW_WIDTH/2;
        _fansNumber.shadowColor = TitleGrayColor;
        //阴影偏移  x，y为正表示向右下偏移
        _fansNumber.shadowOffset = CGSizeMake(0.4, 0.4);
    }
    return _fansNumber;
}

-(instancetype)initWithFrame:(CGRect)frame storeModel:(WPStoreModel *)storeModel{
    if (self = [super initWithFrame:frame]) {
        self.storeModel = storeModel;
        [self addSubview:self.bgimage];
        [self addSubview:self.headerImage];
        [self addSubview:self.uname];
        [self addSubview:self.collectionNumber];
        [self addSubview:self.fansNumber];
        [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_collectionNumber.right - 0.5f, _collectionNumber.y) moveForPoint:CGPointMake(_collectionNumber.right - 0.5f, _collectionNumber.bottom) lineColor:WhiteColor]];
        [self createButton];
        
    }
    return self;
}

-(void)createButton{
    for (int i = 0; i<MenuTitles.count; i++) {
        UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(i*WINDOW_WIDTH/MenuTitles.count, 0, WINDOW_WIDTH/MenuTitles.count, 40);
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
            [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, menuButton.bottom) moveForPoint:CGPointMake(WINDOW_WIDTH, menuButton.bottom) lineColor:AllBorderColor]];
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

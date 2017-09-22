//
//  WPExchangeFunctionMenu.m
//  Wongo
//
//  Created by  WanGao on 2017/9/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeFunctionMenu.h"

@interface WPExchangeFunctionMenu ()
{
    FunctionMenuBlock _changeBlock;
}
@property (nonatomic,strong)NSArray * menuImages;
@property (nonatomic,strong)NSArray * menuTitles;
@property (nonatomic,assign)CGRect initBounds;
@property (nonatomic,strong)UIButton * selectButton;
@end
@implementation WPExchangeFunctionMenu

-(instancetype)initWithFrame:(CGRect)frame menuImages:(NSArray *)menuImages menuTitles:(NSArray *)menuTitles
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.menuImages = menuImages;
        self.menuTitles = menuTitles;
        self.y = self.y+self.height+5;
        //重新设置锚点
        CGPoint oldAnchorPoint = self.layer.anchorPoint;
        self.layer.anchorPoint = CGPointMake(0.5,0);
        [self.layer setPosition:CGPointMake(self.layer.position.x + self.layer.bounds.size.width * (self.layer.anchorPoint.x - oldAnchorPoint.x),self.layer.position.y +self.layer.bounds.size.height * (self.layer.anchorPoint.y - oldAnchorPoint.y))];
        self.bounds = CGRectMake(0, 0, 70, 0);
        self.clipsToBounds = YES;
        [self createSubView];
    }
    return self;
}

-(void)createSubView{
    NSInteger count = 0;
    if (self.menuTitles.count>0) {
        count = self.menuTitles.count;
    }
    if (self.menuImages.count>0) {
        count = self.menuImages.count;
    }
    self.height = count*40+5;
    self.initBounds = self.bounds;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchMuneBack"]];
    imageView.frame = self.initBounds;
    [self addSubview:imageView];
    for (int i = 0; i < count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置居中
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:self.menuTitles[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, i * 40 + 5, 70, 40);
        [button addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [button setTitleColor:WongoBlueColor forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            self.selectButton = button;
        }
    }
}

-(void)changeButtonClick:(UIButton*)sender{
    if (_changeBlock) {
        _changeBlock(sender.tag);
        self.selectButton.selected = !self.selectButton.selected;
        sender.selected = !sender.selected;
        self.selectButton = sender;
        [self menuClose];
    }
}

-(void)menuOpen{
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = _initBounds;
        _isOpen = YES;
    }];
}
-(void)menuClose{
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectMake(0, 0, self.width, 0);
        self.isOpen = NO;
    }];
}

-(void)functionMenuClickWithBlock:(FunctionMenuBlock)block{
    _changeBlock = block;
}
@end

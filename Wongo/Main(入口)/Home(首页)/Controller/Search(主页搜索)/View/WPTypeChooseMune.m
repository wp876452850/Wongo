//
//  WPTypeChooseMune.m
//  Wongo
//
//  Created by rexsu on 2017/2/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPTypeChooseMune.h"
#define Titles @[@"造梦",@"交换",@"用户"]

@interface WPTypeChooseMune (){
    ChangeBlock _changeBlock;
}
@property (nonatomic,strong)UIButton * selectButton;
@property (nonatomic,assign)CGRect initBounds;
@end

@implementation WPTypeChooseMune

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //重新设置锚点
        CGPoint oldAnchorPoint = self.layer.anchorPoint;
        self.layer.anchorPoint = CGPointMake(0.5,0);
        [self.layer setPosition:CGPointMake(self.layer.position.x + self.layer.bounds.size.width * (self.layer.anchorPoint.x - oldAnchorPoint.x),self.layer.position.y +self.layer.bounds.size.height * (self.layer.anchorPoint.y - oldAnchorPoint.y))];
        
        self.height = Titles.count*40+5;
        self.initBounds = self.bounds;
        self.bounds = CGRectMake(0, 0, self.width, 0);
        self.clipsToBounds = YES;
        [self createSubView];
    }
    return self;
}

-(void)createSubView{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchMuneBack"]];
    imageView.frame = self.initBounds;
    [self addSubview:imageView];
    
    for (int i = 0; i < Titles.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置居中
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:Titles[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, i * 40 + 5, 70, 40);
        [button addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [button setTitleColor:SelfOrangeColor forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            self.selectButton = button;
        }
    }
}


-(void)changeButtonClick:(UIButton*)sender{
    
    if (_changeBlock) {
        _changeBlock(sender.titleLabel.text);
        self.selectButton.selected = !self.selectButton.selected;
        sender.selected = !sender.selected;
        self.selectButton = sender;
        [self menuClose];
    }
}

-(void)changeTypeWithBlock:(ChangeBlock)block{
    _changeBlock = block;
}

-(void)menuOpen{
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = self.initBounds;
        self.isOpen = YES;
    }];
}
-(void)menuClose{
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectMake(0, 0, self.width, 0);
        self.isOpen = NO;
    }];
}
@end

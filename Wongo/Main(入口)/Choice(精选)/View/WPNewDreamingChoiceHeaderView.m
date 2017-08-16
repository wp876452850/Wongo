//
//  WPNewDreamingChoiceHeaderView.m
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewDreamingChoiceHeaderView.h"
#import "SDCycleScrollView.h"
#import "WPCustomButton.h"
#define SectionMenuTitles @[@" 热门推荐 ",@" 筹备中 ",@" 进行中 "]

@interface WPNewDreamingChoiceHeaderView ()
{
    WPCustomButton * _memoryButton;
    WPNewDreameingChoiceMenuButtonClickBlock _block;
}
//海报
@property (nonatomic,strong)SDCycleScrollView * posters;
@property (nonatomic,strong)NSArray * postersImages;
@property (nonatomic,strong)UIView * menuView;
@end
@implementation WPNewDreamingChoiceHeaderView

-(SDCycleScrollView *)posters{
    if (!_posters) {
        //_posters = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:self.postersImages];
        _posters = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageNamesGroup:@[@"5.jpg",@"6.jpg",@"7.jpg"]];
        _posters.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    }
    return _posters;
}
-(UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_WIDTH, WINDOW_WIDTH, 50)];
        _menuView.backgroundColor = ColorWithRGB(30, 35, 36);
        for (int i = 0; i < 3; i++) {
            WPCustomButton * menuButton = [[WPCustomButton  alloc]initWithFrame:CGRectMake(i*WINDOW_WIDTH/3+i, 10, WINDOW_WIDTH/3-1, 30)];
            if (i == 0) {
                menuButton.selected = YES;
                _memoryButton = menuButton;
            }
            if (i<2) {
                CAShapeLayer * layer = [WPBezierPath drowLineWithMoveToPoint:CGPointMake(menuButton.right, menuButton.y) moveForPoint:CGPointMake(menuButton.right, menuButton.bottom) lineColor:WhiteColor];
                [_menuView.layer addSublayer:layer];
            }            
            menuButton.tag = i;
            [menuButton setBackgroundColor:[UIColor clearColor]];
            menuButton.titleLabel.font = [UIFont systemFontOfSize:15];
            menuButton.normalTitleColor = WhiteColor;
            menuButton.selectedTitleColor = WongoBlueColor;
            NSString * title = SectionMenuTitles[i];
            
            menuButton.normalAttrobuteString = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:title] insertImage:[UIImage imageNamed:@""] atIndex:title.length imageBounds:CGRectMake(0, -3, 15, 15)];
            
            menuButton.selectedAttrobuteString = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:title] insertImage:[UIImage imageNamed:@"exchangesectionmuneselect"] atIndex:title.length imageBounds:CGRectMake(0, -3, 15, 15)];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuClick:)];
            [menuButton addGestureRecognizer:tap];
            [_menuView addSubview: menuButton];
        }
    }
    return _menuView;
}

-(void)menuClick:(UITapGestureRecognizer *)tap{
    WPCustomButton * sender = (WPCustomButton *)tap.view;
    _memoryButton.selected = !_memoryButton.selected;
    sender.selected = !sender.selected;
    _memoryButton = sender;
    _block(tap.view.tag);
}

-(instancetype)initWithPostersImages:(NSArray *)postersImages{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH+50);
        self.postersImages = postersImages;
        [self addSubview:self.posters];
        [self addSubview:self.menuView];
    }
    return self;
}

-(void)menuButtonDidSelectedWithBlock:(WPNewDreameingChoiceMenuButtonClickBlock)block{
    _block = block;
}

@end

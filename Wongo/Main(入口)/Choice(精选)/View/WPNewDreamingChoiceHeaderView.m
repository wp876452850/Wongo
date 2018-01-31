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
#define SectionMenuTitles @[@" 成为梦想人 ",@" 成为造梦人 "]

@interface WPNewDreamingChoiceHeaderView ()
{
    WPCustomButton * _memoryButton;
    WPNewDreameingChoiceMenuButtonClickBlock _block;
}
//海报
@property (nonatomic,strong)SDCycleScrollView * posters;
@property (nonatomic,strong)NSArray * postersImages;
@property (nonatomic,strong)UIImageView * menuView;
@end
@implementation WPNewDreamingChoiceHeaderView

-(SDCycleScrollView *)posters{
    if (!_posters) {
        //_posters = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:self.postersImages];
        _posters = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH - 110) imageNamesGroup:DreamingPosters];
        _posters.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    }
    return _posters;
}
-(UIImageView *)menuView{
    if (!_menuView) {
        _menuView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _posters.bottom, WINDOW_WIDTH, 46)];
        _menuView.userInteractionEnabled = YES;
        _menuView.image = [UIImage imageNamed:@"menuBackground.jpg"];
        _menuView.layer.borderColor = WongoGrayColor.CGColor;
        _menuView.backgroundColor = WhiteColor;
        _menuView.backgroundColor = ColorWithRGB(30, 35, 36);
        for (int i = 0; i < 2; i++) {
            WPCustomButton * menuButton = [[WPCustomButton  alloc]initWithFrame:CGRectMake(i*WINDOW_WIDTH/2+i, 5, WINDOW_WIDTH/2-1, 36)];
            if (i == 0) {
                menuButton.selected = YES;
                _memoryButton = menuButton;
                CAShapeLayer * layer = [WPBezierPath drowLineWithMoveToPoint:CGPointMake(menuButton.right+1.5f, menuButton.y+2.5) moveForPoint:CGPointMake(menuButton.right+1.5f, menuButton.bottom-2.5) lineColor:WhiteColor];
                [_menuView.layer addSublayer:layer];
            }                       
            menuButton.tag = i;
            [menuButton setBackgroundColor:[UIColor clearColor]];
            menuButton.titleLabel.font = [UIFont systemFontOfSize:15];
            menuButton.normalTitleColor = WhiteColor;
            menuButton.selectedTitleColor = WhiteColor;
            NSString * title = SectionMenuTitles[i];
            
            menuButton.normalAttrobuteString = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:title] insertImage:[UIImage imageNamed:@""] atIndex:title.length imageBounds:CGRectMake(0, 0, 9, 9)];
            
            menuButton.selectedAttrobuteString = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:title] insertImage:[UIImage imageNamed:@"exchangesectionmuneselect"] atIndex:title.length imageBounds:CGRectMake(0, 0, 9, 9)];
            
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
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH-65);
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

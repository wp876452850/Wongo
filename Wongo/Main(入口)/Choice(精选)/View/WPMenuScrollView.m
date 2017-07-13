//
//  WPMenuScrollView.m
//  Wongo
//
//  Created by rexsu on 2017/2/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMenuScrollView.h"
#define Window_Bounds [UIScreen mainScreen].bounds
#define Window_Width CGRectGetWidth(Window_Bounds)
#define Window_Height CGRectGetHeight(Window_Bounds)
@interface WPMenuScrollView ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSArray * titles;
@property (nonatomic,strong)NSMutableArray * buttons;
///
//菜单按钮大小
///
@property (nonatomic,assign)CGFloat buttonWidth;
@property (nonatomic,assign)CGFloat buttonHeight;

@property (nonatomic,strong)UIButton * selectButton;

@property (nonatomic,assign)NSInteger select;
//指示横条
@property (nonatomic,strong)UILabel * informationalSign;
@property (nonatomic,assign)CGFloat firstInformationalSignCenterX;

@end
static NSString * contentOffset = @"contentOffset";
@implementation WPMenuScrollView
-(UILabel *)informationalSign{
    if (!_informationalSign) {
        _informationalSign = [[UILabel alloc]initWithFrame:CGRectZero];
        _informationalSign.backgroundColor = [UIColor redColor];
    }
    return _informationalSign;
}
-(instancetype)initWithFrame:(CGRect)frame withOptions:(NSDictionary *)options{
    if (self = [super initWithFrame:frame]) {
        self.titles = [options objectForKey:@"titles"];
        self.buttonWidth = [[options objectForKey:@"width"] floatValue];
        self.buttonHeight = [[options objectForKey:@"height"]floatValue];
        self.height = self.buttonHeight;
        self.width = Window_Width;
        self.contentSize = CGSizeMake(_titles.count * _buttonWidth, 0);
        
        [self createMenuButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)createMenuButton{
    self.buttons = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:menuButton];
        [menuButton setTitle:_titles[i] forState:UIControlStateNormal];
        [menuButton setTitleColor:ColorWithRGB(0, 0, 0) forState:UIControlStateNormal];
        [menuButton setTitleColor:ColorWithRGB(255, 164, 51) forState:UIControlStateSelected];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        CGRect frame = _titles.count*self.buttonWidth>=Window_Width?CGRectMake(i * self.buttonWidth, 20, self.buttonWidth, self.buttonHeight) : CGRectMake(i * Window_Width / _titles.count, 20, Window_Width / _titles.count, self.buttonHeight);
        self.buttonWidth = frame.size.width;
        menuButton.frame = frame;
        if (i == 0) {
            self.selectButton = menuButton;
            menuButton.selected = YES;
            self.informationalSign.bounds = CGRectMake(0, 0, menuButton.width * 0.6, 1);
            self.informationalSign.center = CGPointMake(menuButton.centerX, CGRectGetMaxY(menuButton.frame) - 2);
            _firstInformationalSignCenterX = _informationalSign.centerX;
        }
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        menuButton.tag = i;
        menuButton.backgroundColor = ColorWithRGB(255, 255, 255);
        //menuButton.backgroundColor = RandomColor;
        [self.buttons addObject:menuButton];
    }
    [self addSubview:self.informationalSign];
    [self bringSubviewToFront:_informationalSign];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    self.collectionView.delegate = self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_titles) {
        self.informationalSign.center = CGPointMake(_firstInformationalSignCenterX+scrollView.contentOffset.x / _titles.count, self.informationalSign.centerY);
    }

    int x = scrollView.contentOffset.x;
    int y = Window_Width;
    
    static NSInteger i = MAXFLOAT;
    if (i == x/y) {
        return;
    }
    if (self.informationalSign&&self.buttons) {
        if (x % y == 0) {
            i = x/y;
            UIButton * button = self.buttons[x/y];
            [self menuButtonClick:button];
        }
    }
 
}


-(void)menuButtonClick:(UIButton *)sender{
    static NSInteger i = MAXFLOAT;
    if (self.selectButton&&sender!=self.selectButton) {
        if (sender.tag!=i) {
            i = sender.tag;
            self.collectionView.contentOffset = CGPointMake(WINDOW_WIDTH * sender.tag, 0);
        }
        self.selectButton.selected = !self.selectButton.selected;
        sender.selected = !sender.selected;
        self.selectButton = sender;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.informationalSign.center = CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame) - 2);
        }];
    }
}

-(void)selectMenuWithIndex:(NSInteger)index{
    [self menuButtonClick:self.buttons[index]];
}

@end

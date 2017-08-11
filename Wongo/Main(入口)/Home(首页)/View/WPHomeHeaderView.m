//
//  WPHomeHeaderView.m
//  Wongo
//
//  Created by rexsu on 2017/2/6.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeHeaderView.h"
#import "WPChoiceViewController.h"
#import "LYHomeBannerM.h"
#import "LYActivityController.h"

#define FIRST_IMG_URL @"http://pic.58pic.com/58pic/12/60/18/41b58PIC9Mx.jpg"
#define SECOND_IMG_URL @"http://pic35.photophoto.cn/20150512/0018031445748020_b.jpg"
#define THIRD_IMG_URL @"http://img14.3lian.com/201605/13/6d7f1ae0bef9f44aa3789dc043ff90eb.jpg"
#define FOURTH_IMG_URL @"http://img14.3lian.com/201605/13/74aa1cf4a1110713146b8295967fdfc6.jpg"
#define ROLLPLAYIMAGES @[FIRST_IMG_URL,SECOND_IMG_URL,THIRD_IMG_URL,FOURTH_IMG_URL]
#define FastViewFrame CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), WINDOW_WIDTH, (WINDOW_WIDTH*0.28))
#define ActivityViewFrame CGRectMake(0,CGRectGetMaxY(self.fastView.frame),WINDOW_WIDTH,(WINDOW_WIDTH*0.68)+5)
#define SelfFrame CGRectMake(0, 0, WINDOW_WIDTH, CGRectGetMaxY(self.fastView.frame))
#define LabelFont [UIFont systemFontOfSize:12]

@interface WPHomeHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

//@property (nonatomic,strong)NSArray * rollPlayImages;

@property (nonatomic, strong) UIView * fastView;

@property (nonatomic, strong) UIView *noticeView;

@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIImageView *activityA;
@property (nonatomic, strong) UIImageView *activityB;
@property (nonatomic, strong) UIImageView *activityC;
@property (nonatomic, strong) UIImageView *activityD;
@property (nonatomic, strong) UIImageView *activityE;
@property (nonatomic, strong) UIImageView *activityF;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) NSArray *bannerList;
@end

@implementation WPHomeHeaderView
//活动视图(5个小的分类)
- (UIView *)activityView{
    if (!_activityView) {
        _activityView = [[UIView alloc] initWithFrame:ActivityViewFrame];
        _activityView.backgroundColor = ColorWithRGB(239, 239, 239);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5, WINDOW_WIDTH, 5)];
        line.backgroundColor = [UIColor whiteColor];
        [_activityView addSubview:line];
        CGFloat h = 0.34 * WINDOW_WIDTH;
        CGFloat h2 = 0.29 *WINDOW_WIDTH;
        
        _activityA = [self setUpActivityImageWithFrame:CGRectMake(0, 11, WINDOW_WIDTH * 0.33 , h)];
        _activityB = [self setUpActivityImageWithFrame:CGRectMake(WINDOW_WIDTH * 0.33 + 1, 11, WINDOW_WIDTH * 0.33, h)];
        _activityC = [self setUpActivityImageWithFrame:CGRectMake(WINDOW_WIDTH * 0.66 + 2, 11, WINDOW_WIDTH * 0.33, h)];
        
        _activityD = [self setUpActivityImageWithFrame:CGRectMake(0, 12 + h, WINDOW_WIDTH * 0.33 , h2)];
        _activityE = [self setUpActivityImageWithFrame:CGRectMake(WINDOW_WIDTH * 0.33 + 1, 12 + h, WINDOW_WIDTH * 0.33, h2)];
        _activityF = [self setUpActivityImageWithFrame:CGRectMake(WINDOW_WIDTH * 0.66 + 2, 12 + h, WINDOW_WIDTH * 0.33, h2)];
        
        //点击手势
        _activityA.tag = 0;
        _activityB.tag = 1;
        _activityC.tag = 2;
        _activityD.tag = 3;
        _activityE.tag = 4;
        _activityF.tag = 5;
        
        
        //活动分栏最底部横条
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, h + h2 , WINDOW_WIDTH, 5)];
        bottomLine.top = _activityE.bottom + 1;
        bottomLine.backgroundColor = [UIColor whiteColor];
        [_activityView addSubview:bottomLine];
        
    }
    return _activityView;
}

-(UIImageView *)setUpActivityImageWithFrame:(CGRect)frame{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [imageView addGestureRecognizer:tapA];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.activityView addSubview:imageView];
    return imageView;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.fastView];
        [self addSubview:self.activityView];
        self.frame = SelfFrame;
        [self createWizardButton];
    }
    return self;
}
- (void)tapImage:(UITapGestureRecognizer *)tap{
    if (tap.view.tag >= self.listhk.count) {
        return;
    }
    LYHomeCategory *category = self.listhk[tap.view.tag];
    [[self findViewController:self].navigationController pushViewController:[LYActivityController controllerWithCategory:category] animated:YES];
}
-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame delegate:self placeholderImage:nil];
        _cycleScrollView.currentPageDotColor = [UIColor redColor];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleScrollView;
}
- (void)setListhk:(NSArray<LYHomeCategory *> *)listhk{
    _listhk = listhk;
    if (listhk.count <= 0) {
        return;
    }
    [_activityA sd_setImageWithURL:[NSURL URLWithString:listhk[0].url] placeholderImage:nil];
    CGFloat h = 0.34 * WINDOW_WIDTH + 12;
    self.height = SelfFrame.size.height + h + 6;
    self.bottomLine.y = h;
    if (listhk.count >= 2) {
        [_activityB sd_setImageWithURL:[NSURL URLWithString:listhk[1].url] placeholderImage:nil];
    }
    if (listhk.count >= 5) {
        CGFloat h2 = 0.29 *WINDOW_WIDTH + 12;
        self.height = SelfFrame.size.height + h + h2 + 6;
        self.bottomLine.y = h + h2;
        [_activityC sd_setImageWithURL:[NSURL URLWithString:listhk[2].url] placeholderImage:nil];
        [_activityD sd_setImageWithURL:[NSURL URLWithString:listhk[3].url] placeholderImage:nil];
        [_activityE sd_setImageWithURL:[NSURL URLWithString:listhk[4].url] placeholderImage:nil];
    }
    
}

- (void)setListhl:(NSArray<LYHomeCategory *> *)listhl{
    _listhl = listhl;
    NSMutableArray *arr = [NSMutableArray array];
    for (LYHomeCategory *category in listhl) {
        [arr addObject:category.url];
    }
    //如果数据存在，则返回数据滚动图，若不存在则用自定义图
    _cycleScrollView.imageURLStringsGroup = arr.count?arr:ROLLPLAYIMAGES;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    LYHomeCategory *category = self.listhl[index];
    [[self findViewController:self].navigationController pushViewController:[LYActivityController controllerWithCategory:category] animated:YES];
    
}
-(UIView *)fastView{
    if (!_fastView) {
        _fastView = [[UIView alloc]initWithFrame:FastViewFrame];
        _fastView.backgroundColor = ColorWithRGB(255, 255, 255);
    }
    return _fastView;
}

-(void)createWizardButton{
    NSArray * titles = @[@"交换",@"造梦",@"发布",@"交换流程"];
    NSArray * images = @[@"mainExchange",@"mainDreaming",@"mainPush",@"mainCourse"];
    CGFloat w = WINDOW_WIDTH * 0.133;
    NSUInteger count = images.count;
    CGFloat m = (WINDOW_WIDTH - count * w)/(count+1);
    CGFloat mL = 8;
    CGFloat y = (self.fastView.height - w - mL - 12) * 0.5;
    for (int i = 0; i < count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1;
        CGFloat x = m + (i % count)*(w + m);
        button.frame = CGRectMake(x, y , w, w);
        
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [self.fastView addSubview:button];
        
        UILabel * label = [[UILabel alloc]init];
        label.font = LabelFont;
        label.textColor = ColorWithRGB(155, 155, 155);
        label.text = titles[i];
        [self.fastView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button.mas_centerX);
            make.top.mas_equalTo(button.mas_bottom).offset(mL);
        }];
        
    }
}
-(void)buttonClick:(UIButton *)sender{
    if (sender.tag == 4) {
        //FIXME:未开放
        [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
        return;
    }
    NSInteger i = sender.tag;
    if (sender.tag == 2) {
        sender.tag = 1;
    }
    WPTabBarController * tabbar = [WPTabBarController sharedTabbarController];
    [tabbar btnClick:sender];
    if (i == 1 || i == 2) {
        UINavigationController * nav = [tabbar selectedViewController];
        WPChoiceViewController * vc = [nav.viewControllers lastObject];
        [vc.menuScrollView selectMenuWithIndex:i-1];
    }
    sender.tag = i;
}
@end

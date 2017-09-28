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
#import "LYBaseController.h"

#define FIRST_IMG_URL @""
#define SECOND_IMG_URL @"http://pic35.photophoto.cn/20150512/0018031445748020_b.jpg"
#define THIRD_IMG_URL @"http://img14.3lian.com/201605/13/6d7f1ae0bef9f44aa3789dc043ff90eb.jpg"
#define FOURTH_IMG_URL @"http://img14.3lian.com/201605/13/74aa1cf4a1110713146b8295967fdfc6.jpg"
#define ROLLPLAYIMAGES @[FIRST_IMG_URL,SECOND_IMG_URL,THIRD_IMG_URL,FOURTH_IMG_URL]
#define FastViewFrame CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), WINDOW_WIDTH, 127.5)
#define ActivityViewFrame CGRectMake(0,CGRectGetMaxY(self.announcementView.frame)+8,WINDOW_WIDTH,232.5*(WINDOW_WIDTH/375)+20)
#define SelfFrame CGRectMake(0, 0, WINDOW_WIDTH, CGRectGetMaxY(self.activityView.frame))
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
/**公告*/
@property (nonatomic,strong)UIView * announcementView;

@property (nonatomic, strong) NSArray *bannerList;
@end

@implementation WPHomeHeaderView

-(UIView *)announcementView{
    if (!_announcementView) {
        _announcementView = [[UIView alloc]initWithFrame:CGRectMake(0, self.fastView.bottom, WINDOW_WIDTH, 40)];
        [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, self.fastView.bottom) moveForPoint:CGPointMake(WINDOW_WIDTH, self.fastView.bottom)]];
        _announcementView.backgroundColor = WhiteColor;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, WINDOW_WIDTH, 40);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"  活动公告:(开学啦!同学有礼)分享可得大礼" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"horn"] forState:UIControlStateNormal];
        [_announcementView addSubview:button];
    }
    return _announcementView;
}
//活动视图(3个小的分类)
- (UIView *)activityView{
    if (!_activityView) {
        _activityView = [[UIView alloc] initWithFrame:ActivityViewFrame];
        _activityView.backgroundColor = WhiteColor;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5, WINDOW_WIDTH, 5)];
        line.backgroundColor = [UIColor whiteColor];
        [_activityView addSubview:line];
        
        CGFloat w  = 142*(WINDOW_WIDTH/375);
        CGFloat h  = 232.5*(WINDOW_WIDTH/375);
        
        _activityA = [self setUpActivityImageWithFrame:CGRectMake(2.5, 10, w , h) actitvityState:0];
        _activityB = [self setUpActivityImageWithFrame:CGRectMake(_activityA.right+2.5, 10, WINDOW_WIDTH-7.5-w, (h-2.5)/2) actitvityState:1];
        _activityC = [self setUpActivityImageWithFrame:CGRectMake(_activityA.right+2.5, _activityB.bottom+2.5, WINDOW_WIDTH-7.5-w, (h-2.5)/2) actitvityState:3];
        
        //点击手势
        _activityA.tag = 0;
        _activityB.tag = 1;
        _activityC.tag = 2;
        
        
        
        //活动分栏最底部横条
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, h  , WINDOW_WIDTH, 5)];
        bottomLine.top = _activityC.bottom + 1;
        bottomLine.backgroundColor = [UIColor whiteColor];
        [_activityView addSubview:bottomLine];
        
    }
    return _activityView;
}

-(UIImageView *)setUpActivityImageWithFrame:(CGRect)frame actitvityState:(NSInteger)actitvityState{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.tag = actitvityState;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    self.backgroundColor = WongoGrayColor;
    [imageView addGestureRecognizer:tapA];
    imageView.backgroundColor = [UIColor whiteColor];
    [_activityView addSubview:imageView];
    return imageView;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.fastView];
        [self addSubview:self.announcementView];
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
    LYActivityController * vc = [LYActivityController controllerWithCategory:category];
    vc.activityState = tap.view.tag;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame delegate:self placeholderImage:nil];
        _cycleScrollView.currentPageDotColor = [UIColor redColor];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadimage"];
    }
    return _cycleScrollView;
}
- (void)setListhk:(NSArray<LYHomeCategory *> *)listhk{
    _listhk = listhk;
    if (listhk.count <= 0) {
        return;
    }
    _activityA.image = [UIImage imageNamed:@"activity1.jpg"];
    _activityB.image = [UIImage imageNamed:@"activity2.jpg"];
    _activityC.image = [UIImage imageNamed:@"activity3.jpg"];
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
        LYBaseController * vc = [[LYBaseController alloc]init];
        vc.myNavItem.title = @"教程";
        UIScrollView * sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
        
        UIImage * image = [UIImage imageNamed:@"jiaocheng.jpg"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(0, 0, WINDOW_WIDTH, image.size.height/2*WINDOW_WIDTH/375);
        sv.contentSize = imageView.size;
        [vc.view addSubview:sv];
        [sv addSubview:imageView];
        [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];;
        return;
    }
    NSInteger i = sender.tag;
    if (sender.tag == 2) {
        sender.tag = 1;
    }
    
    WPTabBarController * tabbar = [WPTabBarController sharedTabbarController];
    if (sender.tag == 3) {
        sender.tag = 2;
    }
    [tabbar btnClick:sender];
    if (i == 1 || i == 2) {
        UINavigationController * nav = [tabbar selectedViewController];
        WPChoiceViewController * vc = [nav.viewControllers lastObject];
        [vc.menuScrollView selectMenuWithIndex:i-1];
    }
    sender.tag = i;
}
@end

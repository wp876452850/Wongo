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
#define FastViewFrame CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), WINDOW_WIDTH, (30+79+15)*2)
#define ActivityViewFrame CGRectMake(0,CGRectGetMaxY(self.announcementView.frame)+8,WINDOW_WIDTH,232.5*(WINDOW_WIDTH/375)+20)
#define SelfFrame CGRectMake(0, 0, WINDOW_WIDTH, CGRectGetMaxY(self.activityView.frame))
#define LabelFont [UIFont systemFontOfSize:12]

@interface WPHomeHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

//@property (nonatomic,strong)NSArray * rollPlayImages;

@property (nonatomic, strong) UIImageView * fastView;

@property (nonatomic, strong) UIView *noticeView;

@property (nonatomic, strong) UIView *activityView;

@property (nonatomic, strong) UIView *bottomLine;
/**公告*/
@property (nonatomic, strong) UIView * announcementView;

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
        _activityC = [self setUpActivityImageWithFrame:CGRectMake(_activityA.right+2.5, _activityB.bottom+2.5, WINDOW_WIDTH-7.5-w, (h-2.5)/2) actitvityState:2];
        
        //点击手势
        _activityA.tag = 5;
        _activityB.tag = 6;
        _activityC.tag = 7;
        
        
        
        //活动分栏最底部横条
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, h  , WINDOW_WIDTH, 5)];
        bottomLine.top = _activityC.bottom + 1;
        bottomLine.backgroundColor = [UIColor whiteColor];
        [_activityView addSubview:bottomLine];
        
    }
    return _activityView;
}

-(UIButton *)setUpActivityImageWithFrame:(CGRect)frame actitvityState:(NSInteger)actitvityState{
    UIButton * imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame = frame;
    imageView.tag = actitvityState;
    [imageView addTarget:self action:@selector(tapImage:) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = WongoGrayColor;
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

- (void)tapImage:(UIButton *)sender{
    if (sender.tag >= self.listhk.count) {
        return;
    }
    LYHomeCategory *category = self.listhk[sender.tag];
    LYActivityController * vc = [LYActivityController controllerWithCategory:category];
    vc.activityState = sender.tag;
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
    [_activityA setBackgroundImage:[UIImage imageNamed:@"activity1.jpg"] forState:UIControlStateNormal] ;
    [_activityB setBackgroundImage:[UIImage imageNamed:@"activity2.jpg"] forState:UIControlStateNormal];
    [_activityC setBackgroundImage:[UIImage imageNamed:@"activity3.jpg"] forState:UIControlStateNormal] ;
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
    LYActivityController * vc = [LYActivityController controllerWithCategory:category];
    vc.activityState = index;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
    
}
-(UIImageView *)fastView{
    if (!_fastView) {
        _fastView = [[UIImageView alloc]initWithFrame:FastViewFrame];
        _fastView.userInteractionEnabled = YES;
//        _fastView.image = [UIImage imageNamed:@"homeiconbackground.jpg"];
        _fastView.backgroundColor = ColorWithRGB(255, 255, 255);
    }
    return _fastView;
}

-(void)createWizardButton{
    NSArray * titles = @[@"造梦",@"交换",@"寄卖",@"分享奖励",@"公益换新",@"闲置换新",@"造梦流程",@"发布商品"];
    NSArray * images = @[@"homeDreaming",@"homeExchange",@"homeConsignment",@"homefenxiang",@"homegongyi",@"homexianzhi",@"homeCourse",@"homePush"];
    //NSArray * titles = @[@"造梦",@"交换",@"发布",@"造梦流程"];
    //NSArray * images = @[@"mainDreaming",@"mainExchange",@"mainPush",@"homeCourse"];
    
    CGFloat w = 74;
    CGFloat m = (WINDOW_WIDTH - 4 * w)/(4+1);
    for (int i = 0; i < images.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * icon = [UIImage imageNamed:images[i]];
        if (i == 3||i == 4||i == 5) {
            button.tag = i-3;
            [button addTarget:self action:@selector(tapImage:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 1;
        }
        
        
        CGFloat x = m + (i % 4)*(w + m);
        CGFloat y = 30+(w+5+20)*(i/4);
        button.frame = CGRectMake(x, y , icon.size.width, icon.size.height);
        
        [button setBackgroundImage:icon forState:UIControlStateNormal];
        [self.fastView addSubview:button];
        
        UILabel * label = [[UILabel alloc]init];
        label.font = LabelFont;
        label.textColor = ColorWithRGB(155, 155, 155);
        label.text = titles[i];
        [self.fastView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button.mas_centerX);
            make.top.mas_equalTo(button.mas_bottom);
        }];
    }
}

-(void)buttonClick:(UIButton *)sender{
    //教程
    if (sender.tag == 7) {
        LYBaseController * vc = [[LYBaseController alloc]init];
        vc.myNavItem.title = @"教程";
        UIScrollView * sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
        
        UIImage * image = [UIImage imageNamed:@"jiaocheng.jpg"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(0, 0, WINDOW_WIDTH, image.size.height/2*WINDOW_WIDTH/375);
        sv.contentSize = imageView.size;
        [vc.view addSubview:sv];
        [sv addSubview:imageView];
        [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
        return;
    }
    
    NSInteger i = sender.tag;
    if (sender.tag == 1||sender.tag == 2||sender.tag == 3) {
        sender.tag = 1;
    }
    if (sender.tag == 8) {
        sender.tag = 2;
    }
    WPTabBarController * tabbar = [WPTabBarController sharedTabbarController];
    [tabbar btnClick:sender];
    
    if (i == 1||i == 2||i == 3) {
        UINavigationController * nav = [tabbar selectedViewController];
        WPChoiceViewController * vc = [nav.viewControllers lastObject];
        [vc.menuScrollView selectMenuWithIndex:i-1];
    }
    
    sender.tag = i;
    
}
@end

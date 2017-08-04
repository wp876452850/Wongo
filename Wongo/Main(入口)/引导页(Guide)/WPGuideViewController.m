//
//  WPGuideViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/8/1.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPGuideViewController.h"
#define GuideImages @[@"guanggao.jpg",@"yindao1.jpg",@"yundao2.jpg"]
#import "WPTabBarController.h"

@interface WPGuideViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * guideScrollView;
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic,strong)UIButton * passButton;
@end

@implementation WPGuideViewController
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        _pageControl.centerX = self.view.centerX;
        _pageControl.centerY = WINDOW_HEIGHT - 60;
        _pageControl.pageIndicatorTintColor = ColorWithRGB(222, 222, 222);
        _pageControl.currentPageIndicatorTintColor = SelfOrangeColor;
        _pageControl.numberOfPages = GuideImages.count;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
-(UIButton *)passButton{
    if (!_passButton) {
        _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _passButton.frame = CGRectMake(self.guideScrollView.contentSize.width - 120, 30, 120, 30);
        _passButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _passButton.backgroundColor = [UIColor clearColor];
        [_passButton setTintColor:SelfOrangeColor];
        [_passButton setTitle:@"点击进入>>>" forState:UIControlStateNormal];
        [_passButton addTarget:self action:@selector(pass) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passButton;
}
-(UIScrollView *)guideScrollView{
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _guideScrollView.contentSize = CGSizeMake(GuideImages.count * WINDOW_WIDTH, 0);
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.delegate = self;
        for (int i = 0; i<GuideImages.count; i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:GuideImages[i]]];
            imageView.frame = CGRectMake(WINDOW_WIDTH * i, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
            imageView.backgroundColor = WhiteColor;
            [_guideScrollView addSubview:imageView];
        }
        [self.guideScrollView addSubview:self.passButton];
    }
    return _guideScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.guideScrollView];
    [self.view addSubview:self.pageControl];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger offset_x = scrollView.contentOffset.x;
    NSInteger window_width = WINDOW_WIDTH;
    if (offset_x % window_width == 0) {
        NSInteger page = offset_x/window_width;
        self.pageControl.currentPage = page;
    }
}

-(void)pass{
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    [self.navigationController pushViewController:tabBar animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;

}
@end

//
//  WPDreamingDetailRecommendPageViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDetailRecommendPageViewController.h"
#define RecommendImages @[@"danbaojiaohuan.jpg",@"zaixiankefu.jpg",@"kefudianhua.jpg",@"guanfangweixin.jpg"]

@interface WPDreamingDetailRecommendPageViewController ()<UIScrollViewDelegate>

@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,strong)UIScrollView * guideScrollView;

@property (nonatomic,strong)UIPageControl * pageControl;

@property (nonatomic,strong)UIButton * backButton;

@end

@implementation WPDreamingDetailRecommendPageViewController

//返回按钮
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backButton;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        _pageControl.centerX = self.view.centerX;
        _pageControl.centerY = WINDOW_HEIGHT - 60;
        _pageControl.pageIndicatorTintColor = ColorWithRGB(222, 222, 222);
        _pageControl.currentPageIndicatorTintColor = SelfOrangeColor;
        _pageControl.numberOfPages = RecommendImages.count;
        _pageControl.currentPage = self.currentPage;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
-(UIScrollView *)guideScrollView{
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _guideScrollView.contentSize = CGSizeMake(RecommendImages.count * WINDOW_WIDTH, 0);
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.delegate = self;
        _guideScrollView.showsHorizontalScrollIndicator = NO;
        _guideScrollView.backgroundColor = WhiteColor;
        _guideScrollView.contentOffset = CGPointMake(WINDOW_WIDTH*self.currentPage, 0);
        for (int i = 0; i<RecommendImages.count; i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:RecommendImages[i]]];
            imageView.userInteractionEnabled = YES;
            if (i == 1){
                
            }
            else if (i == 2){
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.bounds = CGRectMake(0, 0, 80, 40);
            }
            else if (i == 3){
                
                
            }
            imageView.frame = CGRectMake(WINDOW_WIDTH * i, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
            imageView.backgroundColor = WhiteColor;
            [_guideScrollView addSubview:imageView];
        }
    }
    return _guideScrollView;
}

-(instancetype)initWithCurrentPage:(NSInteger)currentPage{
    if (self = [super init]) {
        self.currentPage = currentPage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.guideScrollView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.backButton];
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

@end

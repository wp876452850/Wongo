//
//  WPDreamingDetailRecommendPageViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDetailRecommendPageViewController.h"
#import "LYConversationController.h"

#define RecommendImages @[@"danbaojiaohuan.jpg",@"zaixiankefu.jpg",@"kefudianhua.jpg",@"guanfangweixin.jpg"]

@interface WPDreamingDetailRecommendPageViewController ()<UIScrollViewDelegate>
{
    NSString * _uid;
    NSString * _uname;
}
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
        _pageControl.currentPageIndicatorTintColor = SelfThemeColor;
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
            imageView.frame = CGRectMake(WINDOW_WIDTH * i, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
            imageView.backgroundColor = WhiteColor;
            imageView.userInteractionEnabled = YES;
            if (i == 1){
                for (int i = 0; i<2; i++) {
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(0, 0, 100, 30);
                    button.bottom = WINDOW_HEIGHT - 130 - (i*120);
                    button.centerX = imageView.width/2;
                    [button setTitle:@[@"联系客服",@"联系用户"][i] forState:UIControlStateNormal];
                    [button setTitleColor:SelfThemeColor forState:UIControlStateNormal];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 5.f;
                    button.layer.borderWidth = 1.f;
                    button.layer.borderColor = SelfThemeColor.CGColor;
                    button.tag = i;
                    [button addTarget:self action:@selector(goChat:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, button.y - 40, WINDOW_WIDTH, 20)];
                    label.text = @[@"联系客服",@"联系用户"][i];
                    label.font = [UIFont systemFontOfSize:18.f];
                    label.textAlignment = NSTextAlignmentCenter;
                    
                    [imageView addSubview:button];
                    [imageView addSubview:label];
                }
                
            }
            else if (i == 2){
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, 100, 30);
                button.centerX = imageView.width/2;
                button.centerY = WINDOW_HEIGHT*0.65;
                [button setTitle:@"拨打电话" forState:UIControlStateNormal];
                [button setTitleColor:SelfThemeColor forState:UIControlStateNormal];
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 5.f;
                button.layer.borderWidth = 1.f;
                button.layer.borderColor = SelfThemeColor.CGColor;

                [button addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
            }
            else if (i == 3){
                
                
            }
            
            [_guideScrollView addSubview:imageView];
        }
    }
    return _guideScrollView;
}

-(instancetype)initWithCurrentPage:(NSInteger)currentPage uid:(NSString *)uid uname:(NSString *)uname{
    if (self = [super init]) {
        self.currentPage = currentPage;
        _uid    = uid;
        _uname  = uname;
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


-(void)callPhone{
    [self makePhoneCallWithTelNumber:@"15359026907"];
}

-(void)goChat:(UIButton *)sender{
    if (sender.tag == 1) {
        [self goChatWithUid:_uid uname:_uname];
        return;
    }
    [self goChatWithUid:@"1" uname:@"官方客服"];
}

-(void)goChatWithUid:(NSString *)uid uname:(NSString *)uname{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:uid];
        vc.title = uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

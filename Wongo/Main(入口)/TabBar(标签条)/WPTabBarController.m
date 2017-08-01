//
//  WPTabBarController.m
//  Wogou
//
//  Created by rexsu on 2016/11/29.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import "WPTabBarController.h"
#import "WPHomeViewController.h"
#import "WPMyViewController.h"
#import "WPPublishViewController.h"
#import "WPChoiceViewController.h"
#import "LYNavgationController.h"

#define Home_Icon_Name @"1"
#define My_Icon_Name @"2"
#define Publish_Icon_Name @"3"
#define Choiceness_Icon_Name @"4"

#define IconArray @[@"home_normal",@"select_normal",@"push_normal",@"mine"];
//#define IconArray @[@"homepage",@"Selected",@"Release",@"My"];
#define SelectIconArray @[@"Home_select",@"select_select",@"push_select",@"mine_select"];

#define TitleArray @[@"首页",@"交换",@"发布",@"我的"]

static id tabBar;

@interface WPTabBarController ()
//自定义标签条
@property (nonatomic,strong)UIView * footView;
//正常状态图标数组
@property (nonatomic,strong)NSArray * iconArray;
//高亮状态图标数组
@property (nonatomic,strong)NSArray * selectIconArray;
//icon对应标题
@property (nonatomic,strong)NSArray * titleArray;
//储存所有标题
@property (nonatomic,strong)NSMutableArray * titleLabels;
//储存所以图标
@property (nonatomic,strong)NSMutableArray * icons;
//记录高亮按钮文字
@property (nonatomic,strong)UILabel * label;
//记录高亮图片
@property (nonatomic,strong)UIImageView * imageView;
//消息红点
@property (nonatomic, strong) UIView *redDot;
@end

@implementation WPTabBarController
#pragma mark - 懒加载
-(NSMutableArray *)icons
{
    if (!_icons) {
        _icons = [NSMutableArray arrayWithCapacity:3];
    }
    return _icons;
}
-(NSMutableArray *)titleLabels
{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray arrayWithCapacity:3];
    }
    return _titleLabels;
}
- (NSArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = IconArray;
    }
    return _iconArray;
}
- (NSArray *)selectIconArray
{
    if (!_selectIconArray) {
        _selectIconArray = SelectIconArray;
    }
    return _selectIconArray;
}
-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = TitleArray;
    }
    return _titleArray;
}
- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 49)];
        _footView.backgroundColor = [UIColor whiteColor];
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(WINDOW_WIDTH * 0.89 , 5, 6.5, 6.5)];
        _redDot.backgroundColor = [UIColor redColor];
        _redDot.layer.cornerRadius = 3.25;
        _redDot.layer.masksToBounds = YES;
        [_footView addSubview:_redDot];
        [self createIconButton];
    }
    return _footView;
}
- (void)changeRedDot{
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:User_ID];
    if (uid.length > 0) {
        self.redDot.hidden = ![RCIMClient sharedRCIMClient].getTotalUnreadCount;
    }else{
        self.redDot.hidden = YES;
    }
}
#pragma mark - 创建单例模式
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (tabBar == nil) {
        
        @synchronized(self) {
            
            if(tabBar == nil) {
                
                tabBar = [super allocWithZone:zone];
                
            }
            
        }
        
    }
    return tabBar;
}

+ (instancetype)sharedTabbarController {
    
    if (tabBar == nil) {
        
        @synchronized(self) {
            
            if(tabBar == nil) {
                
                tabBar = [[self alloc] init];
            }
        }
    }
    return tabBar;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return tabBar;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeRedDot];
    //删除系统自带的tabBarButton
    for (UIView *tabBarButton in self.tabBar.subviews)
    {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [tabBarButton removeFromSuperview];
        }
    }
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.tabBar addSubview:self.footView];
    
    WPHomeViewController * vc1 = [[WPHomeViewController alloc]init];
    [self createChildViewController:vc1];
    
    WPChoiceViewController * vc2 = [[WPChoiceViewController alloc]init];
    [self createChildViewController:vc2];
    
    UIViewController * vc3 = [[UIViewController alloc]init];
    [self createChildViewController:vc3];
    
    WPMyViewController * vc4 = [[WPMyViewController alloc]init];
    [self createChildViewController:vc4];
    //第三个按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.bounds = CGRectMake(0,0,24,24);
    button.center = CGPointMake(2 * WINDOW_WIDTH / 4 + WINDOW_WIDTH / 8, 15);
    [_footView addSubview:button];
    [button addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CHANGE_REDDOT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self changeRedDot];
    }];
    
}
#pragma mark - 创建子试图控制器
- (void)createChildViewController:(UIViewController *)viewController{
    UINavigationController * nav = [[LYNavgationController alloc]initWithRootViewController:viewController];
    
    nav.navigationBarHidden = YES;
    [self addChildViewController:nav];
}
#pragma mark - 创建tabBarItem按钮
- (void)createIconButton
{
    for (int i = 0; i < 4; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;

        btn.bounds = CGRectMake(0,0,WINDOW_WIDTH / 4,49);
        btn.center = CGPointMake(i * WINDOW_WIDTH / 4 + WINDOW_WIDTH / 8, 17);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:btn];
        
        UILabel * lab = [[UILabel alloc]init];
        lab.bounds = CGRectMake(0,0,50,20);
        lab.center = CGPointMake(i * WINDOW_WIDTH / 4 + WINDOW_WIDTH / 8, 40);
        lab.text = self.titleArray[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = ColorWithRGB(101, 101, 101);
        [self.footView addSubview:lab];
        
        
        UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.iconArray[i]]];
        img.bounds = CGRectMake(0,0,24,24);
        img.center = CGPointMake(i * WINDOW_WIDTH / 4 + WINDOW_WIDTH / 8, 17);
        [self.footView addSubview:img];
        img.tag = i;
        
       
        if (i == 0)
        {
            img.image = [UIImage imageNamed:self.selectIconArray[i]];
            self.imageView = img;
            lab.textColor = ColorWithRGB(255, 145, 5);
            self.label = lab;
        }
        [self.titleLabels addObject:lab];
        [self.icons addObject:img];
    }

}

-(void)btnClick:(UIButton*)btn{
    if (btn.tag == 2) {
        [self postBtnClick];
        return;
    }
    self.label.textColor = ColorWithRGB(101, 101, 101);
    UILabel * lab = self.titleLabels[btn.tag];
    lab.textColor = ColorWithRGB(255, 145, 5);
    self.label = lab;
    self.imageView.image = [UIImage imageNamed:self.iconArray[_imageView.tag]];
    UIImageView * img = self.icons[btn.tag];
    img.image = [UIImage imageNamed:self.selectIconArray[btn.tag]];

    self.imageView = img;
    self.selectedIndex = btn.tag;
    
}


#pragma mark - 隐藏/开启标签条
-(void)setTabbarHiddenWhenPushed:(BOOL)tabbarHiddenWhenPushed
{
    _tabbarHiddenWhenPushed = tabbarHiddenWhenPushed;
    _footView.hidden        = tabbarHiddenWhenPushed;
    self.tabBar.hidden      = tabbarHiddenWhenPushed;
}
#pragma mark - 第三个界面跳转方式
-(void)postBtnClick{
    WPPublishViewController * vc3 = [[WPPublishViewController alloc]init];

    
    if (User_MobileVersion>=8.0) {
        vc3.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [self presentViewController:vc3 animated:YES completion:nil];
}


@end

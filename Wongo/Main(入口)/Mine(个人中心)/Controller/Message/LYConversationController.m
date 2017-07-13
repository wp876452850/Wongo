//
//  LYConversationController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYConversationController.h"

@interface LYConversationController ()

@property (strong, nonatomic) UINavigationBar *myNavBar;
@property (strong, nonatomic) UINavigationItem *myNavItem;

@end

@implementation LYConversationController

-(UINavigationBar *)myNavBar{
    if (!_myNavBar) {
        _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        _myNavBar.translucent = NO;
        _myNavBar.barTintColor = ColorWithRGB(33, 34, 35);
        
    }
    return _myNavBar;
}

- (UINavigationItem *)myNavItem{
    if (!_myNavItem) {
        _myNavItem = [[UINavigationItem alloc] init];
    }
    return _myNavItem;
}
- (void)setTitle:(NSString *)title{
    self.myNavItem.title = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
    
    //隐藏定位、视频通话 0-图片 1-相机 2-位置 3-语音  4-视频
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:4];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfo) name:@"rcimReloadUserInfo" object:nil];
}

- (void)reloadUserInfo{
    [self.conversationMessageCollectionView reloadData];
}
//MARK:- 导航栏设置
- (void)setNavigationBar{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.myNavBar];
    self.myNavBar.items = @[self.myNavItem];
    //设置文字颜色的属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    _myNavBar.titleTextAttributes = attr;

    self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.myNavItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

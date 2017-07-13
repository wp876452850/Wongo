//
//  LYConversationListController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYConversationListController.h"
#import "LYConversationController.h"

@interface LYConversationListController ()
@property (strong, nonatomic) UINavigationBar *myNavBar;
@property (strong, nonatomic) UINavigationItem *myNavItem;
@end

@implementation LYConversationListController
-(UINavigationBar *)myNavBar{
    if (!_myNavBar) {
        _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        _myNavBar.barTintColor = ColorWithRGB(33, 34, 35);
        _myNavBar.translucent = NO;
    }
    return _myNavBar;
}

- (UINavigationItem *)myNavItem{
    if (!_myNavItem) {
        _myNavItem = [[UINavigationItem alloc] init];
    }
    return _myNavItem;
}
//MARK:- 设置导航栏
- (void)setNavigationBar{
    self.myNavItem.title = @"消息";
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.myNavBar];
    self.myNavBar.items = @[self.myNavItem];
    //设置文字颜色的属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    _myNavBar.titleTextAttributes = attr;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.myNavItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self setTableView];
    [self setConversationList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfo) name:@"rcimReloadUserInfo" object:nil];
}
- (void)reloadUserInfo{
    [self.conversationListTableView reloadData];
}
//MARK:- 设置会话相关方法
- (void)setConversationList{
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@1,@2,@3,@4,@5,@6,@7,@8,@9]];
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    //    self.isShowNetworkIndicatorView = NO;
    self.showConnectingStatusOnNavigatorBar = YES;
    //设置列表为空时显示的View
    self.emptyConversationView = [[UIView alloc] init];
    
}
//MARK:- 设置tableView界面
- (void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.conversationListTableView.backgroundColor = ColorWithRGB(239, 239, 239);
    self.conversationListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
//MARK:- 继承的融云方法
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    LYConversationController *conversationVC = [[LYConversationController alloc]init];
    conversationVC.displayUserNameInCell = NO;
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_REDDOT" object:nil];
}
@end

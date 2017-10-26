//
//  WPMyViewController.m
//  我的
//
//  Created by rexsu on 2016/11/25.
//  Copyright © 2016年 Winny. All rights reserved.
//  

#import "WPMyViewController.h"

#import "LoginViewController.h"
//表子试图控制器
#import "WPMyOrderViewController.h"
#import "WPShopingCarViewController.h"
#import "WPAddressViewController.h"
#import "WPMyShopViewController.h"
#import "WPCommodityManagementViewController.h"
#import "WPExchangeOrderViewController.h"
#import "WPMyDreamingViewController.h"
#import "WPDreamingOrderViewController.h"
#import "WPStoreViewController.h"
#import "WPMyTableViewCell.h"



#define CELL_ID @"cell"

#define Cell_title_array @[@"商品管理",@"交换订单",@"收货地址",@"造梦计划",@"造梦订单",@"我的主页"]
#define Cell_Icon_Array @[@"commodityManagement",@"tradeOrders",@"address",@"dreamingPlan",@"myOrder",@"myShop"]


#define Self_NavigationBarTintColor ColorWithRGB(33, 34, 35)
//表的一个区头试图高度
#define TABLEVIEW_TOPVIEW_HEIGHT 350

@interface WPMyViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 个人中心功能表
 */
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * cellTitleArray;

@property (nonatomic,strong)NSArray * cellIconArray;

@end

@implementation WPMyViewController

#pragma mark - 懒加载
-(NSArray *)cellTitleArray
{
    if (!_cellTitleArray) {
        _cellTitleArray = Cell_title_array;
        _cellIconArray = Cell_Icon_Array;
    }
    return _cellTitleArray;
}

-(UITableView *)tableView
{
    if (!_tableView ) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(TABLEVIEW_TOPVIEW_HEIGHT, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WPMyTableViewCell class] forCellReuseIdentifier:CELL_ID];
        _tableView.rowHeight = 60;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self selectionStateInterface];
    [self setUpNavigationBarStyle];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CHANGE_REDDOT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self.userInformationView changeMessageBtnDot];
    }];
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    BOOL isYesOrNo = [[[NSUserDefaults standardUserDefaults] objectForKey:IsMySubViewController] floatValue];
    if (isYesOrNo == 1) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:IsMySubViewController];
    }
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    tabBar.tabbarHiddenWhenPushed = NO;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //判断登录状态是否改变
    NSString * isChangeUserID = [defaults objectForKey:User_ID_ISChange];
    NSString * userID = [defaults objectForKey:User_ID];
    if (isChangeUserID.length!=userID.length) {
        [defaults setObject:userID forKey:User_ID_ISChange];
        [self selectionStateInterface];
    }
    [self.userInformationView changeMessageBtnDot];
    [tabBar changeRedDot];
}

//更改导航条样式
- (void)setUpNavigationBarStyle{
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName: [UIColor whiteColor]};

    self.navigationController.navigationBar.barTintColor = Self_NavigationBarTintColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}  
#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPMyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.title.text = self.cellTitleArray[indexPath.row];
    cell.icon.image = [UIImage imageNamed:self.cellIconArray[indexPath.row]];
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    return cell;
}


#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击效果,按需求选择要不要
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self determineWhetherTheLogin]) {
        switch (indexPath.row) {
                break;
            case 0:
            {
                //跳转商品管理
                WPCommodityManagementViewController * vc = [[WPCommodityManagementViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                //跳转交换订单
                WPExchangeOrderViewController * vc = [[WPExchangeOrderViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //跳转收货地址
                WPAddressViewController * vc = [[WPAddressViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 3:
            {
                //跳转我的造梦
                WPMyDreamingViewController * vc = [[WPMyDreamingViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                //跳转造梦订单
                WPDreamingOrderViewController * vc = [[WPDreamingOrderViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:{
                WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:[self getSelfUid]];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }

    }
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat off_y = scrollView.contentOffset.y;
        if (off_y < -TABLEVIEW_TOPVIEW_HEIGHT) {
            _userInformationView.frame = CGRectMake(0, off_y , WINDOW_WIDTH, -off_y);
        }
    }
}

//验证登录状态
-(void)selectionStateInterface{
    for (id subView in _tableView.subviews) {
        if ([subView isKindOfClass:[WPUserInformationView class]]) {
            [subView removeFromSuperview];
        }
    }
    CGRect userInformationViewframe = CGRectMake(0, - TABLEVIEW_TOPVIEW_HEIGHT , WINDOW_WIDTH, TABLEVIEW_TOPVIEW_HEIGHT );
    //判断登录状态
    //已登录
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:User_ID];
    if (!(uid.length<=0)) {
        _userInformationView = [[WPUserInformationView alloc]initWithFrame:userInformationViewframe Type:UserTypeHaveLogin];
        //继续操作
        [_tableView addSubview:_userInformationView];
        [self.tableView reloadData];
        return;
    }
    //未登录
    _userInformationView= [[WPUserInformationView alloc]initWithFrame:userInformationViewframe Type:UserTypeNotLoggedIN];
    //继续操作
    [_tableView addSubview:_userInformationView];
    [self.tableView reloadData];
}




@end

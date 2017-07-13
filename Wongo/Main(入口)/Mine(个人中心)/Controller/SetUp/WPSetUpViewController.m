//
//  WPSetUpViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//  设置

#import "WPSetUpViewController.h"
#import "WPMyNavigationBar.h"
#import "ModifyPasswordViewController.h"
#import "ModifyUserDetailViewController.h"
#import "LYWanGaoUserAgreementController.h"

#define TableViewTitle_Array @[@"修改密码",@"修改详情信息",@"清除缓存",@"用户协议"];

@interface WPSetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * titleArray;

@property (nonatomic,strong)UIButton * logoutButton;
@end

@implementation WPSetUpViewController
#pragma mark - 懒加载

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, 60 * _titleArray.count +1) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = self.title;
    [self.view addSubview:customNav];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArray = TableViewTitle_Array;
    
    [self.view addSubview:self.tableView];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.logoutButton];
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).offset(80);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
    }];
    _logoutButton.backgroundColor = ColorWithRGB(255, 130, 1);
    _logoutButton.layer.masksToBounds = YES;
    _logoutButton.layer.cornerRadius = 5;
    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(logoutLogin) forControlEvents:UIControlEventTouchUpInside];
    CALayer *grayL = [CALayer layer];
    CGFloat h = CGRectGetMaxY(self.tableView.frame) + 80 + 50 + 20;
    grayL.frame = CGRectMake(0, h, WINDOW_WIDTH, WINDOW_HEIGHT - h);
    grayL.backgroundColor = ColorWithRGB(230, 230, 230).CGColor;
    [self.view.layer addSublayer:grayL];
}
//退出登录
-(void)logoutLogin{
    if (User_MobileVersion >= 9.0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * request = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:User_ID];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:User_Token];          
            [[RCIM sharedRCIM]disconnect];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:request];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        UIAlertView * alertView  = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.dataSourceArray.count;
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //设置箭头样式
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArray[indexPath.row];

    //画间隔线
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ModifyPasswordViewController * vc = [[ModifyPasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ModifyUserDetailViewController * vc = [ModifyUserDetailViewController createWithUserName:self.userName signature:self.signature];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            
            CGFloat cacheSize = [[SDImageCache sharedImageCache] getDiskCount];
            if (cacheSize/1000.0/1000 <= 0.01) {
                [self showAlertWithAlertTitle:@"提示" message:@"应用无缓存数据" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                return;
            }
            [self showAlertWithAlertTitle:@"提示" message:[NSString stringWithFormat:@"是否清楚所有缓存数据(%.2fMb)",cacheSize/1000.0/1000] preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
                [[SDImageCache sharedImageCache] clearDisk];
            }];
        }
            break;
        case 3:{
            [self presentViewController:[[LYWanGaoUserAgreementController alloc] init] animated:YES completion:nil];
        }
            break;
            
    }
}


#pragma mark - ScrollViewDidScroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, 0);
}

@end

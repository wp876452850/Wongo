//
//  WPSearchUserViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchUserViewController.h"
#import "WPSearchUserModel.h"
#import "WPSearchUserTableViewCell.h"
#import "WPSearchNavigationBar.h"
#import "WPSearchResultsViewController.h"
#import "WPTypeChooseMune.h"

static NSString * const items = @"Cell";

@interface WPSearchUserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString * keyWord;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)WPSearchNavigationBar * searchNavigationBar;
@property (nonatomic,strong)WPTypeChooseMune * typeChooseMenu;
@end

@implementation WPSearchUserViewController

-(WPTypeChooseMune *)typeChooseMenu{
    if (!_typeChooseMenu) {
        _typeChooseMenu = [[WPTypeChooseMune alloc]initWithFrame:CGRectMake(40, 68, 70, 85)];
        [_typeChooseMenu changeTypeWithBlock:^(NSString *type) {
            [self.searchNavigationBar.choose setTitle:type forState:UIControlStateNormal];
        }];
    }
    return _typeChooseMenu;
}

-(WPSearchNavigationBar *)searchNavigationBar{
    if (!_searchNavigationBar) {
        _searchNavigationBar = [[WPSearchNavigationBar alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        [_searchNavigationBar.back addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        //go按钮
        [_searchNavigationBar actionSearchWithBlock:^(NSString *type, NSString *keyWord) {
            if (keyWord.length == 0) {
                [self showAlertWithAlertTitle:@"提示" message:@"关键字不能为空" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                return;
            }
            //界面跳转
            UIViewController * vc;
            
            if ([type isEqualToString:@"交换"]||[type isEqualToString:@"造梦"]) {
                vc = [[WPSearchResultsViewController alloc]initWithKeyWord:keyWord];
            }
            else if([type isEqualToString:@"用户"]){
                vc = [[WPSearchUserViewController alloc]initWithKeyWord:keyWord];
            }
            [self.view endEditing:YES];
            if(vc){
                 [self.navigationController pushViewController:vc animated:YES];
            }
           
        }];
        //choose按钮
        [_searchNavigationBar chooseButtonClickWithBlock:^{
            switch (self.typeChooseMenu.isOpen) {
                case NO:
                    [self.typeChooseMenu menuOpen];
                    break;
                    
                default:
                    [self.typeChooseMenu menuClose];
                    break;
            }
        }];
    }
    return _searchNavigationBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPSearchUserTableViewCell" bundle:nil] forCellReuseIdentifier:items];
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(instancetype)initWithKeyWord:(NSString *)keyWord{
    self = [super init];
    if (self) {
        self.keyWord = keyWord;
        [self loadDatas];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.searchNavigationBar];
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.typeChooseMenu];
    }
    return self;
}

-(void)loadDatas{
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:UserQueryNameUrl    params:@{@"uname":_keyWord} datas:^(NSDictionary *responseObject) {
        WPSearchUserModel * model = [WPSearchUserModel mj_objectWithKeyValues:responseObject];
        [self.dataSource addObject:model];
        [self.tableView reloadData];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPSearchUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:items forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    [cell goChatWithBlock:^(NSString *userID) {
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":userID} datas:^(NSDictionary *responseObject) {
            RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId         = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"uid"]] ;
            conversationVC.title            = [responseObject objectForKey:@"uname"];
            [self setUpChatNavigationBar];
            self.navigationController.navigationBarHidden = NO;            
            [self.navigationController pushViewController:conversationVC animated:YES];
        }];
    }];
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - TableViewDelegate

@end

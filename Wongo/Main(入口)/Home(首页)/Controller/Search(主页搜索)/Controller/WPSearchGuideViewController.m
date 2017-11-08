//
//  WPSearchGuideViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/13.
//  Copyright © 2017年 Winny. All rights reserved.
//  搜索首页

#import "WPSearchGuideViewController.h"
#import "WPGoodsClassModel.h"
#import "WPSearchGoodsCell.h"
#import "WPSearchNavigationBar.h"
#import "WPSearchResultsViewController.h"
#import "WPTypeChooseMune.h"
#import "WPSearchUserViewController.h"

@interface WPSearchGuideViewController ()

@property (nonatomic,strong)WPSearchNavigationBar * searchNavigationBar;
@property (nonatomic,strong)WPTypeChooseMune * typeChooseMenu;
@property (nonatomic,strong)NSString * type;
@end

@implementation WPSearchGuideViewController

-(WPTypeChooseMune *)typeChooseMenu{
    if (!_typeChooseMenu) {
        _typeChooseMenu = [[WPTypeChooseMune alloc]initWithFrame:CGRectMake(40, 68, 70, 85)];
        __block WPSearchGuideViewController * weakSelf = self;
        [_typeChooseMenu changeTypeWithBlock:^(NSString *type) {
            [self.searchNavigationBar.choose setTitle:type forState:UIControlStateNormal];
            weakSelf.type = type;
        }];
    }
    return _typeChooseMenu;
}

-(WPSearchNavigationBar *)searchNavigationBar{
    if (!_searchNavigationBar) {
        _searchNavigationBar = [[WPSearchNavigationBar alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        _searchNavigationBar.openFirstResponder = YES;
        [_searchNavigationBar.back addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        //go按钮
        [_searchNavigationBar actionSearchWithBlock:^(NSString *type, NSString *keyWord) {
            if (keyWord.length == 0) {
                [self showAlertWithAlertTitle:@"提示" message:@"关键字不能为空" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                return;
            }
            //界面跳转
            UIViewController * vc;
            
            if ([type isEqualToString:@"造梦"]||[type isEqualToString:@"商品"]) {
                vc = [[WPSearchResultsViewController alloc]initWithKeyWord:keyWord];
            }
            else if([type isEqualToString:@"用户"]){
                vc = [[WPSearchUserViewController alloc]initWithKeyWord:keyWord];
            }
            [self.view endEditing:YES];
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }           
        }];

    }
    return _searchNavigationBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.searchNavigationBar];
    [self.view addSubview:self.typeChooseMenu];
}

@end

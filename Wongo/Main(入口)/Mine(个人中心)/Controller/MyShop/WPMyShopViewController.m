//
//  WPMyShopViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//  我的店铺

#import "WPMyShopViewController.h"
#import "WPMyNavigationBar.h"
#import "WPMyShopUserInformationModel.h"
#import "WPMyShopGoodsModel.h"

@interface WPMyShopViewController ()

@end

@implementation WPMyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的店铺";
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = self.title;
    [self.view addSubview:customNav];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WhiteColor;
    
    [self loadDatas];
}

-(void)loadDatas{
    
    
    
}


@end

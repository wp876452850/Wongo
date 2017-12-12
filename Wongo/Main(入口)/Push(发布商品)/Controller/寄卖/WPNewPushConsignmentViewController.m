//
//  WPNewPushConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushConsignmentViewController.h"
//用户信息
#import "WPNewPushUserInformationCollectionViewCell.h"
//图片信息
#import "WPNewPushImagesCollectionViewCell.h"
//可输入信息框
#import "WPPushDetailInformationCollectionViewCell.h"
//条款条例
#import "WPNewPushTermsCollectionViewCell.h"

@interface WPNewPushConsignmentViewController ()

@property (nonatomic,strong)UITableView * tableView;

@end

@implementation WPNewPushConsignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"申请平台寄卖";
}

@end

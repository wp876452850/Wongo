//
//  WPTableBaseViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/7/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPTableBaseViewController.h"

@interface WPTableBaseViewController ()

@end

@implementation WPTableBaseViewController
static NSString * const reuseIdentifier = @"Cell";
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        self.tableView.backgroundColor = ColorWithRGB(247, 247, 247);
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end

//
//  WPMarginViewController.m
//  Wongo
//
//  Created by rexsu on 2017/3/15.
//  Copyright © 2017年 Winny. All rights reserved.
//  保证金

#import "WPMarginViewController.h"
#import "WPMyNavigationBar.h"

@interface WPMarginViewController ()
@property (nonatomic,strong)WPMyNavigationBar * nav;
@end

@implementation WPMarginViewController

-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"提交保证金";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    
    
}




@end

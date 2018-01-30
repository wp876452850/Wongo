//
//  LYBaseController.m
//  WanGao
//
//  Created by  WanGao on 2017/5/27.
//  Copyright © 2017年  WanGao. All rights reserved.
//

#import "LYBaseController.h"

@interface LYBaseController ()
@property (nonatomic,strong)UILabel * selfNavTitleLabel;
@end

@implementation LYBaseController

-(UINavigationBar *)myNavBar{
    if (!_myNavBar) {
        _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
        _myNavBar.barTintColor = ColorWithRGB(33, 34, 35);
        
        //设置文字颜色的属性
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
        _myNavBar.titleTextAttributes = attr;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myNavBar];
    self.myNavBar.items = @[self.myNavItem];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.selfNavTitleLabel.text = title;
}
-(void)setIsPresen:(BOOL)isPresen{
    _isPresen = isPresen;
    if (_isPresen) {
        [self createLeftButton];
    }
}

-(void)createLeftButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(w_dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 20, 20);
    button.centerY = 20 + 44/2;
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self.myNavItem setLeftBarButtonItem:leftBtnItem];
}


@end

//
//  WPUpDataUserInformationViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPUpDataUserInformationViewController.h"
#import "WPMyNavigationBar.h"

@interface WPUpDataUserInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,strong)WPMyNavigationBar * nav;
@end

@implementation WPUpDataUserInformationViewController

-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        [_nav.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_nav.leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_nav showRightButton];
        [_nav.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_nav.rightButton addTarget:self action:@selector(updateUserInformation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}

-(instancetype)initWithUpdateData:(UpdateData)updateData{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)updateUserInformation{
    
}


@end

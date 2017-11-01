//
//  ceshi.m
//  Wongo
//
//  Created by  WanGao on 2017/10/31.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "ceshi.h"
#import "WPConsignmentCollectionView.h"

@interface ceshi ()
@property (nonatomic,strong)WPConsignmentCollectionView * cv;
@end

@implementation ceshi

-(WPConsignmentCollectionView *)cv{
    if (!_cv) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        
        _cv = [[WPConsignmentCollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT-64) collectionViewLayout:layout];
        
    }
    return _cv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.myNavItem.title = @"测试界面";
    [self.view addSubview:self.cv];
}




@end

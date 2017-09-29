 //
//  WPChoiceViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceViewController.h"
#import "WPNavigationBarView.h"

#import "WPNewExchangeCollectionViewCell.h"

#import "WPDreameChioceSubView.h"
#import "WPChoiceSubCollectionView.h"

#define Title_Array @[@"交换",@"造梦计划"]//1.0
@interface WPChoiceViewController (){
    
}
@property (nonatomic,strong)WPNavigationBarView * navigationBar;

@end

@implementation WPChoiceViewController

- (WPChoiceContentCollectionView *)choiceContentCollectionView{
    if (!_choiceContentCollectionView) {
         _choiceContentCollectionView = [WPChoiceContentCollectionView createChoiceCollectionWithFrame:CGRectMake(0, 104, WINDOW_WIDTH, WINDOW_HEIGHT - 153) SubViewsClassArray:@[[WPChoiceSubCollectionView class],[WPDreameChioceSubView class]] cellClassArray:@[[WPNewExchangeCollectionViewCell class],[WPNewExchangeCollectionViewCell class]] loadDatasUrls:@[QueryUserGoodCtid,QuerySubIng]];
        
    }
    return _choiceContentCollectionView;
}
-(WPNavigationBarView *)navigationBar{
    if (!_navigationBar) {
        _navigationBar = [[WPNavigationBarView alloc]initWithStyle:NavigationBarChoiceStyle];
    }
    return _navigationBar;
}

-(WPMenuScrollView *)menuScrollView{
    if (!_menuScrollView) {
        NSDictionary * options = @{@"titles":Title_Array,@"width":@(80),@"height":@(40)};
        _menuScrollView = [[WPMenuScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.navigationBar.frame), 0, 0) withOptions:options];
        _menuScrollView.collectionView = self.choiceContentCollectionView;
        _menuScrollView.height += 20;
        _menuScrollView.y -= 20;
    }
    return _menuScrollView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.choiceContentCollectionView];
    [self.view addSubview:self.menuScrollView];
    [self.view addSubview:self.navigationBar];
}



@end

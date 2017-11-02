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

#define Title_Array @[@"造梦计划",@"交换"]//1.0
@interface WPChoiceViewController (){
    
}
@property (nonatomic,strong)WPNavigationBarView * navigationBar;

@property (nonatomic,strong)UIButton * help;

@end

@implementation WPChoiceViewController

- (WPChoiceContentCollectionView *)choiceContentCollectionView{
    if (!_choiceContentCollectionView) {
         _choiceContentCollectionView = [WPChoiceContentCollectionView createChoiceCollectionWithFrame:CGRectMake(0, 104, WINDOW_WIDTH, WINDOW_HEIGHT - 153) SubViewsClassArray:@[[WPChoiceSubCollectionView class],[WPDreameChioceSubView class]] cellClassArray:@[[WPNewExchangeCollectionViewCell class],[WPNewExchangeCollectionViewCell class]] loadDatasUrls:@[QueryGoodsListNew,QuerySubIng]];        
    }
    return _choiceContentCollectionView;
}

-(WPNavigationBarView *)navigationBar{
    if (!_navigationBar) {
        _navigationBar = [[WPNavigationBarView alloc]initWithStyle:NavigationBarChoiceStyle];
        [_navigationBar.rightItemButton setImage:[UIImage imageNamed:@"questionmark"] forState:UIControlStateNormal];
        [_navigationBar.rightItemButton addTarget:self action:@selector(questionmark) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBar;
}

-(void)questionmark{
    [self showAlertWithAlertTitle:@"造梦规则" message:@"“造梦”专区。\n\n碗糕用户可在此发起“造梦”招募，通过与其他用户进行有价值的物品多环节交换，换取所需物品或最接近所需物品价值的物品。\n\n“造梦”过程实际是多环节等价交换的过程，但发起者可通过发起招募，最终实现不等价交换，完成拉环变钻戒的梦想！碗糕全体用户均可参与其中，碗糕用户须上传个人物品，填写完整清楚的物品描述，且交纳一定的保证金之后，发布至专区页面便可成功发起“造梦”。\n\n发起者须在有限的五次交换中，尽量将物品的价值最大化，在最后获得所需物品或与所需物品价值相近的东西。\n\n当发起者成功完成五次不同的交换之后，无论发起者是否成功“造梦”，此次“造梦”结束。\n\n“造梦计划”是碗糕平台含公益性质的一大功能，旨在帮助更多有梦、追梦、有需要的人们完成自己所想。" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
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

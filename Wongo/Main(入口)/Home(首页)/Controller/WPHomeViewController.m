//
//  WPHomeViewController.m
//  Wogou
//
//  Created by rexsu on 2016/11/29.
//  Copyright © 2016年 Winny. All rights reserved.
//  主页

#import "WPHomeViewController.h"
#import "WPHomeHeaderView.h"
#import "WPHomeDataModel.h"
#import "WPHotCell.h"
#import "WPHomeHeaderSearchView.h"
#import "WPHomeReusableView.h"
#import "WPHomeReusableModel.h"
#import "LYHomeResponse.h"
#import "LYHomeSquareCell.h"
#import "LYHomeRectangleCell.h"
#import "LYActivityController.h"
#import "LYHomeSectionFooter.h"

#define COLLECTIONVIEW_FRAME CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 49)

#define RollPlayImages @[FIRST_IMG_URL,SECOND_IMG_URL,THIRD_IMG_URL,FOURTH_IMG_URL]


#define ThemeNameArray      @[@"NEW PRODUCTS",@"CHANGE SIDES",@"DREAM"]
#define Theme2NameArray     @[@"新品",@"交换",@"造梦"]
#define ThemeIconArray      @[@"newthemeicon",@"exchangethemeicon",@"hotthemeicon"]
#define ThemeNameColorArray @[ColorWithRGB(97, 213, 200),ColorWithRGB(125, 153, 224),ColorWithRGB(250, 130, 1)]

#define Cell_HeightDouble (WINDOW_WIDTH*0.5 )
#define Cell_HeightSigleLine (0.54*WINDOW_WIDTH)
#define ReusableView_Height 44

static NSString * contentOffset = @"contentOffset";
@interface WPHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property (nonatomic,strong)WPHomeHeaderView * homeHeaderView;

@property (nonatomic,strong)WPHomeHeaderSearchView * homeHeaderSearchView;

@property (nonatomic,strong)UICollectionView * collectionView;
//内容数据
//一级数据数组(存放所有区数据数组)
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
//区头数据
@property (nonatomic,strong)NSMutableArray * reusableDataSource;
//记录collectionView最后Y偏移
@property (nonatomic,assign)CGFloat lastCollectionContentOffsetY;

@property (nonatomic, strong) LYHomeResponse *response;
@end

@implementation WPHomeViewController

#pragma mark - 懒加载
-(WPHomeHeaderSearchView *)homeHeaderSearchView{
    if (!_homeHeaderSearchView) {
        _homeHeaderSearchView = [[WPHomeHeaderSearchView alloc]init];
        
    }
    return _homeHeaderSearchView;
}
-(WPHomeHeaderView *)homeHeaderView
{
    if (!_homeHeaderView) {
        _homeHeaderView = [[WPHomeHeaderView alloc] init];
        
    }
    return _homeHeaderView;
}


-(UICollectionView *)collectionView{  
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.headerReferenceSize = CGSizeMake(WINDOW_WIDTH, 44);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:COLLECTIONVIEW_FRAME collectionViewLayout:layout];
    
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"LYHomeSquareCell" bundle:nil] forCellWithReuseIdentifier:@"SquareCellID"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"LYHomeRectangleCell" bundle:nil] forCellWithReuseIdentifier:@"RectangleCellID"];
        
        [_collectionView registerClass:[WPHomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LYHomeSectionFooter" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID"];
        //添加监听
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld;
        
        [_collectionView addObserver:self forKeyPath:contentOffset options:options context:nil];
    }
    return _collectionView;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self w_backGroudColor:ColorWithRGB(0, 255, 255)];
    [self.view addSubview:self.collectionView];
    [self addHeaderLoad];
    [self.collectionView addSubview:self.homeHeaderView];
    [self.view bringSubviewToFront:self.homeHeaderView];
    [self.view addSubview:self.homeHeaderSearchView];
}

-(void)addHeaderLoad{
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:Theme2NameArray.count];
        NSMutableArray * newArray = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray * exchangeArray = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray * hotArray = [NSMutableArray arrayWithCapacity:3];
        [_dataSourceArray addObject:hotArray];
        [_dataSourceArray addObject:newArray];
        [_dataSourceArray addObject:exchangeArray];
    }
    return _dataSourceArray;
}
- (NSMutableArray *)reusableDataSource{
    if (!_reusableDataSource) {
        _reusableDataSource = [NSMutableArray arrayWithCapacity:Theme2NameArray.count];
        for (int i = 0; i<ThemeIconArray.count; i++) {
            WPHomeReusableModel * model = [[WPHomeReusableModel alloc]init];
            model.title_e = ThemeNameArray[i];      //标题英文名
            model.title_c = Theme2NameArray[i];     //标题中文名
            model.icon_name = ThemeIconArray[i];    //标题图标名
            model.titleColor = (UIColor *)ThemeNameColorArray[i];   //标题文字颜色
               
            [_reusableDataSource addObject:model];
        }
    }
    return _reusableDataSource;
}
//请求数据
-(void)loadData{
    [WPNetWorking createPostRequestMenagerWithUrlString:QtQueryType params:nil datas:^(NSDictionary *responseObject) {
        [self.collectionView.mj_header endRefreshing];
        LYHomeResponse *response = [LYHomeResponse mj_objectWithKeyValues:responseObject];
        self.response = response;
        self.homeHeaderView.listhl = response.listhl;
        self.homeHeaderView.listhk = response.listhk;
        [self.collectionView reloadData];

    }failureBlock:^{
        [self.collectionView.mj_header endRefreshing];
    }];
    
    
}


#pragma mark - collectionViewDelegate && collectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LYHomeCategory *category;
    if (indexPath.row == 0 && [self.response hasBanner:indexPath.section]) {
//        switch (indexPath.section) {
//            case 0:
//                category = self.response.listxl;
//                break;
//            case 1:
//                category = self.response.listfl;
//                break;
//            case 2:
//                cell.categorys = self.response.listzl;
//                break;
//            default:
//                break;
//        }
        
    } else{
        NSInteger index = 0;
        if ([self.response hasBanner:indexPath.section]) {
            index = indexPath.row -1;
        }else{
            index = indexPath.row;
        }
        switch (indexPath.section) {
            case 0:
                category = self.response.listxk[index];
                break;
            case 1:
                category = self.response.listfk[index];
                break;
            case 2:
                category = self.response.listzk[index];
                break;
            default:
                break;
        }
    }
    [self.navigationController pushViewController:[LYActivityController controllerWithCategory:category] animated:YES];
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0 && [self.response hasBanner:indexPath.section]) {
        return CGSizeMake(WINDOW_WIDTH - 10, Cell_HeightSigleLine);
    }
    return CGSizeMake((WINDOW_WIDTH) * 0.5 - 12, Cell_HeightDouble);
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return self.dataSourceArray.count;
    return 4;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            NSInteger num = self.response.listxk.count + (self.response.listxl.count?1:0);
            return num > 5?5:num;
        }
            break;
        case 1:{
            NSInteger num = self.response.listfk.count + (self.response.listfl.count?1:0);
            return num > 5?5:num;
        }
            break;
        case 2:{
            NSInteger num = self.response.listzk.count + (self.response.listzl.count?1:0);
            return num > 5?5:num;
        }
            break;
        default:
            return 0;
            break;
    }
}

//配置单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && [self.response hasBanner:indexPath.section]) {
            LYHomeRectangleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RectangleCellID" forIndexPath:indexPath];
            switch (indexPath.section) {
                case 0:
                    cell.categorys = self.response.listxl;
                    break;
                case 1:
                    cell.categorys = self.response.listfl;
                    break;
                case 2:
                    cell.categorys = self.response.listzl;
                    break;
                default:
                    break;
            }
            return cell;
    } else{
        NSInteger index = 0;
        if ([self.response hasBanner:indexPath.section]) {
            index = indexPath.row - 1;
        }else{
            index = indexPath.row;
        }
       LYHomeSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SquareCellID" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
                cell.category = self.response.listxk[index];
                break;
            case 1:
                cell.category = self.response.listfk[index];
                break;
            case 2:
                cell.category = self.response.listzk[index];
                break;
            default:
                break;
        }
        return cell;
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(WINDOW_WIDTH, CGRectGetHeight(self.homeHeaderView.frame) + ReusableView_Height);
    }
    if ([self.response hasCategory:section]) {
        return CGSizeMake(WINDOW_WIDTH, ReusableView_Height);
    }else{
        return CGSizeZero;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([self.response hasCategory:section]) {
        return CGSizeMake(WINDOW_WIDTH, 31);
    }else{
        return CGSizeZero;
    }

}

//返回区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID" forIndexPath:indexPath];
    }else{
        WPHomeReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        WPHomeReusableModel * model = self.reusableDataSource[indexPath.section];
        reusableView.model = model;
        return reusableView;
    }
}



#pragma mark - obser

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    UICollectionView * collectionView = (UICollectionView *)object;
    if (collectionView != self.collectionView || ![keyPath isEqualToString:contentOffset]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    CGFloat collectionViewOffsetY = collectionView.contentOffset.y;

    CGFloat headerViewMaxY = CGRectGetHeight(self.homeHeaderView.frame);

    UIColor * color = ColorWithRGB(0, 0, 0);
    
    CGFloat alpha = MIN(1,collectionViewOffsetY/(headerViewMaxY-164)  );
    
    self.homeHeaderSearchView.backgroundColor = color;
    self.homeHeaderSearchView.alpha = alpha;
    if (collectionViewOffsetY < headerViewMaxY - 164 && collectionViewOffsetY > 0){
        [self.homeHeaderSearchView showSearchView];
    } else if (collectionViewOffsetY <= 0 ){
        [self.homeHeaderSearchView hidenSearchView];
    } else if (collectionViewOffsetY >= headerViewMaxY - 164){
        [self.homeHeaderSearchView animationForSearchButton];
    }
}

-(void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:contentOffset context:nil];
}


@end

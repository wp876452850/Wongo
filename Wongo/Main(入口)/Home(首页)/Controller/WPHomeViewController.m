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
#import "WPNewExchangeCollectionViewCell.h"
#import "WPHomeDreamingCollectionViewCell.h"
#import "WPAdvertisingView.h"
#import "WPDreamingModel.h"
#import "WPNewHomeDreamingCollectionViewCell.h"
#import "WPNewHomeDreamingPhotoModel.h"

#define Dreaming_Section 1
#define Exchange_Section 2

#define COLLECTIONVIEW_FRAME CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 49)

#define RollPlayImages @[FIRST_IMG_URL,SECOND_IMG_URL,THIRD_IMG_URL,FOURTH_IMG_URL]


#define ThemeNameArray      @[@"HOT",@"DREAM",@"CHANGE SIDES"]
#define Theme2NameArray     @[@"热门",@"造梦",@"交换"]
#define ThemeIconArray      @[@"hotthemeicon",@"homedreamingicon",@"exchangethemeicon"]
#define ThemeNameColorArray @[ColorWithRGB(255, 129, 37),ColorWithRGB(0, 123, 249),ColorWithRGB(125, 153, 224)]

#define Cell_HeightDouble (WINDOW_WIDTH*0.5 )
#define Cell_HeightSigleLine (0.54*WINDOW_WIDTH)
#define ReusableView_Height 44

static NSString * contentOffset = @"contentOffset";
@interface WPHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic,strong)WPHomeHeaderView * homeHeaderView;

@property (nonatomic,strong)WPHomeHeaderSearchView * homeHeaderSearchView;

@property (nonatomic,strong)UICollectionView * collectionView;
//内容数据
//一级数据数组(存放所有区数据数组)
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
//造梦数据数组
@property (nonatomic,strong)NSMutableArray * dreamings;
//造梦plid
@property (nonatomic,strong)NSMutableArray * plids;
//区头数据
@property (nonatomic,strong)NSMutableArray * reusableDataSource;
//记录collectionView最后Y偏移
@property (nonatomic,assign)CGFloat lastCollectionContentOffsetY;

@property (nonatomic, strong) LYHomeResponse *response;
/**广告页*/

@property (nonatomic,strong)WPAdvertisingView * advertisingView;

@property (nonatomic,strong)WPDreamingModel * dreamingModel;

@property (nonatomic,strong)MBProgressHUD * hud;
@end

@implementation WPHomeViewController

#pragma mark - 懒加载
-(WPAdvertisingView *)advertisingView{
    if (!_advertisingView) {
        _advertisingView = [[WPAdvertisingView alloc]init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAdvertisingLink)];
        
        [_advertisingView addGestureRecognizer:tap];
    }
    return _advertisingView;
}
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
        for (UIView*view in _homeHeaderView.subviews) {
            view.backgroundColor = WhiteColor;
        }
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
        //区头
        [_collectionView registerClass:[WPHomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"jingpintuijian"];
        //单元格
        [_collectionView registerNib:[UINib nibWithNibName:@"LYHomeSquareCell" bundle:nil] forCellWithReuseIdentifier:@"SquareCellID"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LYHomeRectangleCell" bundle:nil] forCellWithReuseIdentifier:@"RectangleCellID"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LYHomeSectionFooter" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID"];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewExchangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsCell"];
        
        //[_collectionView registerNib:[UINib nibWithNibName:@"WPHomeDreamingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeDreamingCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewHomeDreamingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeDreamingCell"];
        //添加监听
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld;
        [_collectionView addObserver:self forKeyPath:contentOffset options:options context:nil];
    }
    return _collectionView;
}

#pragma mark - viewDidLoad

-(void)viewDidLoad{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self w_backGroudColor:ColorWithRGB(0, 255, 255)];
    [self.view addSubview:self.collectionView];
    [self addHeaderLoad];
    [self addFooterLoad];
    [self.collectionView addSubview:self.homeHeaderView];
    [self.view bringSubviewToFront:self.homeHeaderView];
    [self.view addSubview:self.homeHeaderSearchView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.advertisingView];
}
- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:Theme2NameArray.count];
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

#pragma mark - 数据加载
-(void)addHeaderLoad{
    __block typeof(self) weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
}
-(void)addFooterLoad{
    __block typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackGifFooter  footerWithRefreshingBlock:^{
        [weakSelf footer];
    }];
    [self.collectionView.mj_footer beginRefreshing];
}

//请求数据
-(void)loadData{
    _plids = [NSMutableArray arrayWithCapacity:3];
    __block WPHomeViewController * weakSelf = self;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.removeFromSuperViewOnHide = YES;
    [WPNetWorking createPostRequestMenagerWithUrlString:QtQueryType params:nil datas:^(NSDictionary *responseObject) {
        LYHomeResponse * response = [LYHomeResponse mj_objectWithKeyValues:responseObject];
        weakSelf.response = response;
        weakSelf.homeHeaderView.listhl = response.listhl;
        weakSelf.homeHeaderView.listhk = response.listhk;
        [weakSelf loadTuijianDatas];
    }failureBlock:^{
        [weakSelf loadTuijianDatas];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
//获取推荐数据(第一条)
-(void)loadTuijianDatas{
    //查询推荐商品
    __block WPHomeViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:Queryboutique params:@{@"currPage":@(1)} datas:^(NSDictionary *responseObject) {
        NSArray * listg = responseObject[@"listg"];
        weakSelf.dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in listg) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [weakSelf.dataSourceArray addObject:model];
        }
        _page++;
        [weakSelf loadDreamingDatas];
    } failureBlock:^{
        [weakSelf loadDreamingDatas];
    }];
}
//获取造梦数据
-(void)loadDreamingDatas{
    //查询造梦计划
    __block WPHomeViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QuerySubIng params:nil datas:^(NSDictionary *responseObject) {
        NSArray * dreamings = responseObject[@"listSub"];
        weakSelf.dreamings = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < dreamings.count; i++) {
            NSArray * listplan = dreamings[i][@"listplan"];
            for (int j = 0; j<listplan.count; j++) {
                WPDreamingDirectoryModel * model = [WPDreamingDirectoryModel mj_objectWithKeyValues:listplan[j]];
                [weakSelf loadDreamingInformationDatasWithPlid:model.plid];                
            }
            if (listplan.count <=0) {
                [weakSelf.hud hide:YES];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView.mj_header endRefreshing];
            }
        }
    } failureBlock:^{
        [weakSelf.collectionView reloadData];
        [weakSelf.hud hide:YES];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
//获取造梦详细信息
-(void)loadDreamingInformationDatasWithPlid:(NSString *)plid{
    __block WPHomeViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:GetPlanUrl params:@{@"plid":plid} datas:^(NSDictionary *responseObject) {
        
        NSDictionary * list = responseObject[@"list"][0];
        //WPDreamingModel * model = [WPDreamingModel mj_objectWithKeyValues:list];
        //[weakSelf.dreamings addObject:model];
        weakSelf.dreamingModel = [WPDreamingModel mj_objectWithKeyValues:list];
        [weakSelf loadParticipateDatasWithPlid:plid];

    } failureBlock:^{
        [weakSelf loadParticipateDatasWithPlid:plid];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
//查询参与商品
-(void)loadParticipateDatasWithPlid:(NSString *)plid{
    __block typeof(self) weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryProductById params:@{@"plid":plid} datas:^(NSDictionary *responseObject) {
        
        weakSelf.dreamingModel.introduceModel.dreamingIntroduces = responseObject[@"list"];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView reloadData];
        [weakSelf.hud hide:YES];
    } failureBlock:^{
        [weakSelf.hud hide:YES];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView reloadData];
    }];
}
//获取推荐加载数据
-(void)footer{
    __block WPHomeViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:Queryboutique params:@{@"currPage":@(_page)} datas:^(NSDictionary *responseObject) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        NSArray * listg = responseObject[@"listg"];
        for (NSDictionary * item in listg) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [weakSelf.dataSourceArray addObject:model];
        }
        _page++;
        [weakSelf.collectionView reloadData];
    }failureBlock:^{
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - collectionViewDelegate && collectionViewDataSource

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0 && [self.response hasBanner:indexPath.section]){
        return CGSizeMake(WINDOW_WIDTH - 10, Cell_HeightSigleLine);
    }
    if (indexPath.section == 3) {
        return CGSizeMake((WINDOW_WIDTH) * 0.5 - 12, WINDOW_WIDTH*0.5+60);
    }
    if (indexPath.section == Dreaming_Section) {
        return CGSizeMake(WINDOW_WIDTH, WINDOW_WIDTH*0.6+10+(WINDOW_WIDTH/3) + 90);
    }
    return CGSizeMake((WINDOW_WIDTH) * 0.5 - 12, Cell_HeightDouble);
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            //隐藏热门
//            NSInteger num = self.response.listxk.count + (self.response.listxl.count?1:0);
//            return num > 5?5:num;
            return 0;
        }
            break;
        case Exchange_Section:{
            NSInteger num = self.response.listfk.count + (self.response.listfl.count?1:0);
            return num > 5?5:num;
        }
            break;
        case Dreaming_Section:{
            return self.dreamingModel.introduceModel.dreamingIntroduces.count>1?1:self.dreamingModel.introduceModel.dreamingIntroduces.count;
            //return self.dreamings.count>5?5:self.dreamings.count;
        }
            break;
        default:
            return _dataSourceArray.count;
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
                case Exchange_Section:
                    cell.categorys = self.response.listfl;
                    break;
                case Dreaming_Section:
                    cell.categorys = self.response.listzl;
                    break;
            }
            return cell;
        
    }
    else if (indexPath.section == 3){
        WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCell" forIndexPath:indexPath];
        cell.model = self.dataSourceArray[indexPath.row];
        return cell;
    }
    else if (indexPath.section == Dreaming_Section){
        WPNewHomeDreamingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDreamingCell" forIndexPath:indexPath];
        cell.model = self.dreamingModel;
        //cell.model = self.dreamings[indexPath.row];
        return cell;
    }
    else{
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
            case Exchange_Section:
                cell.category = self.response.listfk[index];
                break;
            case Dreaming_Section:
                cell.category = self.response.listzk[index];
                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
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
        //隐藏热门
//        return CGSizeMake(WINDOW_WIDTH, CGRectGetHeight(self.homeHeaderView.frame) + ReusableView_Height);
        return CGSizeMake(WINDOW_WIDTH, CGRectGetHeight(self.homeHeaderView.frame));
    }    
    return CGSizeMake(WINDOW_WIDTH, ReusableView_Height);
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
    }else
    {
        if (indexPath.section == 3) {
            UICollectionReusableView * reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"jingpintuijian" forIndexPath:indexPath];;
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
            title.center = CGPointMake(WINDOW_WIDTH/2, ReusableView_Height/2);
            title.text = @"精品推荐";
            title.font = [UIFont systemFontOfSize:19];
            title.textColor = AllBorderColor;
            title.textAlignment = NSTextAlignmentCenter;
            [reusableView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(50, title.centerY) moveForPoint:CGPointMake(title.left - 20, title.centerY) lineColor:AllBorderColor]];
            [reusableView addSubview:title];
            [reusableView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(WINDOW_WIDTH - 50, title.centerY) moveForPoint:CGPointMake(title.right + 20, title.centerY) lineColor:AllBorderColor]];
            return reusableView;
        }
        WPHomeReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        //隐藏热门区头
        if (indexPath.section < 3 &&indexPath.section!=0) {
            WPHomeReusableModel * model = self.reusableDataSource[indexPath.section];
            reusableView.model = model;
        }
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

    UIColor * color = ColorWithRGB(33, 34, 36);
    
    CGFloat alpha = MIN(1,collectionViewOffsetY/(headerViewMaxY - 453));
    
    self.homeHeaderSearchView.backgroundColor = color;
    self.homeHeaderSearchView.alpha = alpha;
    if (collectionViewOffsetY < headerViewMaxY - 453 && collectionViewOffsetY > 0){
        [self.homeHeaderSearchView showSearchView];
    } else if (collectionViewOffsetY <= 0 ){
        [self.homeHeaderSearchView hidenSearchView];
    } else if (collectionViewOffsetY >= headerViewMaxY - 453){
        [self.homeHeaderSearchView animationForSearchButton];
    }
}

-(void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:contentOffset context:nil];
    
    
}


#pragma mark - 点击事件
//广告页点击跳转活动页
-(void)jumpAdvertisingLink{
    [_advertisingView removeFromSuperview];
    [_homeHeaderView tapImage:_homeHeaderView.activityA];
}
@end

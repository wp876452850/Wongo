//
//  WPStoreViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/8/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPStoreViewController.h"
#import "WPNewExchangeCollectionViewCell.h"
#import "WPStoreUserInformationView.h"
#import "WPStroeDreamingCollectionViewCell.h"
#import "LYConversationController.h"
#import "WPUserIntroductionModel.h"

#define Cell_Height (WINDOW_WIDTH*0.5+60)

@interface WPStoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSInteger _menuTag;
    WPUserIntroductionModel * _model;
}

@property (nonatomic,strong)NSString * uid;

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)WPStoreUserInformationView * storeUserInformationView;

@property (nonatomic,strong)UIView * bottomView;
@end

@implementation WPStoreViewController
static NSString * const reuseIdentifier = @"Cell";
static NSString * const storeCell       = @"StoreCell";

#pragma mark - 懒加载
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}
-(WPStoreUserInformationView *)storeUserInformationView{
    if (!_storeUserInformationView) {
        _storeUserInformationView = [[WPStoreUserInformationView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) uid:self.uid];
        __block WPStoreViewController * weakSelf = self;
        [_storeUserInformationView getmuneTagWithBlock:^(NSInteger tag) {
            _menuTag = tag;
            [weakSelf.collectionView reloadData];
        }];
    }
    return _storeUserInformationView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //layout
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(WINDOW_WIDTH + 20, 0, 0, 0);
        
        //collectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 50) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewExchangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"WPStroeDreamingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:storeCell];
        
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView addSubview:self.storeUserInformationView];
        
    }
    return _collectionView;
}

-(instancetype)initWithUid:(NSString *)uid{
    if (self = [super init]) {
        self.uid = uid;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.collectionView];
        //[self addFooter];
        [self addHeader];
    }
    return self;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
    return _dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_menuTag == 0) {
        WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        //cell.model = _dataSourceArray[indexPath.row];
        return cell;
    }
    WPStroeDreamingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:storeCell forIndexPath:indexPath];
    return cell;
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake((WINDOW_WIDTH) * 0.5 - 7.5, Cell_Height);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//设置边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(WINDOW_WIDTH - 40, 5, 10, 5);
}


#pragma mark - loadDatas

-(void)addHeader{
    __weak WPStoreViewController * weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)addFooter{
    __weak WPStoreViewController * weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatas];
    }];
    [self.collectionView.mj_footer beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPStoreViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:@"" params:@{@"currPage":@(1),@"pubtime":@"sb"} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf.collectionView reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.collectionView.mj_header endRefreshing];
    } failureBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreDatas{
    __weak WPStoreViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:@"" params:@{} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        if ([[responseObject valueForKey:@"goods"] isKindOfClass:[NSNull class]]) {
            [weakSelf.collectionView.mj_footer endRefreshing];
            return;
        }
        for (NSDictionary * item in goods) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:item];
            [_dataSourceArray addObject:model];
        }
        // 刷新表格
        [weakSelf.collectionView reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.collectionView.mj_footer endRefreshing];
    } failureBlock:^{
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark - 展示底部视图样式

-(void)showShoppingBottomView{
    [self.view addSubview:self.bottomView];
    UIButton * chat = [self createChatButton];
    //立即购买
    UIButton * collect      = [UIButton buttonWithType:UIButtonTypeCustom];
    collect.frame           = CGRectMake(chat.right, 0, (WINDOW_WIDTH - chat.width), 50);
    collect.backgroundColor = ColorWithRGB(105, 152, 192);
    [collect setTitleColor:WhiteColor forState:UIControlStateNormal];
    [collect setAttributedTitle:[WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:@"关注" ] insertImage:[UIImage imageNamed:@""] atIndex:0 imageBounds:CGRectZero] forState:UIControlStateNormal];
    [collect setAttributedTitle:[WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:@"已关注" ] insertImage:[UIImage imageNamed:@""] atIndex:0 imageBounds:CGRectZero] forState:UIControlStateSelected];

    [collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:collect];
}

-(UIButton *)createChatButton{
    UIButton * chat = [UIButton buttonWithType:UIButtonTypeCustom];
    chat.frame = CGRectMake(0, 0, WINDOW_WIDTH/2, 50);
    chat.backgroundColor = ColorWithRGB(45, 102, 139);
    [chat addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chat];
    [chat setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    return chat;
}

-(void)goChat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.uid];
        vc.title = _model.uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)collect:(UIButton *)sender{
    
}
@end

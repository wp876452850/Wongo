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
#import "WPStoreModel.h"
#import "WPNewExchangeModel.h"
#import "WPStroeDreamingModel.h"

#define Cell_Height (WINDOW_WIDTH*0.5+60)

@interface WPStoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSInteger                   _menuTag;
}

@property (nonatomic,strong)NSString                    * uid;

@property (nonatomic,strong)UICollectionView            * collectionView;

@property (nonatomic,strong)NSMutableArray              * dataSourceArray;

@property (nonatomic,strong)WPStoreUserInformationView  * storeUserInformationView;

@property (nonatomic,strong)UIView                      * bottomView;

@property (nonatomic,strong)UIButton                    * backButton;

@property (nonatomic,strong)WPStoreModel                * storeModel;
@end

@implementation WPStoreViewController
static NSString * const reuseIdentifier = @"Cell";
static NSString * const storeCell       = @"StoreCell";

#pragma mark - 懒加载

//返回按钮
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        if (self.isPresen) {
            [_backButton addTarget:self action:@selector(w_dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
        }
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backButton;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}
-(WPStoreUserInformationView *)storeUserInformationView{
    if (!_storeUserInformationView) {
        _storeUserInformationView = [[WPStoreUserInformationView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) storeModel:_storeModel];
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
    }
    return _collectionView;
}

-(instancetype)initWithUid:(NSString *)uid{
    if (self = [super init]) {
        self.uid = uid;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.collectionView];
        [self.view addSubview:self.backButton];
        [self addHeader];
        [self showShoppingBottomView];
    }
    return self;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_menuTag == 0) {
        return _storeModel.listg.count;
    }
    return _storeModel.listm.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_menuTag == 0) {
        WPNewExchangeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        WPNewExchangeModel * model = model = [WPNewExchangeModel mj_objectWithKeyValues:_storeModel.listg[indexPath.row]];
        model.url = _storeModel.listg[indexPath.row][@"urlg"];
        cell.model = model;
        return cell;
    }
    WPStroeDreamingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:storeCell forIndexPath:indexPath];
    WPStroeDreamingModel * model = [WPStroeDreamingModel mj_objectWithKeyValues:_storeModel.listm[indexPath.row]];
    cell.model = model;
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
    return UIEdgeInsetsMake(WINDOW_WIDTH - 30, 5, 10, 5);
}


#pragma mark - loadDatas
-(void)addHeader{
    __weak WPStoreViewController * weakSelf = self;
    self.collectionView.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPStoreViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QureygoodUid params:@{@"uid":weakSelf.uid} datas:^(NSDictionary *responseObject) {
        weakSelf.storeModel = [WPStoreModel mj_objectWithKeyValues:responseObject];
        [weakSelf.collectionView addSubview:weakSelf.storeUserInformationView];
        // 刷新表格
        [weakSelf.collectionView reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.collectionView.mj_header endRefreshing];
    } failureBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
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
    

    [collect setAttributedTitle:[WPAttributedString attributedStringWithAttributedString:[WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:@" 关注"] andColor:WhiteColor font:[UIFont systemFontOfSize:16.f] range:NSMakeRange(0, @" 关注".length)] insertImage:[UIImage imageNamed:@"storecollect_normal"] atIndex:0 imageBounds:CGRectMake(0, -3, 0, 0)] forState:UIControlStateNormal];
    [collect setAttributedTitle:[WPAttributedString attributedStringWithAttributedString:[WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:@" 已关注" ] andColor:WhiteColor font:[UIFont systemFontOfSize:16.f] range:NSMakeRange(0, @" 已关注".length)] insertImage:[UIImage imageNamed:@"storecollect_select"] atIndex:0 imageBounds:CGRectMake(0, -3, 0, 0)]  forState:UIControlStateSelected];

    [collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:collect];
}

-(UIButton *)createChatButton{
    UIButton * chat = [UIButton buttonWithType:UIButtonTypeCustom];
    chat.frame = CGRectMake(0, 0, WINDOW_WIDTH/2, 50);
    chat.backgroundColor = ColorWithRGB(45, 102, 139);
    [chat addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chat];
    [chat setAttributedTitle:[WPAttributedString attributedStringWithAttributedString:[WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc]initWithString:@" 联系用户"] andColor:WhiteColor font:[UIFont systemFontOfSize:16.f] range:NSMakeRange(0, @" 联系用户".length)] insertImage:[UIImage imageNamed:@"chat"] atIndex:0 imageBounds:CGRectMake(0, -5, 0, 0)] forState:UIControlStateNormal];
    return chat;
}

-(void)goChat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.uid];
        vc.title = _storeModel.uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)collect:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self focusOnTheUserWithSender:sender uid:self.uid];
}

-(void)collectionOfGoodsWithSender:(UIButton *)sender gid:(NSString *)gid{
    
}
@end

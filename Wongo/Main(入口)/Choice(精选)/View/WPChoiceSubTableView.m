//
//  WPChoiceSubTableView.m
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceSubTableView.h"
#import "WPDreamingMainGoodsModel.h"
#import "WPNewDreamingTableViewCell.h"
#import "WPNewDreamingChoiceHeaderView.h"
#import "WPNewDreamingSignUpTableViewCell.h"
#import "WPNewDreamingModel.h"
#import "WPNewDreamingNotSignUpTableViewCell.h"

@interface WPChoiceSubTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _memoryButtonTag;
    NSMutableArray * _tagOneItemsHeight;
    NSMutableArray * _tagTwoItemsHeight;
}
@property (nonatomic,strong)NSMutableArray * images;

@property (nonatomic,strong)NSMutableArray * cellsArray;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong)NSString * url;

@property (nonatomic,strong)WPNewDreamingChoiceHeaderView * headerView;

@end

@implementation WPChoiceSubTableView

static NSString * const projectCell = @"ProjectCell";
static NSString * const signUp = @"SignUp";
static NSString * const notSignUpCell   = @"notSignUpCell";



-(NSMutableArray *)cellsArray{
    if (!_cellsArray) {
        _cellsArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _cellsArray;
}
-(WPNewDreamingChoiceHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WPNewDreamingChoiceHeaderView alloc]initWithPostersImages:self.images];
        [_headerView menuButtonDidSelectedWithBlock:^(NSInteger tag) {
            //修改url
            [self addHeader];
            _memoryButtonTag = tag;
        }];
    }
    return _headerView;
}
#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style url:(NSString *)url{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.url = url;
        self.rowHeight = 200;
        self.tableHeaderView = self.headerView;
        [self registerNib:[UINib nibWithNibName:@"WPNewDreamingTableViewCell" bundle:nil] forCellReuseIdentifier:projectCell];
        [self registerNib:[UINib nibWithNibName:@"WPNewDreamingSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:signUp];
        [self registerNib:[UINib nibWithNibName:@"WPNewDreamingNotSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:notSignUpCell];
        [self addHeader];
    }
    return self;
}

#pragma mark - UITableViewDeletage && UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.cellsArray[section] objectForKey:@"isOpen"] boolValue]) {
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
    {
        WPNewDreamingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:projectCell forIndexPath:indexPath];
        cell.model = self.dataSourceArray[indexPath.section];
        return cell;
    }else{
        if (_memoryButtonTag == 0) {
            WPNewDreamingNotSignUpTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:notSignUpCell forIndexPath:indexPath];
            return cell;
        }
        WPNewDreamingSignUpTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:signUp forIndexPath:indexPath];
        WPDreamingMainGoodsModel * model = self.dataSourceArray[indexPath.section];
        cell.dataSource = [NSMutableArray arrayWithArray:model.listplan];
        
        [cell closeWithBlock:^{
            NSDictionary * dic = @{@"Cell": @"cell",@"isOpen":@(NO)};
            self.cellsArray[(indexPath.section)] = dic;
            [self beginUpdates];
            [self deleteRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationMiddle];
            [self endUpdates];
        }];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([[tableView cellForRowAtIndexPath:indexPath] class] == [WPNewDreamingTableViewCell class]) {
            NSIndexPath * path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
            if ([[self.cellsArray[indexPath.section] objectForKey:@"isOpen"] boolValue]) {
                // 关闭附加cell
                NSDictionary * dic = @{@"Cell": @"cell",@"isOpen":@(NO)};
                self.cellsArray[(path.section)] = dic;
                [self beginUpdates];
                [self deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
                [self endUpdates];
            }else{
                // 打开附加cell
                NSDictionary * dic = @{@"Cell": projectCell,@"isOpen":@(YES)};
                self.cellsArray[(path.section)] = dic;
                [self beginUpdates];
                [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
                [self endUpdates];
                [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 190;
    }
    if (_memoryButtonTag == 0) {
        return 430;
    }
    WPDreamingMainGoodsModel * model = self.dataSourceArray[indexPath.section];
    CGFloat cellHeight = 269 + (WINDOW_WIDTH / 2 - 7.5)*ceilf(model.listplan.count/2);
    if (_memoryButtonTag == 1) {
        if (_tagOneItemsHeight.count<=indexPath.row) {
            [_tagOneItemsHeight addObject:@(cellHeight)];
            return cellHeight;
        }else
            return [_tagOneItemsHeight[indexPath.row] floatValue];
    }
    if (_memoryButtonTag == 2) {
        if (_tagTwoItemsHeight.count<=indexPath.row) {
            [_tagTwoItemsHeight addObject:@(cellHeight)];
            return cellHeight;
        }else
            return [_tagTwoItemsHeight[indexPath.row] floatValue];
    }
    return 0;
}

#pragma mark - LoadDatas
-(void)addHeader{
    _tagOneItemsHeight = [NSMutableArray arrayWithCapacity:3];
    _tagTwoItemsHeight = [NSMutableArray arrayWithCapacity:3];
    __weak WPChoiceSubTableView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.mj_header beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPChoiceSubTableView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.url params:@{} datas:^(NSDictionary *responseObject) {
        NSArray * array = [responseObject objectForKey:@"listSub"];
        _dataSourceArray = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < array.count; i++) {
            WPDreamingMainGoodsModel * model = [WPDreamingMainGoodsModel mj_objectWithKeyValues:array[i]];
            [_dataSourceArray addObject:model];
        }
        [_cellsArray removeAllObjects];
        for (int i = 0; i<_dataSourceArray.count; i++) {
            NSDictionary *dic = @{@"Cell":projectCell,@"isOpen":@(NO)};
            [_cellsArray addObject:dic];;
        }
        // 刷新表格
        [weakSelf reloadData];
        // 隐藏当前的上拉刷新控件
        [weakSelf.mj_header endRefreshing];
    } failureBlock:^{
        [weakSelf.mj_header endRefreshing];
    }];
}

@end

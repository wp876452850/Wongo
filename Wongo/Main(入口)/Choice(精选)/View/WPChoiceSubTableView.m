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
#define Urls @[QuerySubIng,QuerySub,QuerySubIng]
#define RegistrationIsIntroducedFigure @[@"guofenzhuanqu.jpg",@"jikeshuma.jpg",@"mengchongxingqiu.jpg",@"jiajujiadian.jpg"]
#define TitleContents @[@"帮助造梦人完成他们期待的梦想",@"帮助造梦人完成他们期待的苹果产品",@"帮助造梦人成为铲屎官~",@"帮助造梦人组成家庭~"]

@interface WPChoiceSubTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _memoryButtonTag;
    
}
@property (nonatomic,strong)NSMutableArray * tagOneItemsHeight;

@property (nonatomic,strong)NSMutableArray * tagTwoItemsHeight;

@property (nonatomic,strong)NSMutableArray * images;

@property (nonatomic,strong)NSMutableArray * cellsArray;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

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
            self.url = Urls[tag];
            _memoryButtonTag = tag;
            [self addHeader];
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
           
            cell.model = self.dataSourceArray[indexPath.section];
            cell.image.image = [UIImage imageNamed:RegistrationIsIntroducedFigure[indexPath.section]];
            cell.instructions.text = [NSString stringWithFormat:@"%@\n【活动内容】\n1.“点击报名”发布自己符合平台要求的事物到活动界面，要求发布的事物需实拍图片清晰，详细文字描述，事物要是新奇有特点优先选择。\n2.可以邀请自己的好友点赞，第1名用户可以直接筛选为造梦用户预备名额。  \n【活动奖励】\n报名被选上的用户直接参与造梦计划，平台可以实现TA的梦想，帮该用户换取一件事物。",TitleContents[indexPath.section]];
            
            return cell;
        }
        
        WPNewDreamingSignUpTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil||![cell isKindOfClass:[WPNewDreamingSignUpTableViewCell class]]) {
            cell = (WPNewDreamingSignUpTableViewCell * )[tableView dequeueReusableCellWithIdentifier:signUp forIndexPath:indexPath];
        }        
        WPDreamingMainGoodsModel * model = self.dataSourceArray[indexPath.section];
        cell.dataSource = [NSMutableArray arrayWithArray:model.listplan];
        cell.browseNumber.text = [NSString stringWithFormat:@"浏览量:%@",model.readview];
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
                [self deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
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
        NSString * string = [NSString stringWithFormat:@"%@\n【活动内容】1.“点击报名”发布自己符合平台要求的事物到活动界面，要求发布的事物需实拍图片清晰，详细文字描述，事物要是新奇有特点优先选择。\n2.可以邀请自己的好友点赞，第1名用户可以直接筛选为造梦用户预备名额。  \n【活动奖励】报名被选上的用户直接参与造梦计划，平台可以实现TA的梦想，帮该用户换取一件事物。",TitleContents[indexPath.section]];
        return 390 + [string getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - 60, MAXFLOAT)].height;
    }
    WPDreamingMainGoodsModel * model = self.dataSourceArray[indexPath.section];
    if (_tagOneItemsHeight.count<=indexPath.section) {
        CGFloat cellHeight = 279 + (WINDOW_WIDTH / 2 - 7.5)*ceilf(model.listplan.count/2.f);
        [_tagOneItemsHeight addObject:@(cellHeight)];
        return cellHeight;
    }else
        return [_tagOneItemsHeight[indexPath.section] floatValue];
}

#pragma mark - LoadDatas
-(void)addHeader{
    __weak WPChoiceSubTableView * weakSelf = self;
    self.mj_header = [WPAnimationHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDatas];
    }];
    [self.mj_header beginRefreshing];
}

-(void)loadNewDatas{
    __weak WPChoiceSubTableView * weakSelf = self;
    weakSelf.tagOneItemsHeight = [NSMutableArray arrayWithCapacity:3];
    weakSelf.tagTwoItemsHeight = [NSMutableArray arrayWithCapacity:3];
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

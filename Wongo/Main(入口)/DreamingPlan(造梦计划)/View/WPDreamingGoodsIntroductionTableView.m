//
//  WPDreamingGoodsIntroductionTableView.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍表

#import "WPDreamingGoodsIntroductionTableView.h"
#import "WPDreamingImageTableViewCell.h"
#import "WPDreamingIntroduceImageModel.h"
#import "WPDreamingIntroduceTableViewCell.h"
#import "WPDreamingGoodsIntroduceModel.h"

@interface WPDreamingGoodsIntroductionTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * cellsHeight;
@end
@implementation WPDreamingGoodsIntroductionTableView
static NSString * const imageCell       = @"imageCell";
static NSString * const introduceCell   = @"introduceCell";
static NSString * const projectCell     = @"ProjectCell";

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:@"WPDreamingImageTableViewCell" bundle:nil] forCellReuseIdentifier:imageCell];
        [self registerNib:[UINib nibWithNibName:@"WPDreamingIntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:introduceCell];
        self.cellsHeight = [NSMutableArray arrayWithCapacity:3];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    NSDictionary *dic = @{@"Cell":imageCell,@"isOpen":@(NO)};
    self.dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<dataSourceArray.count; i++) {       
        [self.dataArray addObject:dic];
    }
    [self reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.dataArray[section] objectForKey:@"isOpen"] boolValue]) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
    {
        WPDreamingImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:imageCell forIndexPath:indexPath];
        
        if (indexPath.section!=0) {
            cell.isFirst.text = @"(参与者)";
        }else{
            cell.isFirst.text = @"(发起者)";
        }
        cell.model = [WPDreamingIntroduceImageModel mj_objectWithKeyValues:self.dataSourceArray[indexPath.section]];
        if (indexPath.section+1<self.dataArray.count) {
            [cell showOK];
        }else [cell showOngoing];
        return cell;

    }
    WPDreamingIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:introduceCell forIndexPath:indexPath];
     cell.model = [WPDreamingIntroduceImageModel mj_objectWithKeyValues:self.dataSourceArray[indexPath.section]];
    return cell;
}

#pragma mark - Table View delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] class] == [WPDreamingImageTableViewCell class]) {
        NSIndexPath * path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
        if ([[self.dataArray[indexPath.section] objectForKey:@"isOpen"] boolValue]) {
            // 关闭附加cell
            NSDictionary * dic = @{@"Cell": @"cell",@"isOpen":@(NO)};
            self.dataArray[(path.section)] = dic;
            [self beginUpdates];
            [self deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
            [self endUpdates];
        }else{
            // 打开附加cell
            NSDictionary * dic = @{@"Cell":introduceCell,@"isOpen":@(YES)};
            self.dataArray[(path.section)] = dic;
            [self beginUpdates];
            [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
            [self endUpdates];
            [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.dataArray[indexPath.section] objectForKey:@"Cell"] isEqualToString:imageCell]) {
        //tableViewCell自身的高的
        return 250;
    }else{
        //弹出cell的高度
        if (indexPath.section >= self.cellsHeight.count) {
            return 300;
        }
        return [self.cellsHeight[indexPath.section] floatValue];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{    
    if (scrollView.contentOffset.y<=-80)
    {
        [[self findViewController:self] w_dismissViewControllerAnimated];
    }
}


@end

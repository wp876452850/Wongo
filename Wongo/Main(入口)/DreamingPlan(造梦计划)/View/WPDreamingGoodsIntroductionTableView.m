//
//  WPDreamingGoodsIntroductionTableView.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍表

#import "WPDreamingGoodsIntroductionTableView.h"
#import "WPDreamingImageTableViewCell.h"
#import "WPDreamingIntroduceTableViewCell.h"
#import "WPDreamingGoodsIntroduceModel.h"

@interface WPDreamingGoodsIntroductionTableView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation WPDreamingGoodsIntroductionTableView
static NSString * const imageCell       = @"imageCell";
static NSString * const introduceCell   = @"introduceCell";

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:@"WPDreamingImageTableViewCell" bundle:nil] forCellReuseIdentifier:imageCell];
        [self registerNib:[UINib nibWithNibName:@"WPDreamingIntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:introduceCell];
        NSDictionary *dic = @{@"Cell":imageCell,@"isOpen":@(NO)};
        NSArray *array =@[dic,dic,dic,dic];
        
        self.dataArray = [[NSMutableArray alloc]init];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:imageCell])
    {
        
        WPDreamingImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:imageCell forIndexPath:indexPath];
        return cell;
        
    }else if([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:introduceCell]){
        
        WPDreamingIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:introduceCell forIndexPath:indexPath];
        return cell;
    }
    
    
    
    
    return nil;
}

#pragma mark - Table View delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[tableView cellForRowAtIndexPath:indexPath] class] == [WPDreamingImageTableViewCell class]) {
        NSIndexPath *path = nil;
        if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:imageCell]) {
            path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
        }else{
            path = indexPath;
        }
        
        if ([[self.dataArray[indexPath.row] objectForKey:@"isOpen"] boolValue]) {
            // 关闭附加cell
            NSDictionary * dic = @{@"Cell": imageCell,@"isOpen":@(NO)};
            self.dataArray[(path.row-1)] = dic;
            [self.dataArray removeObjectAtIndex:path.row];
            
            [self beginUpdates];
            [self deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
            [self endUpdates];
            
        }else{
            // 打开附加cell
            NSDictionary * dic = @{@"Cell": imageCell,@"isOpen":@(YES)};
            self.dataArray[(path.row-1)] = dic;
            NSDictionary * addDic = @{@"Cell": introduceCell,@"isOpen":@(YES)};
            [self.dataArray insertObject:addDic atIndex:path.row];
            
            
            [self beginUpdates];
            [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
            [self endUpdates];
            
        }

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:imageCell]) {
        //tableViewCell自身的高的
        return WINDOW_WIDTH * 0.4;
        
    }else{
        //弹出cell的高度
        return 500;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y<=-150)
    {
        [[self findViewController:self] w_dismissViewControllerAnimated];
    }
}

@end

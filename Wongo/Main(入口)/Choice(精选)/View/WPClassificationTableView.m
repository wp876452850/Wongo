//
//  WPClassificationTableView.m
//  Wongo
//
//  Created by rexsu on 2017/5/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPClassificationTableView.h"
#import "WPGoodsClassModel.h"


@interface WPClassificationTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    TableViewSelectClassification _classificationBlock;
    
}

@property (nonatomic,assign)CGRect initBounds;

@end
@implementation WPClassificationTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        //重新设置锚点
        CGPoint oldAnchorPoint = self.layer.anchorPoint;
        self.layer.anchorPoint = CGPointMake(0.5,0);
        [self.layer setPosition:CGPointMake(self.layer.position.x + self.layer.bounds.size.width * (self.layer.anchorPoint.x - oldAnchorPoint.x),self.layer.position.y +self.layer.bounds.size.height * (self.layer.anchorPoint.y - oldAnchorPoint.y))];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.initBounds = self.bounds;
        self.bounds = CGRectMake(0, 0, self.width, 0);
        self.clipsToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self loadDatas];
    }
    return self;
}


-(void)loadDatas{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:10];
    //交换分类
    __block WPClassificationTableView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryClassoneUrl params:nil datas:^(NSDictionary *responseObject) {
        NSArray * listc = responseObject[@"listc"];
        for (int i = 0; i < listc.count; i++) {
            WPGoodsClassModel * model = [WPGoodsClassModel mj_objectWithKeyValues:listc[i]];
            [weakSelf.dataSourceArray addObject:model];
        }
        WPGoodsClassModel * model = [[WPGoodsClassModel alloc]init];
        model.cid = @"876452850";
        model.cname = @"全部分类";
        [weakSelf.dataSourceArray insertObject:model atIndex:0];
        [weakSelf reloadData];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WPGoodsClassModel * model = self.dataSourceArray[indexPath.row];
    cell.textLabel.text = model.cname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPGoodsClassModel * model = self.dataSourceArray[indexPath.row];
    if (self.indexPath) {
        UITableViewCell * oldCell = [tableView cellForRowAtIndexPath:self.indexPath];
        oldCell.textLabel.textColor = [UIColor blackColor];
    }
    UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.textLabel.textColor = WongoBlueColor;
    
    if (_classificationBlock) {
        _classificationBlock(model.cname,model.cid);
    }
    [self menuClose];
    self.indexPath = indexPath;
}

-(void)getClassificationStringWithBlock:(TableViewSelectClassification)block{
    _classificationBlock = block;
}

-(void)menuOpen{
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = self.initBounds;
    }];
}
-(void)menuClose{
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectMake(0, 0, self.width, 0);
    }];
}
-(void)removeSelect{
    UITableViewCell * oldCell = [self cellForRowAtIndexPath:self.indexPath];
    oldCell.textLabel.textColor = [UIColor blackColor];
    _indexPath = nil;
}
@end

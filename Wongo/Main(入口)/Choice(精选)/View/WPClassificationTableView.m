//
//  WPClassificationTableView.m
//  Wongo
//
//  Created by rexsu on 2017/5/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPClassificationTableView.h"


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
        
        
        self.initBounds = self.bounds;
        self.bounds = CGRectMake(0, 0, self.width, 0);
        self.clipsToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self menuOpen];
    }
    return self;
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    [self reloadData];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.indexPath) {
        UITableViewCell * oldCell = [tableView cellForRowAtIndexPath:self.indexPath];
        oldCell.textLabel.textColor = [UIColor blackColor];
    }
    UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.textLabel.textColor = SelfOrangeColor;
    
    if (_classificationBlock) {
        _classificationBlock(_dataSourceArray[indexPath.row],indexPath.row);
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

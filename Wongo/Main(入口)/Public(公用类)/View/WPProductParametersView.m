//
//  WPProductParametersView.m
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//  产品参数

#import "WPProductParametersView.h"

@interface WPProductParametersView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView     * tableView;
@property (nonatomic,strong)NSDictionary    * dataSource;
@end
@implementation WPProductParametersView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, WINDOW_WIDTH, self.height - 100) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel * titleLabel        = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 60)];
        titleLabel.text             = @"产品参数";
        titleLabel.font             = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment    = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return self;
}

+(instancetype)createProductParametersViewWithDatas:(NSDictionary *)datas{
    WPProductParametersView * productParameters = [[WPProductParametersView alloc]initWithFrame:CGRectZero];
    
    return productParameters;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

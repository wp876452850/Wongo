//
//  WPReportBox.m
//  Wongo
//
//  Created by  WanGao on 2017/9/22.
//  Copyright © 2017年 Winny. All rights reserved.
//


#import "WPReportBox.h"
#include "WPReportBoxTableViewCell.h"
@interface WPReportBox ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSDictionary * params;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataSourceArray;

@property (nonatomic,strong)NSIndexPath * indexPath;

@property (nonatomic,strong)UIButton * report;

@end

@implementation WPReportBox
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:@"WPReportBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = WhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}
-(UIButton *)report{
    if (!_report) {
        _report = [UIButton buttonWithType:UIButtonTypeCustom];
        _report.frame = CGRectMake(0, WINDOW_HEIGHT - 40, WINDOW_WIDTH, 40);
        [_report setTitle:@"确认举报" forState:UIControlStateNormal];
        _report.backgroundColor = WongoBlueColor;
    }
    return _report;
}
+(instancetype)createReportBoxWithGid:(NSString *)gid{
    WPReportBox * reportBox = [[WPReportBox alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    if ([self determineWhetherTheLogin]) {
        reportBox.params = @{@"uid":[reportBox getUserName],@"gid":gid};
        [reportBox setupSubView];
    }
    
    return reportBox;
}

+(instancetype)createReportBoxWithPlid:(NSString *)plid{
    WPReportBox * reportBox = [[WPReportBox alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    if ([self determineWhetherTheLogin]) {
        reportBox.params = @{@"uid":[reportBox getUserName],@"plid":plid};
        [reportBox setupSubView];
    }
    return reportBox;
}


-(void)setupSubView{
    self.dataSourceArray = [NSMutableArray arrayWithArray:@[@"种族歧视",@"垃圾广告",@"虚假信息",@"意思欺诈",@"其它"]];    
    [self addSubview:self.tableView];
    [self addSubview:self.report];
}

//上传
-(void)upData{
    
    [WPNetWorking createPostRequestMenagerWithUrlString:@"" params:self.params datas:^(NSDictionary *responseObject) {
        
        
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPReportBoxTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPReportBoxTableViewCell * cell    = (WPReportBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.indexPath) {
        WPReportBoxTableViewCell * oldCell = (WPReportBoxTableViewCell *)[tableView cellForRowAtIndexPath:self.indexPath];
        oldCell.selectButton.selected   = NO;
        cell.selectButton.selected      = YES;
    }
    else{
        cell.selectButton.selected      = YES;
    }
    self.indexPath                  = indexPath;
}

@end

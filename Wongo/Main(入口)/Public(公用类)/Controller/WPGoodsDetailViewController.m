//
//  WPGoodsDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPGoodsDetailViewController.h"
#import "SDCycleScrollView.h"
#import "WPExchangeDetailModel.h"
#import "WPExchangeCommentsModel.h"
#import "WPExchangeCommentCell.h"
#import "WPUserIntroductionModel.h"
#import "WPUserIntroductionTableViewCell.h"
#import "WPExchangeCommodityInformationCell.h"
#import "WPSelectExchangeGoodsViewController.h"
#import "LoginViewController.h"


static NSString * const commentCell     = @"CommentCell";
static NSString * const userCell        = @"UserCell";
static NSString * const commodityCell   = @"CommodityCell";

@interface WPGoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
//自动滚播器
@property (nonatomic,strong) SDCycleScrollView      * cycleScrollView;
@property (nonatomic,strong) WPExchangeDetailModel  * exchangeModel;
@property (nonatomic,strong) UITableView            * tableView;
@property (nonatomic,strong) NSDictionary           * params;
@property (nonatomic,strong) NSString               * gid;
@property (nonatomic,strong) UIButton               * backButton;
@end

@implementation WPGoodsDetailViewController
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backButton;
}
-(instancetype)initWithGid:(NSString *)gid{
    if (self = [super init]) {
        self.gid = gid;
    }
    return self;
}

#pragma mark - lazyLoad
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 40) style:UITableViewStylePlain];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        _tableView.tableHeaderView  = self.cycleScrollView;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommentCell" bundle:nil] forCellReuseIdentifier:commentCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPUserIntroductionTableViewCell" bundle:nil] forCellReuseIdentifier:userCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommodityInformationCell" bundle:nil] forCellReuseIdentifier:commodityCell];
        [self createBottmView];
        //创建按钮
        
    }
    return _tableView;
}
-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageURLStringsGroup:_exchangeModel.rollPlayImages];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleScrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self navigationLeftPop];
}

-(void)loadDatas{
    __weak WPGoodsDetailViewController * weakSelf = self;
    if (!_gid) {
        return;
    }
    [WPNetWorking createPostRequestMenagerWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_gid} datas:^(NSDictionary *responseObject) {
        _exchangeModel = [WPExchangeDetailModel mj_objectWithKeyValues:responseObject];
        weakSelf.exchangeModel = [WPExchangeDetailModel mj_objectWithKeyValues:responseObject];
        NSArray * images = [responseObject objectForKey:@"listimg"];
        for (int i = 0; i < images.count; i++) {
            NSDictionary * dic = images[i];
            [weakSelf.exchangeModel.rollPlayImages addObject:[dic objectForKey:@"url"]];
        }
        //获取用户信息
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":weakSelf.exchangeModel.uid} datas:^(NSDictionary *responseObject) {
            
            weakSelf.exchangeModel.userIntroductionModel = [WPUserIntroductionModel mj_objectWithKeyValues:responseObject];
            [self.view addSubview:self.tableView];
            [self.view addSubview:self.backButton];
        }];
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1&&_exchangeModel.commentsModelArray.count>0) {
        if (_exchangeModel.commentsModelArray.count>=2) {
            return 3;
        }else{
            return 2;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            WPExchangeCommodityInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:commodityCell forIndexPath:indexPath];
            cell.model = _exchangeModel;
            return cell;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                UITableViewCell * cell      = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"宝贝评价(%ld)",_exchangeModel.commentsModelArray.count]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(@"宝贝评价".length,attributedString.length-@"宝贝评价".length)];
                cell.textLabel.attributedText   = attributedString;
                cell.textLabel.font             = [UIFont systemFontOfSize:15];
                
                cell.selectionStyle             = UITableViewCellSelectionStyleNone;
                cell.accessoryType              =UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else{
                WPExchangeCommentCell * cell    = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
                cell.model                      = _exchangeModel.commentsModelArray[indexPath.row-1];
                return cell;
            }
            
        }
            break;
        case 2:
        {
            WPUserIntroductionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
            cell.model                              = _exchangeModel.userIntroductionModel;
            return cell;
        }
            break;
        case 3:{
            UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text     = @"产品参数";
            cell.textLabel.font     = [UIFont systemFontOfSize:15];
            cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        }
            break;
    }
    
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 95;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return 30;
            }
            return 80;
            
        }
            break;
        case 2:
        {
            return 90;
        }
            break;
        case 3:
        {
            return 40;
        }
            break;
    }
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        
    }
}

-(void)createBottmView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 40, WINDOW_WIDTH, 40)];
    [self.view addSubview:view];
    view.backgroundColor = WhiteColor;
    
   
}

@end

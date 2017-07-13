//
//  WPSelectExchangeGoodsViewController.m
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//  选择进行申请交换的物品

#import "WPSelectExchangeGoodsViewController.h"
#import "WPSelectExchangeGoodsCell.h"
#import "WPMyNavigationBar.h"
#import "WPExchangeOrderViewController.h"
#import "WPSelectExchangeGoodsModel.h"

@interface WPSelectExchangeGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView         * tableView;
@property (nonatomic,strong)NSIndexPath         * indexPath;
@property (nonatomic,strong)WPMyNavigationBar   * nav;
//记录是否选择了
@property (nonatomic,strong)UIButton            * selectButton;
@property (nonatomic,strong)NSMutableArray      * dataSourceArray;
@end

@implementation WPSelectExchangeGoodsViewController

-(instancetype)initWithGid:(NSString *)gid price:(NSString *)price{
    if(self = [super init])
    {
        self.gid1   = gid;
        self.price1 = price;
    }
    return self;
}
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"选择进行交换的物品";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 104) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, -20);
        _tableView.backgroundColor = ColorWithRGB(230, 230, 230);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WPSelectExchangeGoodsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}



-(void)loadDatas{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:3];
    [WPNetWorking createPostRequestMenagerWithUrlString:MyGoodsUrl params:@{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]} datas:^(NSDictionary *responseObject) {
        NSArray * goods = [responseObject objectForKey:@"goods"];
        for (int i = 0; i < goods.count; i++) {
            WPSelectExchangeGoodsModel * model = [WPSelectExchangeGoodsModel mj_objectWithKeyValues:goods[i]];
            
            [self.dataSourceArray addObject:model];
        }
        
        [self.tableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nav];
    UIButton * button           = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor      = SelfOrangeColor;
    button.frame                = CGRectMake(0, WINDOW_HEIGHT - 40, WINDOW_WIDTH, 40);
    button.layer.masksToBounds  = YES;
    button.layer.cornerRadius   = 5;
    [button addTarget:self action:@selector(goNextViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDatas];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPSelectExchangeGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPSelectExchangeGoodsCell * cell    = (WPSelectExchangeGoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (self.indexPath&&!cell.selectButton.selected) {
            WPSelectExchangeGoodsCell * oldCell = (WPSelectExchangeGoodsCell *)[tableView cellForRowAtIndexPath:self.indexPath];
            oldCell.selectButton.selected   = NO;
            cell.selectButton.selected      = YES;
            self.indexPath                  = indexPath;
            self.selectButton = cell.selectButton;
        }
    else{
        cell.selectButton.selected      = YES;
        self.indexPath                  = indexPath;
        self.selectButton               = cell.selectButton;
    }
    WPSelectExchangeGoodsModel * model =self.dataSourceArray[indexPath.row];
    self.gid2   = model.gid;
    self.price2 = model.price;
}

-(void)goNextViewController{
    if (self.selectButton){
        [self showAlertWithAlertTitle:@"提示" message:@"是否确认交换" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确认",@"取消"] block:^{
            
            [WPNetWorking createPostRequestMenagerWithUrlString:GenerateOrderUrl params:
                                @{@"ordernum":[self getOrderNumber],
                                  @"gid1":self.gid2,
                                  @"gid2":self.gid1,
                                  @"sum":[NSString stringWithFormat:@"%ld",([self.price1 integerValue]+[self.price2 integerValue])],
                                  @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:User_ID]} datas:^(NSDictionary *responseObject)
            {
                WPExchangeOrderViewController * vc = [[WPExchangeOrderViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
        }];
    }
    else{
        [self showAlertWithAlertTitle:@"提示" message:@"请选择商品" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    
}
@end

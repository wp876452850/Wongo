//
//  WPShopingCarViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/15.
//  Copyright © 2016年 Wongo. All rights reserved.
//  我的购物车

#import "WPShopingCarViewController.h"
#import "WPShopingCarTableViewCell.h"
#import "WPMyNavigationBar.h"
#import "WPShoppingCarModel.h"

#define RowHeight 80
@interface WPShopingCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
/**请求的数据*/
@property (nonatomic,strong)NSMutableArray * dataSource;
/**勾选的数据*/
@property (nonatomic,strong)NSMutableArray * selectedArray;
/**当购物车不存在数据是展示试图*/
@property (nonatomic,strong)UIView * nullDataView;
/**全选按钮*/
@property (nonatomic,strong)UIButton * allSellectedButton;
/**总价*/
@property (nonatomic,strong)UILabel * totalPriceLabel;
@end

@implementation WPShopingCarViewController
static NSString * const reuseIdentifier = @"Cell";
- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 114) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = RowHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"WPShopingCarTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

-(UIView *)nullDataView
{
    if (!_nullDataView) {
        _nullDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
        _nullDataView.tag = 100;
        _nullDataView.backgroundColor = ColorWithRGB(0, 255, 255);
        UIImageView * imageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shopingCar"]];
        imageView.bounds = CGRectMake(0, 0, 200, 200);
        imageView.center = CGPointMake(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2-64);
        [self.view addSubview:_nullDataView];
        [_nullDataView addSubview:imageView];
    }
    return _nullDataView;
}
#pragma mark 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购物车";
    self.view.backgroundColor = ColorWithRGB(255, 255, 255);
    [self customNavigation];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - 界面布局
#pragma mark 自定义导航
-(void)customNavigation{
    WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
    customNav.title.text = self.title;
    [self.view addSubview:customNav];
    [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 自定义底部视图
-(void)customBottomView{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50)];
    backView.backgroundColor = ColorWithRGB(255, 255, 255);
    [self.view addSubview:backView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, WINDOW_WIDTH, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
    selectAll.frame = CGRectMake(10, 5, 80, 40);
    [selectAll setTitle:@"  全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"clickChoose_normal"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    UILabel * label = [[UILabel alloc]init];
    label.textColor = ColorWithRGB(254, 107, 56);
    label.text = @"总价:￥0";
    label.font = [UIFont systemFontOfSize:16];
    [backView addSubview:label];
    self.totalPriceLabel = label;
    //结算按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:button];
    button.backgroundColor = ColorWithRGB(237, 85, 100);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"结算" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(WINDOW_WIDTH - 100, 0, 100, 50);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectAll.mas_right).offset(10);
        make.right.mas_equalTo(button.mas_left).offset(-10);
        make.centerY.mas_equalTo(selectAll.mas_centerY);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark 底部按钮点击事件
#pragma mark 全选按钮点击
-(void)selectAllBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (WPShoppingCarModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (sender.selected) {
        
        for (WPShoppingCarModel *model in self.dataSource) {
            model.select = YES;
            [self.selectedArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
    [self countPrice];

}
#pragma mark 去结算按钮
-(void)goToPayButtonClick:(UIButton *)sender
{
    
}

-(void)loadData{
    [self createDataAndModel];
    [self changeView];
}

#warning 假数据,用于测试,有服务器时修改
-(void)createDataAndModel{
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0 ; i < 10; i++) {
        WPShoppingCarModel * model = [[WPShoppingCarModel alloc]init];
        model.goodsName = [NSString stringWithFormat:@"商品--%d",i];
        model.goodsImage_url = @"http://img3.utuku.china.com/550x0/news/20170201/d57ad437-2ddc-418e-998a-fbba46259231.jpg";
        model.goodsNumber = @"1";
        model.price = [NSString stringWithFormat:@"%d",arc4random()%200];
        model.price_unit = @"￥";
        [self.dataSource addObject:model];
    }
}
#pragma mark 判断购物车是否存在数据,选择不同展示试图
-(void)changeView
{
    if (self.dataSource.count > 0) {
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.tableView];
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (_nullDataView) {
            [self.view sendSubviewToBack:self.nullDataView];
        }
        [self customBottomView];
        return;
    }
    [self.view bringSubviewToFront:self.nullDataView];
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}
#pragma 计算已选商品价格
-(void)countPrice
{
    double totlePrice = 0.0;
    
    for (WPShoppingCarModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price * [model.goodsNumber integerValue];
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    
    self.totalPriceLabel.attributedText = [self LZSetString:string];

}
- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"总价:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"总价:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:ColorWithRGB(237, 85, 100) range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rang];
    return LZString;
}
-(void)reloadTable{
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.dataSourceArray.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPShopingCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    WPShoppingCarModel * model = self.dataSource[indexPath.row];
    
    __block typeof(cell)wsCell = cell;
    [cell numberWithAddBlock:^(NSInteger number) {
        wsCell.goodsNumber.text = [NSString stringWithFormat:@"%ld",number];
        model.goodsNumber = [NSString stringWithFormat:@"%ld",number];
        
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberWithCutBlock:^(NSInteger number) {
        wsCell.goodsNumber.text = [NSString stringWithFormat:@"%ld",number];
        model.goodsNumber = [NSString stringWithFormat:@"%ld",number];
        
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelctWithBlock:^(BOOL select) {
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataSource.count) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
        [self countPrice];

    }];
    [cell showDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            WPShoppingCarModel *model = [self.dataSource objectAtIndex:indexPath.row];
            
            [self.dataSource removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //判断删除的商品是否已选择
            if ([self.selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [self.selectedArray removeObject:model];
                [self countPrice];
            }
            
            if (self.selectedArray.count == self.dataSource.count) {
                _allSellectedButton.selected = YES;
            } else {
                _allSellectedButton.selected = NO;
            }
            
            if (self.dataSource.count == 0) {
                [self changeView];
            }
            
            //如果删除的时候数据紊乱,可延迟0.5s刷新一下
            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

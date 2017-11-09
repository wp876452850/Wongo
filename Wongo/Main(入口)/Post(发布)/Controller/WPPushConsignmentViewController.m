//
//  WPPushConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushConsignmentViewController.h"
#import "WPDreamingDataTableViewCell.h"
#import "WPDreamingDescribeTableViewCell.h"
#import "WPDremingImagesCellTableViewCell.h"
#import "WPAddImagesButton.h"
#import "WPRegionTableViewCell.h"
#import "WPMyNavigationBar.h"
#import "WPAddressSelectViewController.h"
#import "WPSelectAlterView.h"
#import "WPPushParameterTableViewCell.h"
#import "WPGoodsClassModel.h"

#define Push_Titles @[@"名称：",@"描述：",@"",@"价格(￥)：",@"种类：",@"新旧程度：",@"库存(件)：",@"产品参数："]
#define Section_0_Placeholder @[@"商品名称",@"介绍宝贝的尺码、材质等信息",@"",@"请输入价格",@"",@"",@"请输入库存",@""]

@interface WPPushConsignmentViewController ()<UITableViewDelegate,UITableViewDataSource>{

    //记录图片组单元格高度
    CGFloat imagesCellHeight;
    //记录数据组单元格高度
    CGFloat dataCellHeight;
    //记录描述组单元格高度
    CGFloat describeCellHeight;
    /////////////
    ///物品信息///
    ////////////
    //商品名称
    NSString * _name;
    //商品描述
    NSString * _describe;
    //商品新旧程度
    NSString * _newOrOld;
    //商品价格
    NSString * _price;
    //库存
    NSString * _inventory;
    //种类
    NSString * _species;
    //种类id
    NSString * _specieid;
    //是否同意协议说明
    BOOL       _isAgreed;
    
    //参数单元格数量
    NSInteger  _parameterCellNumber;
}
//选择表
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * images;
//参数
@property (nonatomic,strong)NSMutableArray * parameters;

@end

@implementation WPPushConsignmentViewController

static NSString * const dataCell        = @"DataCell";
static NSString * const describeCell    = @"DescribeCell";
static NSString * const imagesCell      = @"ImageCell";
static NSString * const cell            = @"cell";
static NSString * const parameter       = @"Parameter";

-(UITableView *)tableView
{
    if (!_tableView) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 114) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDataTableViewCell" bundle:nil] forCellReuseIdentifier:dataCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDescribeTableViewCell" bundle:nil] forCellReuseIdentifier:describeCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDremingImagesCellTableViewCell" bundle:nil] forCellReuseIdentifier:imagesCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPPushParameterTableViewCell" bundle:nil] forCellReuseIdentifier:parameter];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell];
        
        dataCellHeight = 50;
        describeCellHeight = 130;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"发布寄卖";
    self.view.backgroundColor = WhiteColor;
    
    UIButton * button       = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor  = WongoBlueColor;
    button.titleLabel.font = [UIFont systemFontOfSize:19];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushConsignment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH, 50));
    }];

}
#pragma mark - 发布寄卖
-(void)pushConsignment{
    __block typeof(self)weakSelf = self;
    [self.parameters removeAllObjects];
    //收编参数集
    for (int i = 0; i < _parameterCellNumber; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:7];
        WPPushParameterTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.parameterName.titleLabel.text.length > 0&&cell.parameter.text.length > 0) {
            NSDictionary * dic = @{@"parameterName":cell.parameterName.titleLabel.text,@"parameter":cell.parameter.text};
            [self.parameters addObject:dic];
        }else if((cell.parameterName.titleLabel.text.length > 0&&cell.parameter.text.length <= 0)||(cell.parameterName.titleLabel.text.length <= 0&&cell.parameter.text.length > 0)){
            [self showAlertWithAlertTitle:@"提示" message:@"请输入完整的参数" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
            return;
        }
    }
    if ([_price floatValue]<0) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得小于0" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    if ([_price floatValue]>999999) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得大于999999" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    if (_name.length!=0&&_describe.length!=0&&_species.length!=0&&_price.length!=0&&_inventory.length!=0&&_newOrOld.length!=0) {
        
        NSString * timeStr = [self getNowTime];
        
        NSDictionary * params = @{@"pubtime":timeStr,@"gname":_name,@"remark":_describe,@"gcid":_specieid,@"price":@([_price floatValue]),@"repertory":@([_inventory integerValue]),@"neworold":_newOrOld,@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]};
        
        [WPNetWorking createPostRequestMenagerWithUrlString:PushExchangeUrl params:params datas:^(NSDictionary *responseObject) {
            NSString * flag = [responseObject objectForKey:@"flag"];
            if ([flag integerValue] == 1) {
                //上传图片
                [WPGCD createUpLoadImageGCDWithImages:weakSelf.images urlString:PushImageUrl params:@{@"gid":[responseObject objectForKey:@"gid"]}];
                [self showAlertWithAlertTitle:@"上传成功" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else{
                [self showAlertWithAlertTitle:@"上传失败" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
            }
        }];
    }else{
        [self showAlertWithAlertTitle:@"请输入完整的信息" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 7) {
        return _parameterCellNumber + 1;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Push_Titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
        {
            WPDreamingDescribeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:describeCell forIndexPath:indexPath];
            
            [cell getDescribeBlockWithBlock:^(NSString *str) {
                _describe = str;
            }];
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 2:
        {
            WPDremingImagesCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:imagesCell forIndexPath:indexPath];
            [cell.contentView removeAllSubviews];
            cell.images = self.images;
            imagesCellHeight = cell.rowHeight;
            [cell getRowDataWithBlock:^(NSMutableArray *images, NSInteger heightRow) {
                _images = images;
                imagesCellHeight = heightRow;
                [tableView reloadData];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 4:case 5:
        {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = Push_Titles[indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 4) {
                if (_species) {
                    cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.section],_species];
                }
            }else{
                if (_newOrOld) {
                    cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.section],_newOrOld];
                }
            }
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 7:{
            if (indexPath.row == _parameterCellNumber) {
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.bounds = CGRectMake(0, 0, 100, 40);
                button.center = CGPointMake(WINDOW_WIDTH/2, 25);
                [button setTitleColor:WongoBlueColor forState:UIControlStateNormal];
                [button setTitle:@"添加参数" forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:button];
                [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
                return cell;
            }else{
                WPPushParameterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:parameter forIndexPath:indexPath];
                [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
                return cell;
            }
        }
            break;
    }
    WPDreamingDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dataCell forIndexPath:indexPath];
    cell.data.superView     = self.view;
    cell.name.text          = Push_Titles[indexPath.section];
    cell.data.placeholder   = Section_0_Placeholder[indexPath.section];
    if (indexPath.section == 3) {
        cell.data.text = _price;
        cell.data.keyboardType = UIKeyboardTypeDecimalPad;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _price = cell.data.text;
        }];
    }
    else if (indexPath.section == 6){
        cell.data.text              = _inventory;
        cell.data.openRisingView    = YES;
        cell.data.keyboardType      = UIKeyboardTypeNumberPad;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _inventory = cell.data.text;
        }];
    }else{
        cell.data.text          = _name;
        cell.data.keyboardType  = UIKeyboardTypeDefault;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _name = cell.data.text;
        }];
    }
    [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return describeCellHeight;
    }
    else if (indexPath.section == 2){
        return imagesCellHeight;
    }
    return dataCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 5;
    }
    if (section == Push_Titles.count - 1) {
        return 5;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end

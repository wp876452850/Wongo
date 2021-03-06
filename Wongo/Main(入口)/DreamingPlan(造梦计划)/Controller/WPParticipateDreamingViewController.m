//
//  WPParticipateDreamingViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPParticipateDreamingViewController.h"
#import "WPDreamingDataTableViewCell.h"
#import "WPDreamingDescribeTableViewCell.h"
#import "WPDremingImagesCellTableViewCell.h"
#import "WPAddImagesButton.h"
#import "WPRegionTableViewCell.h"
#import "WPMyNavigationBar.h"
#import "WPAddressSelectViewController.h"
#import "WPSelectAlterView.h"

#define Push_Titles @[@"名称：",@"描述：",@"",@"金额(￥)：",@"种类：",@"新旧程度：",@"目标商品：",@"收货地址：",@""]

#define Section_0_Placeholder @[@"最多可填写15个字",@"介绍宝贝的尺码、材质等信息",@"",@"请输入商品价值",@"",@"",@"描述你的希望换到什么物品",@"",@""]

static NSString * const dataCell        = @"DataCell";
static NSString * const describeCell    = @"DescribeCell";
static NSString * const imagesCell      = @"ImageCell";
static NSString * const cell            = @"cell";

@interface WPParticipateDreamingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
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
    //种类
    NSString * _species;
    //种类
    NSString * _specieid;
    /**造梦故事*/
    NSString * _want;
    /**收货地址*/
    NSString * _adid;
    /**参与的造梦id*/
    NSString * _plid;
    //是否同意协议说明
    BOOL       _isAgreed;
    
}
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * images;
//自定义导航
@property (nonatomic,strong)WPMyNavigationBar * nav;
//同意协议按钮
@property (nonatomic,strong)UIButton * button;
@end

@implementation WPParticipateDreamingViewController
-(instancetype)initWithProid:(NSString *)plid{
    if (self = [super init]) {
        _plid = plid;
    }
    return self;
}
-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"填写造梦资料";
        [_nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"select_normal_address"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(w_changeBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        _button.bounds  = CGRectMake(0, 0, 25, 25);
        _button.right   = WINDOW_WIDTH - 10;
        _button.centerY = 25;
    }
    return _button;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 114) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDataTableViewCell" bundle:nil] forCellReuseIdentifier:dataCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDescribeTableViewCell" bundle:nil] forCellReuseIdentifier:describeCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDremingImagesCellTableViewCell" bundle:nil] forCellReuseIdentifier:imagesCell];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell];
        dataCellHeight = 50;
        describeCellHeight = 130;
    }
    return _tableView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nav];
    self.images = [NSMutableArray arrayWithCapacity:3];
    
    UIButton * button       = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor  = ColorWithRGB(105, 152, 192);
    [button setTitle:@"参与造梦" forState:UIControlStateNormal];
    button.titleLabel.font  = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(goNextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH, 50));
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return Push_Titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        {
            WPDreamingDescribeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:describeCell forIndexPath:indexPath];
            cell.textView.placeholder = Section_0_Placeholder[indexPath.section];
            [cell getDescribeBlockWithBlock:^(NSString *str) {
                _describe = str;
            }];            
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
            return cell;
        }
            break;
        case 4:case 5:case 7:case 8:
        {
            //跳转地址选择控制器
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = Push_Titles[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 4) {
                if (_species) {
                    cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],_species];
                }
            }else if (indexPath.row == 5){
                if (_newOrOld) {
                    cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],_newOrOld];
                }
            }
            else if (indexPath.row == 8){
                NSString * name = @"我同意 ";
                NSString * comments = @"《造梦计划平台说明协议》";
                
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",name,comments]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, name.length+comments.length)];
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:SelfThemeColor range:NSMakeRange(name.length, comments.length)];
                
                cell.textLabel.numberOfLines    = 0;
                cell.textLabel.attributedText   = attributedString;
                [cell.textLabel yb_addAttributeTapActionWithStrings:@[comments] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
                    [self showAlertWithAlertTitle:@"《造梦计划平台说明协议》" message:@"巴巴爸爸不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不不巴巴爸爸不不不不不不不无安哥拉让你红辣椒魁北克哥居然把接口互不干扰感觉困" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                }];
                [cell.contentView addSubview:self.button];
            }
            else{
                if (_adid) {
                    cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],_adid];
                }
            }
            return cell;
        }
            break;
    }
    WPDreamingDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dataCell forIndexPath:indexPath];
    cell.data.superView     = self.tableView;
    cell.data.superViewIsTableViewCell = YES;
    cell.data.placeholder   = Section_0_Placeholder[indexPath.row];
    cell.name.text          = Push_Titles[indexPath.row];
    cell.name.width         = [UILabel getWidthWithTitle:cell.name.text font:[UIFont systemFontOfSize:16]];
    cell.data.keyboardType  = UIKeyboardTypeDefault;
    if (indexPath.row == 3) {
        cell.data.text = _price;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _price = cell.data.text;
            
        }];
        cell.data.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if (indexPath.row == 6){
        cell.data.text = _want;
        cell.data.openRisingView = YES;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _want = cell.data.text;
        }];
    }
    else if (indexPath.row == 0){
        cell.data.text = _name;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _name = cell.data.text;
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==1) {
        return describeCellHeight;
    }
    else if (indexPath.row == 2){
        return imagesCellHeight;
    }
    return dataCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        WPSelectAlterView * selectAlterView = [WPSelectAlterView createURLSelectAlterWithFrame:self.view.frame urlString:CommodityTypeUrl params:nil block:^(NSString *string,NSString * gcid) {
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],string];
            
            _species = string;
            _specieid = gcid;
        } selectedCategoryName:_species];
        [self.view addSubview:selectAlterView];
    }else if (indexPath.row == 5){
        WPSelectAlterView * selectAlterView = [WPSelectAlterView createArraySelectAlterWithFrame:self.view.frame array:@[@"全新",@"九成新",@"八成新",@"七成新",@"六成新",@"五成新",@"其他"] block:^(NSString *string,NSString * gcid) {
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],string];
            _newOrOld      = string;
        } selectedCategoryName:_newOrOld];
        [self.view addSubview:selectAlterView];
    }
    else if (indexPath.row == 7){
        WPAddressSelectViewController * vc = [[WPAddressSelectViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        [vc getAdidAndAddressWithBlock:^(WPAddressModel *address) {
            _adid = [NSString stringWithFormat:@"%ld",address.adid];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],address.address];
        }];
    }
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 发布(报名)造梦
-(void)goNextVC{
    if (!self.button.selected) {
        [self showAlertWithAlertTitle:@"提示" message:@"需要同意《造梦计划平台说明协议》规则后才能发布造梦计划" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    if ([_price floatValue]<0) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得小于0" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    if ([_price floatValue]>999999) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得大于999999" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    __weak WPParticipateDreamingViewController * weakSelf = (WPParticipateDreamingViewController*)self;
    if (_name.length!=0&&_describe.length!=0&&_species.length!=0&&_price.length!=0&&_want.length!=0&&_newOrOld.length!=0&&_adid.length!=0) {
        
        NSString * timeStr = [self getNowTime];
        
#warning plid修改
        NSDictionary * params = @{@"uid":[self getSelfUid],@"proname":_name,@"gcid":_specieid,@"price":_price,@"remark":_describe,@"neworold":_newOrOld,@"adid":_adid,@"want":_want,@"pubtime":timeStr,@"plid":_plid};
        
        [WPNetWorking createPostRequestMenagerWithUrlString:JoinProUrl params:params datas:^(NSDictionary *responseObject) {
            NSString * flag = [responseObject objectForKey:@"flag"];
            if ([flag integerValue] == 1) {
                //上传图片
                [WPGCD createUpLoadImageGCDWithImages:weakSelf.images urlString:UpProFileUrl params:@{@"proid":[responseObject objectForKey:@"proid"]}];
                [self showAlertWithAlertTitle:@"成功参与造梦计划,请耐心等待工作人员审核" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                    [self w_popViewController];
                }];
            }
            else{
                [self showAlertWithAlertTitle:@"未能成功参与造梦计划,请重新发布参与商品" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
            }
        }];
    }else{
        [self showAlertWithAlertTitle:@"请输入完整的信息" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
}
@end

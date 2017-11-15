//
//  WPPushDreamingViewController.m
//  Wongo
//
//  Created by rexsu on 2017/5/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushDreamingViewController.h"
#import "WPDreamingDataTableViewCell.h"
#import "WPDreamingDescribeTableViewCell.h"
#import "WPDremingImagesCellTableViewCell.h"
#import "WPAddImagesButton.h"
#import "WPRegionTableViewCell.h"
#import "WPMyNavigationBar.h"
#import "WPAddressSelectViewController.h"
#import "WPSelectAlterView.h"
#import "WPPayDepositViewController.h"

#define Push_Titles @[@"名称：",@"描述：",@"",@"商品价值(￥)：",@"种类：",@"新旧程度：",@"故事：",@"成为造梦人?：",@"收货地址：",@""]

#define Section_0_Placeholder @[@"商品名称",@"介绍宝贝的尺码、材质等信息",@"描述你的造梦计划,希望换到什么物品",@"",@"请输入商品价值",@"",@"请说说物品的来源和故事,准确描述您的故事，能够增加被入选的机会",@"描述你的造梦计划,希望换到什么物品",@"",@"",@""]


static NSString * const dataCell        = @"DataCell";
static NSString * const describeCell    = @"DescribeCell";
static NSString * const imagesCell      = @"ImageCell";
static NSString * const cell            = @"cell";

@interface WPPushDreamingViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    //种类id
    NSString * _specieid;
    /**造梦故事*/
    NSString * _story;
    /**造梦计划*/
    NSString * _contents;
    /**收货地址*/
    NSString * _adid;
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

@implementation WPPushDreamingViewController

-(WPMyNavigationBar *)nav{
    if (!_nav) {
        _nav = [[WPMyNavigationBar alloc]init];
        _nav.title.text = @"填写造梦资料";
        [_nav.leftButton addTarget:self action:@selector(w_dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
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
-(instancetype)initWithSubid:(NSString *)subid{
    if (self = [super init]) {
        self.subid = subid;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nav];
    
    self.images = [NSMutableArray arrayWithCapacity:3];
    UIButton * button       = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor  = WongoBlueColor;
    [button setTitle:@"发布" forState:UIControlStateNormal];
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

-(void)setIsPush:(BOOL)isPush{
    _isPush = isPush;
    if (_isPush) {
        [self.nav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:case 6:
        {
            WPDreamingDescribeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:describeCell forIndexPath:indexPath];
            cell.title.text = Push_Titles[indexPath.row];
            cell.textView.placeholder = Section_0_Placeholder[indexPath.row];
            if (indexPath.row == 1) {
                [cell getDescribeBlockWithBlock:^(NSString *str) {
                    _describe = str;
                }];
            }else{
                [cell getDescribeBlockWithBlock:^(NSString *str) {
                    _story = str;
                }];
            }
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
        case 4:case 5:case 8:case 9:
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
            else if (indexPath.row == 9){
                NSString * name = @"我同意 ";
                NSString * comments = @"《造梦计划平台说明协议》";
                
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",name,comments]];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, name.length+comments.length)];
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:WongoBlueColor range:NSMakeRange(name.length, comments.length)];
                
                cell.textLabel.numberOfLines    = 0;
                cell.textLabel.attributedText   = attributedString;
                [cell.textLabel yb_addAttributeTapActionWithStrings:@[comments] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertWithAlertTitle:@"《造梦计划平台说明协议》" message:@"您不得利用碗糕发表、传送、传播、储存违反国家法律、危害国家安全、祖国统一、社会稳定、公序良俗的内容，或任何不当的、侮辱诽谤的、淫秽的、暴力的及任何违反国家法律法规政策的内容或侵害他人知识产权、商业秘密权、隐私权等合法权利的内容，也不得传送或散布以其他方式实现传送含有受到知识产权法律保护的图像、相片、软件或其他资料的文件，除非用户拥有或控制着相应的权利或已得到所有必要的认可。否则，一经发现或收到举报，碗糕有权删除并处理" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
                    });
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
    else if (indexPath.row == 0){
        cell.data.text = _name;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _name = cell.data.text;
        }];
    }
    else if (indexPath.row == 7){
        cell.data.text = _contents;
        cell.wordsNumber = 99999999;
        cell.data.openRisingView = YES;
        [cell getTextFieldDataWithBlock:^(NSString *str) {
            _contents = cell.data.text;
        }];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==1||indexPath.row ==6) {
        return describeCellHeight;
    }
    else if (indexPath.row == 2){
        return imagesCellHeight;
    }
    return dataCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        WPSelectAlterView * selectAlterView = [WPSelectAlterView createURLSelectAlterWithFrame:self.view.frame urlString:CommodityTypeUrl params:nil block:^(NSString *string ,NSString * gcid) {
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
    else if (indexPath.row == 8){
        WPAddressSelectViewController * vc = [[WPAddressSelectViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        [vc getAdidAndAddressWithBlock:^(WPAddressModel *addr) {
            _adid = [NSString stringWithFormat:@"%ld",addr.adid];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text    = [NSString stringWithFormat:@"%@%@",Push_Titles[indexPath.row],addr.address];
        }];
    }
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)payFee{
    __block typeof(self)weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:SignupAddUrl params:@{@"proid":@""} datas:^(NSDictionary *responseObject) {
        
    }];
}

#pragma mark - 发布(报名)造梦
-(void)goNextVC{
    if (![self determineWhetherTheLogin]) {
        return;
    }
    if (!self.button.selected) {
        [self showAlertWithAlertTitle:@"提示" message:@"需要同意《造梦计划平台说明协议》规则后才能发布造梦计划" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    if (!self.subid) {
        self.subid = @"1";
    }
    if ([_price floatValue]<0) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得小于0" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    if ([_price floatValue]>999999) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得大于999999" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
    __block WPPushDreamingViewController * weakSelf = (WPPushDreamingViewController*)self;
    if (_name.length!=0&&_describe.length!=0&&_species.length!=0&&_price.length!=0&&_story.length!=0&&_newOrOld.length!=0&&_contents.length!=0&&_adid.length!=0) {
        
        NSString * timeStr = [self getNowTime];
        
        NSDictionary * params = @{@"uid":[self getSelfUid],@"proname":_name,@"gcid":_specieid,@"price":_price,@"remark":_describe,@"neworold":_newOrOld,@"adid":_adid,@"story":_story,@"contents":_contents,@"subid":_subid,@"pubtime":timeStr,@"want":@"123"};
        
        [WPNetWorking createPostRequestMenagerWithUrlString:AddProduct params:params datas:^(NSDictionary *responseObject) {
            NSString * flag = [responseObject objectForKey:@"flag"];
            if ([flag integerValue] == 1) {
                //上传图片
                [WPGCD createUpLoadImageGCDWithImages:weakSelf.images urlString:UpProFileUrl params:@{@"proid":[responseObject objectForKey:@"proid"]}];
                [self showAlertWithAlertTitle:@"上传成功" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                    [self popoverPresentationController];
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

@end

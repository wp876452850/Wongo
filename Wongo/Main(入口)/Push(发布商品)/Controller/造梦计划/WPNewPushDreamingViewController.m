//
//  WPNewPushDreamingViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushDreamingViewController.h"
//支付
#import "WPPayDepositViewController.h"
//cell
//用户信息
#import "WPNewPushUserInformationCollectionViewCell.h"
//商品信息
#import "WPNewPushCommodityInformationCollectionViewCell.h"
//图片信息
#import "WPNewPushImagesCollectionViewCell.h"
//地址信息
#import "WPNewPushAddressSelectCollectionViewCell.h"
//可输入信息框
#import "WPPushDetailInformationCollectionViewCell.h"
//选择框
#import "WPNewPushSelectCollectionViewCell.h"
//造梦故事
#import "WPNewPushStoreCollectionViewCell.h"
//条款条例
#import "WPNewPushTermsCollectionViewCell.h"

#define Placeholders @[@"请选择商品种类",@"请选择商品新旧程度",@"请输入商品价值(￥)",@"是否成为寄梦人?"]
#define Titles @[@"请选择您进行造梦的商品所属种类",@"请选择您进行造梦的商品新旧程度",@"请输入您进行造梦的商品预估价值",@"是否同意成为寄梦人?"]

static NSString * const userInformationCell         = @"userInformationCell";
static NSString * const commodityInformationCell    = @"commodityInformationCell";
static NSString * const imagesCell  = @"imagesCell";
static NSString * const addressCell = @"addressCell";
static NSString * const detailInformationCell       = @"detailInformationCell";
static NSString * const selectCell  = @"selectCell";
static NSString * const termsCell   = @"termsCell";
static NSString * const storeCell   = @"storeCell";

@interface WPNewPushDreamingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //记录图片组单元格高度
    CGFloat imagesCellHeight;
    //记录数据组单元格高度
    CGFloat dataCellHeight;
    //记录描述组单元格高度
    CGFloat describeCellHeight;
    //记录造梦故事单元格高度
    CGFloat storeCellHeight;
    
    /////////////
    ///物品信息///
    ////////////
    //用户姓名
    NSString * _userName;
    //用户电话
    NSString * _userPhone;
    //用户邮件
    NSString * _userMail;
    
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
    /**收货地址*/
    NSString * _adid;
    //是否同意协议说明
    BOOL       _isAgreed;
}
@property (nonatomic,strong)UICollectionView * collectionView;
//存放图片
@property (nonatomic,strong)NSMutableArray * images;
//发布按钮
@property (nonatomic,strong)UIButton * pushButton;
//item 高度
@property (nonatomic,strong)NSMutableArray * itemHeights;
@end

@implementation WPNewPushDreamingViewController

-(UIButton *)pushButton{
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushButton.frame = CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50);
        _pushButton.backgroundColor  = WongoBlueColor;
        [_pushButton setTitle:@"同意条款并开始我的造梦计划" forState:UIControlStateNormal];
        _pushButton.titleLabel.font  = [UIFont systemFontOfSize:15];
        [_pushButton addTarget:self action:@selector(payFee) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}
//懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 114) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushUserInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:userInformationCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushCommodityInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:commodityInformationCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushImagesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imagesCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushAddressSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:addressCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPPushDetailInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:detailInformationCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:selectCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushStoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:storeCell];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushTermsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:termsCell];
        
        _collectionView.backgroundColor = AllBorderColor;
        imagesCellHeight = 175.f;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"报名造梦计划";
    self.itemHeights = [NSMutableArray arrayWithCapacity:3];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pushButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayBack:) name:AliPaySignup object:nil];
}

#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 4||section == 6) {
        return CGSizeZero;
    }
    return CGSizeMake(WINDOW_WIDTH, 5);
}

//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return CGSizeMake(WINDOW_WIDTH, 220.f);
        }
        case 1:
        {
            if (describeCellHeight<200.f) {
                return CGSizeMake(WINDOW_WIDTH, 200.f);
            }
            return CGSizeMake(WINDOW_WIDTH, describeCellHeight);
        }
        case 2:
        {
            return CGSizeMake(WINDOW_WIDTH, imagesCellHeight);
        }
        case 3:case 4: case 5:case 6:case 7:
        {
            return CGSizeMake(WINDOW_WIDTH, 70.f);
        }
        case 8:
        {
            if (storeCellHeight<200.f) {
                return CGSizeMake(WINDOW_WIDTH, 200.f);
            }
            return CGSizeMake(WINDOW_WIDTH, storeCellHeight);
        }
        case 9:
        {
            return CGSizeMake(WINDOW_WIDTH, 250.f);
        }
    }
    return CGSizeMake(WINDOW_WIDTH, 150.f);
}

//区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}
//item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            //用户信息
        case 0:
        {
            WPNewPushUserInformationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:userInformationCell forIndexPath:indexPath];
            //名字
            [cell getNameBlockWithBlock:^(NSString *str) {
                _userName = str;
            }];
            //电话
            [cell getPhoneBlockWithBlock:^(NSString *str) {
                _userPhone = str;
            }];
            //邮箱
            [cell getMailBlockWithBlock:^(NSString *str) {
                _userMail = str;
            }];
            
            return cell;
        }
            break;
            //商品信息
        case 1:
        {
            WPNewPushCommodityInformationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:commodityInformationCell forIndexPath:indexPath];
            cell.superView = collectionView;
            cell.indexPath = indexPath;
            [cell getGoodsNameBlockWithBlock:^(NSString *str) {
                _name = str;
            }];
            [cell getDescribeEdtingBlockWithBlock:^(NSString *str, CGFloat height) {
                _describe = str;
                if (describeCellHeight!=height&&height>=200) {
                    describeCellHeight = height;
                }
                [collectionView reloadData];
            }];
            return cell;
        }
            break;
            //商品图片
        case 2:
        {
            WPNewPushImagesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:imagesCell forIndexPath:indexPath];
            cell.images = self.images;
            imagesCellHeight = cell.rowHeight;
            [cell getRowDataWithBlock:^(NSMutableArray *images, NSInteger heightRow) {
                _images = images;
                imagesCellHeight = heightRow;
                [collectionView reloadData];
            }];

            return cell;
        }
            break;
            //选择详情信息
        case 3:case 4:
        {
            
            WPNewPushSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectCell forIndexPath:indexPath];
            cell.superView = collectionView;
            if (indexPath.section == 3) {
                cell.url = CommodityTypeUrl;
                [cell getSelectWithBlock:^(NSString *string, NSString *gcid) {
                    _species = string;
                    _specieid = gcid;
                }];
                
            }else{
                cell.selectDataArray = @[@"全新",@"九成新",@"八成新",@"七成新",@"六成新",@"五成新",@"其他"];
                [cell getSelectWithBlock:^(NSString *string, NSString *gcid) {
                    _newOrOld = string;
                }];
            }
            cell.textField.placeholder = Placeholders[indexPath.section-3];
            cell.title.text = Titles[indexPath.section-3];
            return cell;
        }
            break;
            //输入商品信息
        case 5:case 6:
        {
            WPPushDetailInformationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:detailInformationCell forIndexPath:indexPath];
            cell.data.keyboardType = UIKeyboardTypeDefault;
            if (indexPath.section == 5) {
                cell.data.keyboardType = UIKeyboardTypeDecimalPad;
                [cell getTextFieldDataWithBlock:^(NSString *str) {
                    _price = str;
                }];
            }else{
                [cell getTextFieldDataWithBlock:^(NSString *str) {
                    
                }];
            }
            cell.data.placeholder = Placeholders[indexPath.section-3];
            cell.title.text = Titles[indexPath.section-3];
            cell.superView = collectionView;
            cell.indexPath = indexPath;
            return cell;
        }
            break;
            //选择地址
        case 7:
        {
            WPNewPushAddressSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressCell forIndexPath:indexPath];
            [cell getAddressWithBlock:^(NSInteger adid) {
                _adid = [NSString stringWithFormat:@"%ld",adid];
            }];
            return cell;
        }
            break;
            //造梦故事
        case 8:
        {
            WPNewPushStoreCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:storeCell forIndexPath:indexPath];
            cell.superView = collectionView;
            cell.indexPath = indexPath;
            [cell getStoreBlockWithBlock:^(NSString *str, CGFloat height) {
                _story = str;
                if (storeCellHeight != height&&height>=200) {
                    storeCellHeight = height;
                    [collectionView reloadData];
                }
            }];
            return cell;
        }
            break;
            //造梦条款
        case 9:
        {
            WPNewPushTermsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:termsCell forIndexPath:indexPath];
            return cell;
        }
            break;
    }
    return nil;
}


#pragma mark - 支付
-(void)payFee{
//    if (![self determineWhetherTheDataIntegrity]) {
//        return;
//    }
    __block typeof(self)weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:SignupAddUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        
        NSLog(@" flag ==== %ld",[responseObject[@"flag"] integerValue]);
        NSLog(@" signupid ==== %ld",[responseObject[@"signupid"] integerValue]);
        
        NSInteger signupid = [responseObject[@"signupid"] integerValue];
        WPPayDepositViewController * payvc = [[WPPayDepositViewController alloc]initWithParams:@{@"signupid":@(signupid),@"amount":@(1)} price:1.f aliPayUrl:AliPaySignup];        
        [weakSelf.navigationController pushViewController:payvc animated:YES];
    }];
}
//判断是否有空数据
-(BOOL)determineWhetherTheDataIntegrity{
    if (_name.length!=0&&_describe.length!=0&&_price.length!=0&&_story.length!=0&&_newOrOld.length!=0&&_adid!=nil&&_specieid!=nil) {
        return YES;
    }
    [self showMBProgressHUDWithTitle:@"请输入完整信息"];
    return NO;
}
#pragma mark - 支付通知中心回调
-(void)alipayBack:(NSNotification *)notification{
    NSDictionary *result = notification.object;
    if ([result[@"resultStatus"] integerValue] == 9000) {
        [self showMBProgressHUDWithTitle:@"支付成功"];
        [self upLoadDreamingInformation];
    }
}

#pragma mark - 上传造梦计划申请
//付钱后上传
-(void)upLoadDreamingInformation{
    if ([_price floatValue]<0) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得小于0" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    if ([_price floatValue]>999999) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得大于999999" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    NSDictionary * params = @{@"uid":[self getSelfUid],@"proname":_name,@"gcid":_specieid,@"price":_price,@"remark":_describe,@"neworold":_newOrOld,@"adid":_adid,@"story":_story,@"contents":@"123",@"subid":_subid,@"pubtime":[self getNowTime],@"plantime":[self getNowTime],@"want":@"123"};
    
    __block typeof(self)weakSelf = self;
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

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

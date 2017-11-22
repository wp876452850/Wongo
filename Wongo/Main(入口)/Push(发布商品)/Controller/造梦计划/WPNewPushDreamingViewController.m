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
#import "WPNewPushUserInformationCollectionViewCell.h"
#import "WPNewPushCommodityInformationCollectionViewCell.h"
#import "WPNewPushImagesCollectionViewCell.h"
#import "WPNewPushAddressSelectCollectionViewCell.h"
#import "WPPushDetailInformationCollectionViewCell.h"
#import "WPNewPushSelectCollectionViewCell.h"
#import "WPNewPushStoreCollectionViewCell.h"
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
    //商品名称
    NSString * _name;
    //商品描述
    NSString * _describe;
    //商品新旧程度
    NSString * _newOrOld;
    //商品价格
    NSString * _price;
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
        [_pushButton setTitle:@"开始我的造梦计划" forState:UIControlStateNormal];
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
            return CGSizeMake(WINDOW_WIDTH, 150.f);
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
            
            return cell;
        }
            break;
            //商品信息
        case 1:
        {
            WPNewPushCommodityInformationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:commodityInformationCell forIndexPath:indexPath];
            [cell getGoodsNameBlockWithBlock:^(NSString *str) {
                
            }];
            [cell getDescribeBlockWithBlock:^(NSString *str, CGFloat height) {
                if (describeCellHeight!=height&&height>=200) {
                    describeCellHeight = height;
                    [collectionView reloadData];
                }
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
            //商品详情信息
        case 3:case 4:
        {
            WPNewPushSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectCell forIndexPath:indexPath];
            if (indexPath.section == 3) {
                cell.url = CommodityTypeUrl;
            }else{
                cell.selectDataArray = @[@"全新",@"九成新",@"八成新",@"七成新",@"六成新",@"五成新",@"其他"];
            }
            cell.textField.placeholder = Placeholders[indexPath.section-3];
            cell.title.text = Titles[indexPath.section-3];
            return cell;
        }
            break;
            //选择商品信息
        case 5:case 6:
        {
            WPPushDetailInformationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:detailInformationCell forIndexPath:indexPath];
            if (indexPath.section == 5) {
                [cell getTextFieldDataWithBlock:^(NSString *str) {
                    
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
    if (![self determineWhetherTheDataIntegrity]) {
        return;
    }
    __block typeof(self)weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:SignupAddUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        
        WPPayDepositViewController * payvc = [[WPPayDepositViewController alloc]initWithParams:@{@"signupid":responseObject[@"signupid"],@"amount":@(0.01)} price:1.f aliPayUrl:AliPaySignup];
        [weakSelf.navigationController pushViewController:payvc animated:YES];
    }];
}
//判断是否有空数据
-(BOOL)determineWhetherTheDataIntegrity{
    if (_name.length!=0&&_describe.length!=0&&_price.length!=0&&_story.length!=0&&_newOrOld.length!=0&&_contents.length!=0&&_adid.length!=0) {
    }
    return YES;
}
#pragma mark - 支付通知中心回调
-(void)alipayBack:(NSNotification *)notification{
    NSDictionary *result = notification.object;
    if ([result[@"resultStatus"] integerValue] == 9000) {
        [self upLoadDreamingInformation];
    }
}
#pragma mark - 上传造梦计划申请
//付钱后上传
-(void)upLoadDreamingInformation{
    
}
@end

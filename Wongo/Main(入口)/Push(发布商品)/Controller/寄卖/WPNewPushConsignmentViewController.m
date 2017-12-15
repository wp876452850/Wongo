//
//  WPNewPushConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushConsignmentViewController.h"
//用户信息
#import "WPNewPushUserInformationCollectionViewCell.h"
//图片信息
#import "WPNewPushImagesCollectionViewCell.h"
//商品信息
#import "WPNewPushCommodityInformationCollectionViewCell.h"
//可输入信息框
#import "WPPushDetailInformationCollectionViewCell.h"
//条款条例
#import "WPNewPushTermsCollectionViewCell.h"
//选择框
#import "WPNewPushSelectCollectionViewCell.h"

#define Placeholders @[@"请选择商品种类",@"请选择商品新旧程度",@"请输入商品价值(￥)",@"是否成为寄梦人?"]
#define Titles @[@"请选择您进行造梦的商品所属种类",@"请选择您进行造梦的商品新旧程度",@"请输入您进行造梦的商品预估价值",@"是否同意成为寄梦人?"]

@interface WPNewPushConsignmentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //记录图片组单元格高度
    CGFloat imagesCellHeight;
    //记录描述组单元格高度
    CGFloat describeCellHeight;
    
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

@implementation WPNewPushConsignmentViewController
static NSString * const userInformationCell     = @"userInformationCell";
static NSString * const commodityInformationCell= @"commodityInformationCell";
static NSString * const imagesCell              = @"imagesCell";
static NSString * const detailInformationCell   = @"detailInformationCell";
static NSString * const selectCell              = @"selectCell";

-(UIButton *)pushButton{
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushButton.frame = CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50);
        _pushButton.backgroundColor  = WongoBlueColor;
        [_pushButton setTitle:@"同意条款并申请寄卖" forState:UIControlStateNormal];
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
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:selectCell];
//        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushAddressSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:addressCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPPushDetailInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:detailInformationCell];
        _collectionView.backgroundColor = AllBorderColor;
        imagesCellHeight = 175.f;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"申请平台寄卖";
    self.itemHeights = [NSMutableArray arrayWithCapacity:3];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pushButton];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 4||section == 6) {
        return CGSizeZero;
    }
    return CGSizeMake(WINDOW_WIDTH, 5);
}
//区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
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
//        case 7:
//        {
//            WPNewPushAddressSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressCell forIndexPath:indexPath];
//            [cell getAddressWithBlock:^(NSInteger adid) {
//                _adid = [NSString stringWithFormat:@"%ld",adid];
//            }];
//            return cell;
//        }
//            break;

            //寄卖条款
        case 9:
        {
            
        }
            break;
    }
    return nil;
}
-(BOOL)determineWhetherTheDataIntegrity{
    if (self) {
        return YES;
    }
    [self showMBProgressHUDWithTitle:@"请输入完整信息"];
    return NO;
}

-(void)upLoadConsignmentInformation{
    
}
@end

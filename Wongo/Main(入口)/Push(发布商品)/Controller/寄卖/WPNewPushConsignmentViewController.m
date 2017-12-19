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

#define Placeholders @[@"请输入商品价值(￥)",@"请选择商品种类"]
#define Titles @[@"请输入您进行造梦的商品预估价值",@"请选择您进行造梦的商品所属种类"]

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
//返回按钮
@property (nonatomic,strong)UIButton * leftBarbutton;

@end

@implementation WPNewPushConsignmentViewController
static NSString * const userInformationCell     = @"userInformationCell";
static NSString * const commodityInformationCell= @"commodityInformationCell";
static NSString * const imagesCell              = @"imagesCell";
static NSString * const detailInformationCell   = @"detailInformationCell";
static NSString * const selectCell              = @"selectCell";

-(UIButton *)leftBarbutton{
    if (!_leftBarbutton) {
        _leftBarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBarbutton.frame = CGRectMake(10, 27, 30, 30);
        [_leftBarbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_leftBarbutton addTarget:self action:@selector(w_dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBarbutton;
}
-(UIButton *)pushButton{
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushButton.frame = CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50);
        _pushButton.backgroundColor  = WongoBlueColor;
        [_pushButton setTitle:@"同意条款并申请寄卖" forState:UIControlStateNormal];
        _pushButton.titleLabel.font  = [UIFont systemFontOfSize:15];
        [_pushButton addTarget:self action:@selector(upLoadConsignmentInformation) forControlEvents:UIControlEventTouchUpInside];
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
    [self.myNavBar addSubview:self.leftBarbutton];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pushButton];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 4) {
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
    }
    return CGSizeMake(WINDOW_WIDTH, 150.f);
}
//区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
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
            //输入商品价格
        case 3:
        {
            WPPushDetailInformationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:detailInformationCell forIndexPath:indexPath];
            cell.title.text = Titles[indexPath.section - 3];
            cell.data.placeholder = Placeholders[indexPath.section - 3];
            cell.superView = collectionView;
            cell.indexPath = indexPath;
            cell.data.keyboardType = UIKeyboardTypeDefault;
            if (indexPath.section == 3) {
                cell.data.keyboardType = UIKeyboardTypeDecimalPad;
                [cell getTextFieldDataWithBlock:^(NSString *str) {
                    _price = str;
                }];
            }
            return cell;
        }
            break;
            //选择详情信息
        case 4:
        {
            WPNewPushSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectCell forIndexPath:indexPath];
            cell.superView = collectionView;
            if (indexPath.section == 4) {
                cell.url = CommodityTypeUrl;
                [cell getSelectWithBlock:^(NSString *string, NSString *gcid) {
                    _species = string;
                    _specieid = gcid;
                }];
                
            }
            cell.textField.placeholder = Placeholders[indexPath.section-3];
            cell.title.text = Titles[indexPath.section-3];
            return cell;
        }
            break;
            //寄卖条款
        case 5:
        {
            
        }
            break;
    }
    return nil;
}

-(BOOL)determineWhetherTheDataIntegrity{
    if (_name.length!=0&&_describe.length!=0&&_specieid!=nil&&_price.length!=0) {
        return YES;
    }
    [self showMBProgressHUDWithTitle:@"请输入完整信息"];
    return NO;
}

-(void)upLoadConsignmentInformation{
    __block typeof(self)weakSelf = self;
    if ([_price floatValue]<0) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得小于0" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    if ([_price floatValue]>999999) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得大于999999" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    
    if ([self determineWhetherTheDataIntegrity]) {
        
        NSString * timeStr = [self getNowTime];
        
        NSDictionary * params = @{@"pubtime":timeStr,@"lname":_name,@"remark":_describe,@"gcid":_specieid,@"price":@([_price floatValue]),@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]};
        
        [WPNetWorking createPostRequestMenagerWithUrlString:LogisticsUserAdd params:params datas:^(NSDictionary *responseObject) {
            NSString * flag = [responseObject objectForKey:@"flag"];
            if ([flag integerValue] == 1) {
                //上传图片
                [WPGCD createUpLoadImageGCDWithImages:weakSelf.images urlString:Upfilelog params:@{@"lid":[responseObject objectForKey:@"lid"]}];
                [self showAlertWithAlertTitle:@"上传成功" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"] block:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else{
                [self showAlertWithAlertTitle:@"上传失败" message:nil preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
            }
        }];
    }
}
@end

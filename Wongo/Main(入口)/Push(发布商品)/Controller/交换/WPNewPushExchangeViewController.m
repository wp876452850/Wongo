//
//  WPNewPushExchangeViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/11/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushExchangeViewController.h"
//用户信息
#import "WPNewPushUserInformationCollectionViewCell.h"
//图片信息
#import "WPNewPushImagesCollectionViewCell.h"
//商品信息
#import "WPNewPushCommodityInformationCollectionViewCell.h"
//可输入信息框
#import "WPPushDetailInformationCollectionViewCell.h"
//选择框
#import "WPNewPushSelectCollectionViewCell.h"

#define Placeholders @[@"请输入商品价值(￥)",@"请选择商品种类",@"请选择商品新旧程度",@"库存(件)"]
#define Titles @[@"请输入您进行造梦的商品预估价值",@"请选择您进行造梦的商品所属种类",@"请选择您进行造梦的商品新旧程度",@"请输入您的商品库存量"]
@interface WPNewPushExchangeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
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
    //库存
    NSString * _inventory;
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

@property (nonatomic,strong)UIButton * leftBarbutton;
@end

@implementation WPNewPushExchangeViewController

static NSString * const userInformationCell     = @"userInformationCell";
static NSString * const commodityInformationCell= @"commodityInformationCell";
static NSString * const imagesCell              = @"imagesCell";
static NSString * const detailInformationCell   = @"detailInformationCell";
static NSString * const selectUrlCell  = @"selectUrlCell";
static NSString * const selectArrayCell  = @"selectArrayCell";

//懒加载
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
        [_pushButton setTitle:@"发布交换商品" forState:UIControlStateNormal];
        _pushButton.titleLabel.font  = [UIFont systemFontOfSize:15];
        [_pushButton addTarget:self action:@selector(upLoadExchangeInformation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 114) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushUserInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:userInformationCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushCommodityInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:commodityInformationCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushImagesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imagesCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:selectUrlCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPNewPushSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:selectArrayCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"WPPushDetailInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:detailInformationCell];
        _collectionView.backgroundColor = AllBorderColor;
        imagesCellHeight = 175.f;
    }
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"发布交换商品";
    [self.myNavBar addSubview:self.leftBarbutton];
    self.itemHeights = [NSMutableArray arrayWithCapacity:3];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pushButton];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//返回每个区头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 4||section == 5) {
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
    return 7;
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
        case 3:case 6:
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
            }else{
                [cell getTextFieldDataWithBlock:^(NSString *str) {
                    _inventory = str;
                }];
            }
            
            return cell;
        }
            break;
            //选择详情信息
        case 4:
        {
            
            WPNewPushSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectUrlCell forIndexPath:indexPath];
            cell.superView = collectionView;
            cell.url = CommodityTypeUrl;
            [cell getSelectWithBlock:^(NSString *string, NSString *gcid) {
                _species = string;
                _specieid = gcid;
            }];
            cell.textField.placeholder = Placeholders[indexPath.section-3];
            cell.title.text = Titles[indexPath.section - 3];
            return cell;

        }
            break;
        case 5:{
            WPNewPushSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectArrayCell forIndexPath:indexPath];
            cell.superView = collectionView;
            cell.selectDataArray = @[@"全新",@"九成新",@"八成新",@"七成新",@"六成新",@"五成新",@"其他"];
            [cell getSelectWithBlock:^(NSString *string, NSString *gcid) {
                _newOrOld = string;
            }];
            cell.textField.placeholder = Placeholders[indexPath.section-3];
            cell.title.text = Titles[indexPath.section - 3];
            return cell;
        }break;
            //寄卖条款
        case 7:
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

-(void)upLoadExchangeInformation{
    __block typeof(self)weakSelf = self;
    if ([_price floatValue]<0) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得小于0" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    if ([_price floatValue]>999999) {
        [self showAlertWithAlertTitle:@"提示" message:@"输入的金额不得大于999999" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    
    if (_name.length!=0&&_describe.length!=0&&_specieid!=nil&&_price.length!=0&&_inventory.length!=0&&_newOrOld.length!=0) {
        
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end

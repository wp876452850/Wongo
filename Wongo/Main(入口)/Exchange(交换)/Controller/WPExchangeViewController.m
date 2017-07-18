	//
//  WPExchangeViewController.m
//  Wongo
//
//  Created by rexsu on 2017/3/16.
//  Copyright © 2017年 Winny. All rights reserved.
//  交换

#import "WPExchangeViewController.h"
#import "SDCycleScrollView.h"
#import "WPExchangeDetailModel.h"
#import "WPExchangeCommentsModel.h"
#import "WPExchangeCommentCell.h"
#import "WPUserIntroductionModel.h"
#import "WPUserIntroductionTableViewCell.h"
#import "WPExchangeCommodityInformationCell.h"
#import "WPSelectExchangeGoodsViewController.h"
#import "LoginViewController.h"
#import "WPParameterInformationView.h"
#import "LYConversationController.h"
#import "SDCollectionViewCell.h"

static NSString * const commentCell     = @"CommentCell";
static NSString * const userCell        = @"UserCell";
static NSString * const commodityCell   = @"CommodityCell";

@interface WPExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,SDPhotoBrowserDelegate>
//自动滚播器
@property (nonatomic,strong) SDCycleScrollView      * cycleScrollView;
@property (nonatomic,strong) WPExchangeDetailModel  * exchangeModel;
@property (nonatomic,strong) UITableView            * tableView;
@property (nonatomic,strong) NSString               * urlString;
@property (nonatomic,strong) NSDictionary           * params;
@property (nonatomic,strong) UIButton               * backButton;
@property (nonatomic, assign) BOOL fromOrder;
@end

@implementation WPExchangeViewController

+(instancetype)createExchangeGoodsWithUrlString:(NSString *)url params:(NSDictionary *)params fromOrder:(BOOL)fromOrder{
    WPExchangeViewController * exchangeGoodsVC = [[WPExchangeViewController alloc]init];
    exchangeGoodsVC.urlString                  = url;
    exchangeGoodsVC.params                     = params;
    exchangeGoodsVC.fromOrder                  = fromOrder;
    return exchangeGoodsVC;
}

#pragma mark - lazyLoad
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 40) style:UITableViewStylePlain];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        _tableView.tableHeaderView  = self.cycleScrollView;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommentCell" bundle:nil] forCellReuseIdentifier:commentCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPUserIntroductionTableViewCell" bundle:nil] forCellReuseIdentifier:userCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommodityInformationCell" bundle:nil] forCellReuseIdentifier:commodityCell];
        [self createBottmView];
        //创建按钮
        
    }
    return _tableView;
}

-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RollPlayFrame imageURLStringsGroup:_exchangeModel.rollPlayImages];
        _cycleScrollView.height +=80;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    }
    return _cycleScrollView;
}
//返回按钮
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self navigationLeftPop];
}

-(void)loadDatas{
    __weak WPExchangeViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:self.urlString params:self.params datas:^(NSDictionary *responseObject) {
        
        weakSelf.exchangeModel = [WPExchangeDetailModel mj_objectWithKeyValues:responseObject];
        
        NSArray * images = [responseObject objectForKey:@"listimg"];
        for (int i = 0; i < images.count; i++) {
            NSDictionary * dic = images[i];
            [weakSelf.exchangeModel.rollPlayImages addObject:[dic objectForKey:@"url"]];
        }
        
        //获取用户信息
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":weakSelf.exchangeModel.uid} datas:^(NSDictionary *responseObject) {
        
            weakSelf.exchangeModel.userIntroductionModel = [WPUserIntroductionModel mj_objectWithKeyValues:responseObject];
            [self.view addSubview:self.tableView];
            [self.view addSubview:self.backButton];
        }];
        
        
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1&&_exchangeModel.commentsModelArray.count>0) {
        if (_exchangeModel.commentsModelArray.count>=2) {
            return 3;
        }else{
            return 2;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            WPExchangeCommodityInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:commodityCell forIndexPath:indexPath];
            cell.model = _exchangeModel;
            return cell;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                UITableViewCell * cell      = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"宝贝评价(%ld)",(unsigned long)_exchangeModel.commentsModelArray.count]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(@"宝贝评价".length,attributedString.length-@"宝贝评价".length)];
                cell.textLabel.attributedText   = attributedString;
                cell.textLabel.font             = [UIFont systemFontOfSize:15];
                
                cell.selectionStyle             = UITableViewCellSelectionStyleNone;
                cell.accessoryType              =UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else{
                WPExchangeCommentCell * cell    = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
                cell.model                      = _exchangeModel.commentsModelArray[indexPath.row-1];
                return cell;
            }
            
        }
            break;
        case 2:
        {
            WPUserIntroductionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
            cell.model                              = _exchangeModel.userIntroductionModel;
            return cell;
        }
            break;
        case 3:{
            UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text     = @"产品参数";
            cell.textLabel.font     = [UIFont systemFontOfSize:15];
            cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        }
            break;
        case 5:{
            UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            UITextView * textLabel     = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
            textLabel.text          = @"商品描述:";
            textLabel.font          = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:textLabel];

            
            UITextView * textView   = [[UITextView alloc]initWithFrame:CGRectMake(textLabel.right, 10, WINDOW_WIDTH - textLabel.right, [_exchangeModel.remark getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - textLabel.right, MAXFLOAT)].height+10)];
            textView.text           = _exchangeModel.remark;
            textView.font           = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:textView];
        }
    }
    
    
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 95;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return 30;
            }
            return 80;
            
        }
            break;
        case 2:
        {
            return 90;
        }
            break;
        case 3:
        {
            return 40;
        }
            break;
        case 5:{
            CGFloat rowHeight = [_exchangeModel.remark getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - 80, MAXFLOAT)].height + 10;
            if (rowHeight < 40) {
                return 40;
            }else
            return rowHeight;
        }
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
#warning 产品参数传值
        WPParameterInformationView * vc = [WPParameterInformationView createParameterInformationWithUrlString:nil];
        [self.view addSubview:vc];
    }
}

//创建底部视图
-(void)createBottmView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 40, WINDOW_WIDTH, 40)];
    [self.view addSubview:view];
    view.backgroundColor = WhiteColor;
    if (!_fromOrder) {
        UIButton * exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:exchangeButton];
        [exchangeButton setTitle:@"申请交换" forState:UIControlStateNormal];
        [exchangeButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(120, 35));
        }];
        exchangeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        exchangeButton.backgroundColor = SelfOrangeColor;
        exchangeButton.layer.masksToBounds = YES;
        exchangeButton.layer.cornerRadius  = 15;
        [exchangeButton addTarget:self action:@selector(goExchange) forControlEvents:UIControlEventTouchUpInside];        
    }
    
    
    UIButton * chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:chatBtn];
    [chatBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
    [chatBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 35));
    }];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chatBtn.backgroundColor = SelfOrangeColor;
    chatBtn.layer.masksToBounds = YES;
    chatBtn.layer.cornerRadius  = 15;
    [chatBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
}
//聊天
- (void)chat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.exchangeModel.uid];
        vc.title = self.exchangeModel.userIntroductionModel.uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//去交换
-(void)goExchange{
    if (![self determineCommodityIsMineWithUid:_exchangeModel.uid]) {
        NSString * uid = [[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        
        if (uid.length > 0) {
            WPSelectExchangeGoodsViewController * vc = [[WPSelectExchangeGoodsViewController alloc]initWithGid:_exchangeModel.gid price:_exchangeModel.price];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [self showAlertWithAlertTitle:@"提示" message:@"当前未登录,是否前往登录界面" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"是",@"否"] block:^{
                LoginViewController * vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }else{
        [self showAlertWithAlertTitle:@"提示" message:@"该商品是您发布的商品,无法进行交换" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
}

#pragma mark SDCycleScrollViewDelegate
//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    SDCollectionViewCell * cell = (SDCollectionViewCell *)[cycleScrollView.mainView cellForItemAtIndexPath:indexPath];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 0)];
    browser.currentImageIndex = indexPath.row;
    browser.sourceImagesContainerView = cell.contentView;
    browser.imageCount = _exchangeModel.rollPlayImages.count;
    browser.delegate = self;
    [browser show];

}

#pragma mark - SDPhotoBrowserDelegate
//展示的图片与对应的index
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:_exchangeModel.rollPlayImages[index]];
    return imageView.image;
}
//点击缩小图片至什么位置
- (void)selfView:(UIView *)supperView imageForIndex:(NSInteger)index currentImageView:(UIImageView *)imageview {
    
    NSIndexPath *CellIndexPath = [NSIndexPath indexPathForRow: index inSection:0];
    
    SDCollectionViewCell * cell = (SDCollectionViewCell *)[_cycleScrollView.mainView cellForItemAtIndexPath:CellIndexPath];
    
    //如果cell不存在，从重用池中取出cell
    if (!cell) {
        [_cycleScrollView.mainView scrollToItemAtIndexPath:CellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [_cycleScrollView.mainView layoutIfNeeded];
        cell = (SDCollectionViewCell*)[_cycleScrollView.mainView cellForItemAtIndexPath:CellIndexPath];
    }

    /**图片尺寸大小*/
    CGRect imageFrame = CGRectZero;
    CGFloat scale = (cell.contentView.height/cell.imageView.image.size.height)<(WINDOW_WIDTH/cell.imageView.image.size.width)?(cell.contentView.height/cell.imageView.image.size.height):(WINDOW_WIDTH/cell.imageView.image.size.width);
    imageFrame.size = CGSizeMake(cell.imageView.image.size.width * scale, cell.imageView.image.size.height * scale);
    imageFrame.origin = CGPointMake((WINDOW_WIDTH - imageFrame.size.width)/2, cell.contentView.y);

    
    CGRect targetTemp = [cell.contentView convertRect:imageFrame toView:supperView];
    
    [UIView animateWithDuration:0.4f    animations:^{
        imageview.frame = targetTemp;
        supperView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [supperView removeFromSuperview];
    }];
}

@end

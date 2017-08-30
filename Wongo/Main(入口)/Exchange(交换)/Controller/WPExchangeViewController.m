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
#import "WPExchangeCommodityInformationCell.h"
#import "WPSelectExchangeGoodsViewController.h"
#import "LoginViewController.h"
#import "WPParameterInformationView.h"
#import "LYConversationController.h"
#import "SDCollectionViewCell.h"
#import "WPCommentViewController.h"
#import "WPProductDetailUserStoreTableViewCell.h"
#import "WPCommentsSectionTableViewCell.h"
#import "WPUserIntroductionTableViewCell.h"
#import "WPCommentModel.h"
#import "WPRecommendationView.h"
#import "WPExchangeImageShowTableViewCell.h"

static NSString * const userCell            = @"UserCell";
static NSString * const commodityCell       = @"CommodityCell";
static NSString * const commentsSectionCell = @"WPCommentsSectionTableViewCell";
static NSString * const imageShowCell       = @"ImageShowCell";

@interface WPExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,SDPhotoBrowserDelegate,WPRecommendationViewDelegate>

//自动滚播器
@property (nonatomic,strong) SDCycleScrollView      * cycleScrollView;
@property (nonatomic,strong) WPExchangeDetailModel  * exchangeModel;
@property (nonatomic,strong) UITableView            * tableView;
@property (nonatomic,strong) NSString               * urlString;
@property (nonatomic,strong) NSDictionary           * params;
@property (nonatomic,strong) UIButton               * backButton;
@property (nonatomic,assign) BOOL fromOrder;
@property (nonatomic,assign) CGFloat userStoreRowHeight;
@property (nonatomic,strong) WPRecommendationView * recommendationView;
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
-(WPRecommendationView *)recommendationView{
    if (!_recommendationView) {
        _recommendationView = [[WPRecommendationView alloc]initWithFrame:CGRectMake(0,self.tableView.bottom , WINDOW_WIDTH, self.tableView.height) dataSourceArray:nil];
        _recommendationView.delegate = self;
    }
    return _recommendationView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 50) style:UITableViewStylePlain];
        _tableView.backgroundColor  = ColorWithRGB(246, 246, 246);
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPCommentsSectionTableViewCell" bundle:nil] forCellReuseIdentifier:commentsSectionCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPProductDetailUserStoreTableViewCell" bundle:nil] forCellReuseIdentifier:userCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommodityInformationCell" bundle:nil] forCellReuseIdentifier:commodityCell];
        [_tableView registerClass:[WPExchangeImageShowTableViewCell class] forCellReuseIdentifier:imageShowCell];
        
        //创建按钮        
    }
    return _tableView;
}

-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:_exchangeModel.rollPlayImages];
        _cycleScrollView.currentPageDotColor = ColorWithRGB(45, 102, 139);
        _cycleScrollView.pageDotColor = ColorWithRGB(45, 102, 139);
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
        //weakSelf.exchangeModel.parameters         = [NSMutableArray arrayWithObjects:@"流行款式:其它",@"质地:UP",@"适用对象:青年",@"背包:斜挎式",@"风格:摇滚",@"成色:全新",@"颜色:黑",@"软硬:软",@"闭合方式:拉链",@"运费:很贵", nil];
        weakSelf.exchangeModel.parameters = [NSMutableArray arrayWithObject:@"本产品无参数"];
        NSArray * images = [responseObject objectForKey:@"listimg"];
        for (int i = 0; i < images.count; i++) {
            NSDictionary * dic = images[i];
            [weakSelf.exchangeModel.rollPlayImages addObject:[dic objectForKey:@"url"]];
        }
        
        //获取用户信息
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":weakSelf.exchangeModel.uid} datas:^(NSDictionary *responseObject) {
        
            weakSelf.exchangeModel.userIntroductionModel = [WPUserIntroductionModel mj_objectWithKeyValues:responseObject];
            [weakSelf.view addSubview:weakSelf.tableView];
            weakSelf.tableView.tableHeaderView = weakSelf.cycleScrollView;
            [weakSelf.view addSubview:weakSelf.backButton];
        }];
#pragma mark - 查询评论
        __block WPExchangeViewController * weakSelf = self;
        [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCommentUrl params:@{@"gid":_exchangeModel.gid} datas:^(NSDictionary *responseObject) {
            NSArray * list = responseObject[@"list"];
            for (int i = 0; i<list.count; i++) {
                WPCommentModel * model = [WPCommentModel mj_objectWithKeyValues:list[i]];
                [weakSelf.exchangeModel.commentsModelArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            
        }];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
//返回多少区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            WPExchangeCommodityInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:commodityCell forIndexPath:indexPath];
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            cell.model = _exchangeModel;
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell * cell      = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  宝贝评价(%ld)",(unsigned long)_exchangeModel.commentsModelArray.count]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(@"  宝贝评价".length,attributedString.length - @"  宝贝评价".length)];
            cell.textLabel.attributedText   = attributedString;
            cell.textLabel.font             = [UIFont systemFontOfSize:17];
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            cell.accessoryType              =UITableViewCellAccessoryDisclosureIndicator;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 1:
        {
            WPProductDetailUserStoreTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];

            cell.model = _exchangeModel.userIntroductionModel;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;

        case 3:{
            WPCommentsSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commentsSectionCell forIndexPath:indexPath];
            cell.model = self.exchangeModel;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 4:{
            //标签：商品描述
            UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            UITextView * textLabel     = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
            textLabel.text          = @"商品描述:";
            textLabel.font          = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:textLabel];
            //描述内容
            UITextView * textView   = [[UITextView alloc]initWithFrame:CGRectMake(textLabel.right, 10, WINDOW_WIDTH - textLabel.right, [_exchangeModel.remark getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - textLabel.right, MAXFLOAT)].height+10)];
            textView.text           = _exchangeModel.remark;
            textView.font           = [UIFont systemFontOfSize:15];
            textLabel.userInteractionEnabled    = NO;
            textView.userInteractionEnabled     = NO;
            [cell.contentView addSubview:textView];
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 5:{
            UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
    WPExchangeImageShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:imageShowCell forIndexPath:indexPath];
    cell.images = self.exchangeModel.rollPlayImages;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 115;
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
        case 1:
        {
            return 109;
        }
            break;
        case 3:
        {
            return 170;
        }
            break;
        case 4:{
            CGFloat rowHeight = [_exchangeModel.remark getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - 80, MAXFLOAT)].height + 40;
            if (rowHeight < 40) {
                return 40;
            }else
            return rowHeight;
        }
            break;
        case 5:{
            return 40;
        }
            break;
    }
    
    return (WINDOW_WIDTH+40)*self.exchangeModel.rollPlayImages.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //评论
    if (indexPath.section == 2) {
        if (_exchangeModel.commentsModelArray.count<=0) {
            [self showAlertWithAlertTitle:@"提示" message:@"当前商品暂无评论,是否进行评论" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
            //跳转评论界面
                WPCommentViewController * vc = [[WPCommentViewController alloc]initWithModel:_exchangeModel];
                [self.navigationController pushViewController:vc animated:YES];
                [vc.commentKeyBoard keyboardUpforComment];
            }];
        }else{
            //跳转评论展示界面
            WPCommentViewController * vc = [[WPCommentViewController alloc]initWithModel:_exchangeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3||section == 4) {
        return 10;
    }
    return 0;
}

#pragma mark - 展示底部视图样式
-(void)showExchangeBottomView{
    self.tableView.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 50);
    [self.view addSubview:self.bottomView];
    UIButton * chat             = [self createChatButton];
    UIButton * exchangeButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeButton.frame        = CGRectMake(chat.width, 0, WINDOW_WIDTH-chat.width, 50);
    exchangeButton.backgroundColor = ColorWithRGB(105, 152, 192);
    [exchangeButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [exchangeButton setTitle:@"申请交换" forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:exchangeButton];
}

-(void)showShoppingBottomView{
    self.tableView.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 50);
    
    [self.view addSubview:self.bottomView];
    UIButton * chat = [self createChatButton];
    //加入购物车
    //    UIButton * shoppingCar      = [UIButton buttonWithType:UIButtonTypeCustom];
    //    shoppingCar.frame           = CGRectMake(chat.width, 0, (WINDOW_WIDTH - chat.width)/2, 50);
    //    shoppingCar.backgroundColor = ColorWithRGB(45, 102, 139);
    //    [shoppingCar setTitleColor:WhiteColor forState:UIControlStateNormal];
    //    [shoppingCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    //    [shoppingCar addTarget:self action:@selector(shoppingCar) forControlEvents:UIControlEventTouchUpInside];
    //    [self.bottomView addSubview:shoppingCar];
    
    //立即购买
    UIButton * buy      = [UIButton buttonWithType:UIButtonTypeCustom];
    buy.frame           = CGRectMake(chat.right, 0, (WINDOW_WIDTH - chat.width), 50);
    buy.backgroundColor = ColorWithRGB(105, 152, 192);
    [buy setTitleColor:WhiteColor forState:UIControlStateNormal];
    [buy setTitle:@"立即购买" forState:UIControlStateNormal];
    [buy addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:buy];
}

-(UIButton *)createChatButton{
    UIButton * chat = [UIButton buttonWithType:UIButtonTypeCustom];
    chat.frame = CGRectMake(0, 0, 50, 50);
    chat.backgroundColor = ColorWithRGB(45, 102, 139);
    [chat addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chat];
    [chat setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    return chat;
}

-(void)goChat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.exchangeModel.uid];
        vc.title = self.exchangeModel.userIntroductionModel.uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)buy{
    
}
-(void)shoppingCar{
    
}//去交换
-(void)exchange{
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
    imageFrame.origin = CGPointMake((WINDOW_WIDTH - imageFrame.size.width)/2, (cell.contentView.height - imageFrame.size.height)/2);

    CGRect targetTemp = [cell.contentView convertRect:imageFrame toView:supperView];
    
    [UIView animateWithDuration:0.4f    animations:^{
        imageview.frame = targetTemp;
        supperView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [supperView removeFromSuperview];
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%.2f",self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y >= 319) {
        
        //self.tableView.y = self.tableView.contentOffset.y - 319;
        //self.recommendationView.y = self.tableView.bottom;
    }
}
-(void)didSrollWithCollectionView:(UICollectionView *)collectionView{
    
}


@end

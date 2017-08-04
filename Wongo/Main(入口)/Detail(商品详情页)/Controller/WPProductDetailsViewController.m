//
//  WPProductDetailsViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/8/1.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPProductDetailsViewController.h"
#import "WPExchangeDetailModel.h"
#import "LYConversationController.h"
#import "WPProductDetailUserStoreTableViewCell.h"
#import "SDCollectionViewCell.h"
#import "WPExchangeCommodityInformationCell.h"
#import "WPCommentsSectionTableViewCell.h"


@interface WPProductDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,SDPhotoBrowserDelegate>
@property (nonatomic,strong)NSString * gid;
@property (nonatomic,strong)SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong)WPExchangeDetailModel * exchangeModel;
@property (nonatomic,assign)CGFloat userStoreRowHeight;

@end

@implementation WPProductDetailsViewController
static NSString * const commentCell     = @"CommentCell";
static NSString * const userCell        = @"UserCell";
static NSString * const commodityCell   = @"CommodityCell";
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 50)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:self.exchangeModel.rollPlayImages];
        _cycleScrollView.pageDotColor               = [UIColor blackColor];
        _cycleScrollView.currentPageDotColor        = ColorWithRGB(45, 102, 139);
        _cycleScrollView.pageControlStyle           = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _cycleScrollView.delegate                   = self;
        _cycleScrollView.autoScroll                 = NO;
    }
    return _cycleScrollView;
}
+(instancetype)productDetailsViewControllerWithGid:(NSString *)gid{
    WPProductDetailsViewController * productDetailsViewController = [[WPProductDetailsViewController alloc]init];
    productDetailsViewController.gid = gid;
    [productDetailsViewController loadData];
    [productDetailsViewController.selfNavBar removeFromSuperview];
    [productDetailsViewController setUpTableView];
    return productDetailsViewController;
}

-(void)loadData{
    __block WPProductDetailsViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":self.gid} datas:^(NSDictionary *responseObject) {
         weakSelf.exchangeModel = [WPExchangeDetailModel mj_objectWithKeyValues:responseObject];
        NSArray * images = [responseObject objectForKey:@"listimg"];
        for (int i = 0; i < images.count; i++) {
            NSDictionary * dic = images[i];
            [weakSelf.exchangeModel.rollPlayImages addObject:[dic objectForKey:@"url"]];
        }
        weakSelf.tableView.tableHeaderView  = weakSelf.cycleScrollView;
        //获取用户信息
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":weakSelf.exchangeModel.uid} datas:^(NSDictionary *responseObject) {
            weakSelf.exchangeModel.userIntroductionModel = [WPUserIntroductionModel mj_objectWithKeyValues:responseObject];
            
            [self.tableView reloadData];
        }];
    } failureBlock:^{
        
    }];
}

-(void)setUpTableView{
    [self.view addSubview:self.tableView];
    self.tableView.frame            = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPCommentsSectionTableViewCell" bundle:nil] forCellReuseIdentifier:commentCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPProductDetailUserStoreTableViewCell" bundle:nil] forCellReuseIdentifier:userCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommodityInformationCell" bundle:nil] forCellReuseIdentifier:commodityCell];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - TableViewDelegat&&TableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }
        return self.userStoreRowHeight;
    }
    else if (indexPath.section == 1){
        return 150;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                WPExchangeCommodityInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:commodityCell forIndexPath:indexPath];
                [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
                cell.model = _exchangeModel;
                return cell;
            }
            WPProductDetailUserStoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];            
            [cell getRowHeightWithBlock:^(CGFloat rowheight) {
                self.userStoreRowHeight = rowheight;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.model = self.exchangeModel.userIntroductionModel;
            return cell;
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                WPCommentsSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
                cell.model = self.exchangeModel;
                return cell;
            }
        }
            break;
            
        default:{
            
        }
            break;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
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
    return chat;
}

-(void)goChat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.exchangeModel.uid];
        vc.title = self.exchangeModel.userIntroductionModel.uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)exchange{
    
}
-(void)buy{
    
}
-(void)shoppingCar{
    
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


@end

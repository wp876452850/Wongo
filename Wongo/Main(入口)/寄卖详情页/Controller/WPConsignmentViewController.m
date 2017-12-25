//
//  WPConsignmentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/12/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentViewController.h"
#import "SDCycleScrollView.h"
#import "WPExchangeDetailModel.h"
#import "WPConsignmentDetailInformationTableViewCell.h"
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
#import "WPExchangeFunctionMenu.h"
#import "WPGoodsRecommendedTableViewCell.h"
#import "LYHomeResponse.h"
#import "LYActivityController.h"
#import "WPReportBox.h"
#import "WPDreamingDetailRecommendTableViewCell.h"

#define RecommendCellHeight (WINDOW_WIDTH*0.5+65)
static NSString * const userCell            = @"UserCell";
static NSString * const commodityCell       = @"CommodityCell";
static NSString * const commentsSectionCell = @"WPCommentsSectionTableViewCell";
static NSString * const imageShowCell       = @"ImageShowCell";
static NSString * const goodsRecommended    = @"GoodsRecommended";
static NSString * const recommendCell       = @"recommendCell";

@interface WPConsignmentViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,SDPhotoBrowserDelegate,WPRecommendationViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * bottomView;
//活动数据模型
@property (nonatomic, strong) LYHomeResponse *response;
//自动滚播器
@property (nonatomic,strong) SDCycleScrollView      * cycleScrollView;
@property (nonatomic,strong) WPExchangeDetailModel  * exchangeModel;

@property (nonatomic,strong) NSString               * urlString;
@property (nonatomic,strong) NSDictionary           * params;
@property (nonatomic,strong) UIButton               * backButton;
@property (nonatomic,assign) BOOL fromOrder;
@property (nonatomic,assign) CGFloat userStoreRowHeight;
@property (nonatomic,strong) WPRecommendationView * recommendationView;
//右侧功能按钮
@property (nonatomic,strong) UIButton * functionButton;
@property (nonatomic,strong) NSMutableArray * goodsRecommendDatas;

@end

@implementation WPConsignmentViewController


-(UIButton *)functionButton{
    if (!_functionButton) {
        _functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _functionButton.size = _backButton.size;
        _functionButton.right = WINDOW_WIDTH - _backButton.left;
        _functionButton.y = _backButton.y;
        _functionButton.backgroundColor = [UIColor blackColor];
        [_functionButton setTitle:@"···" forState:UIControlStateNormal];
        
        _functionButton.layer.masksToBounds = YES;
        _functionButton.layer.cornerRadius = _functionButton.width/2;
        _functionButton.alpha = 0.4f;
        [_functionButton addTarget:self action:@selector(clickfunctionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _functionButton;
}
-(void)clickfunctionButton{
    [self clickfunctionButtonWithGid:self.params[@"gid"]];
}

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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor  = ColorWithRGB(246, 246, 246);
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPCommentsSectionTableViewCell" bundle:nil] forCellReuseIdentifier:commentsSectionCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPProductDetailUserStoreTableViewCell" bundle:nil] forCellReuseIdentifier:userCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPExchangeCommodityInformationCell" bundle:nil] forCellReuseIdentifier:commodityCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPGoodsRecommendedTableViewCell" bundle:nil] forCellReuseIdentifier:goodsRecommended];
        [_tableView registerClass:[WPExchangeImageShowTableViewCell class] forCellReuseIdentifier:imageShowCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDetailRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:recommendCell];
        
        //创建按钮
    }
    return _tableView;
}

-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:_exchangeModel.rollPlayImages];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadimage"];
        _cycleScrollView.currentPageDotColor = ColorWithRGB(45, 102, 139);
        _cycleScrollView.pageDotColor = ColorWithRGB(45, 102, 139);
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView * goodsimageshadow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goodsimageshadow"]];
        goodsimageshadow.frame = CGRectMake(0, _cycleScrollView.bottom-19, WINDOW_WIDTH, 19);
        [self.tableView addSubview:goodsimageshadow];
    }
    return _cycleScrollView;
}
//返回按钮
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self navigationLeftPop];
    [self showShoppingBottomView];
}

-(void)loadDatas{
    __weak typeof(self) weakSelf = self;
    

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
//返回多少区

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 6) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            WPConsignmentDetailInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commodityCell forIndexPath:indexPath];
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            
            return cell;
        }
            break;
        case 1:{
            WPDreamingDetailRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:recommendCell forIndexPath:indexPath];
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
            
        case 2:
        {
            WPProductDetailUserStoreTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
            cell.model = _exchangeModel.userIntroductionModel;
            
            return cell;
        }
            break;
            
        case 3:
        {
            UITableViewCell * cell      = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  宝贝评价(%ld)",(unsigned long)_exchangeModel.commentsModelArray.count]];
//            [attributedString addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(@"  宝贝评价".length,attributedString.length - @"  宝贝评价".length)];
//            cell.textLabel.attributedText   = attributedString;
//            cell.textLabel.font             = [UIFont systemFontOfSize:14.f];
//            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
//            cell.accessoryType              =UITableViewCellAccessoryDisclosureIndicator;
//            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
//            return cell;
        }
            break;

        case 4:{
            //标签：商品描述
            UITableViewCell * cell  = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView removeAllSubviews];
                [cell.layer removeFromSuperlayer];
                UITextView * textLabel     = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
                textLabel.text          = @"商品描述:";
                textLabel.font          = [UIFont systemFontOfSize:13.f];
                [cell.contentView addSubview:textLabel];
                
                //描述内容
                UITextView * textView   = [[UITextView alloc]initWithFrame:CGRectMake(textLabel.right, 10, WINDOW_WIDTH - textLabel.right, [_exchangeModel.remark getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - textLabel.right, MAXFLOAT)].height+10)];
//                textView.text           = _exchangeModel.remark;
                textView.font           = [UIFont systemFontOfSize:13.f];
                textLabel.userInteractionEnabled    = NO;
                textView.userInteractionEnabled     = NO;
                [cell.contentView addSubview:textView];
                [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            }
            return cell;
        }
            break;
        case 5:{
            WPExchangeImageShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:imageShowCell forIndexPath:indexPath];
            [cell.contentView removeAllSubviews];
//            cell.images = self.exchangeModel.rollPlayImages;
            return cell;
        }break;
    }
    WPGoodsRecommendedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsRecommended forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.dataSouceArray = _goodsRecommendDatas;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 115;
        }
            break;
        case 1:{
            return (WINDOW_WIDTH - 80)/3+20;
        }
            break;
        case 2:
        {
            return 109;
        }
            break;
        case 3:
        {
            return 50;
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

            break;
        case 5:{
            return (WINDOW_WIDTH+10)*self.exchangeModel.rollPlayImages.count;
        }
            break;
    }
    return RecommendCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //评论
    if (indexPath.section == 3) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return 10;
    }
    if (section == 6) {
        return 30;
    }
    return 0.01f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 6) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 30)];
        label.text = @"推荐商品";
        label.backgroundColor = WhiteColor;
        label.textColor = ColorWithRGB(100, 100, 100);
        label.font = [UIFont systemFontOfSize:19.f];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}

#pragma mark - 展示底部视图样式

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

-(void)didSrollWithCollectionView:(UICollectionView *)collectionView{
    
    
}
@end

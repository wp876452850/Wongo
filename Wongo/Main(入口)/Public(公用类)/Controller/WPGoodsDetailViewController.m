//
//  WPGoodsDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2017/4/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPGoodsDetailViewController.h"
#import "SDCycleScrollView.h"
#import "WPExchangeDetailModel.h"
#import "WPExchangeCommentsModel.h"
#import "WPExchangeCommentCell.h"
#import "WPUserIntroductionModel.h"
#import "WPUserIntroductionTableViewCell.h"
#import "WPExchangeCommodityInformationCell.h"
#import "WPSelectExchangeGoodsViewController.h"
#import "WPParameterInformationView.h"
#import "LoginViewController.h"
#import "SDCollectionViewCell.h"



static NSString * const commentCell     = @"CommentCell";
static NSString * const userCell        = @"UserCell";
static NSString * const commodityCell   = @"CommodityCell";

@interface WPGoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,SDPhotoBrowserDelegate>
//自动滚播器
@property (nonatomic,strong) SDCycleScrollView      * cycleScrollView;
@property (nonatomic,strong) WPExchangeDetailModel  * exchangeModel;
@property (nonatomic,strong) UITableView            * tableView;
@property (nonatomic,strong) NSDictionary           * params;
@property (nonatomic,strong) NSString               * gid;
@property (nonatomic,strong) UIButton               * backButton;
@end

@implementation WPGoodsDetailViewController
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backButton;
}
-(instancetype)initWithGid:(NSString *)gid{
    if (self = [super init]) {
        self.gid = gid;
    }
    return self;
}

#pragma mark - lazyLoad
-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT) style:UITableViewStylePlain];
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
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadimage"];
        _cycleScrollView.height +=80;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    }
    return _cycleScrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self navigationLeftPop];
}

-(void)loadDatas{
    __weak WPGoodsDetailViewController * weakSelf = self;
    if (!_gid) {
        return;
    }
    [WPNetWorking createPostRequestMenagerWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_gid} datas:^(NSDictionary *responseObject) {
        _exchangeModel = [WPExchangeDetailModel mj_objectWithKeyValues:responseObject];
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
    return 5;
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
        case 1:
        {
            UITableViewCell * cell      = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"     宝贝评价(%ld)",(unsigned long)_exchangeModel.commentsModelArray.count]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(@"     宝贝评价".length,attributedString.length-@"     宝贝评价".length)];
            
            cell.textLabel.attributedText   = attributedString;
            cell.textLabel.font             = [UIFont systemFontOfSize:17];
            
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            cell.accessoryType              =UITableViewCellAccessoryDisclosureIndicator;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
        case 2:
        {
            WPUserIntroductionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
            cell.model                              = _exchangeModel.userIntroductionModel;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
            break;
            
        case 3:{
            UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text     = @"产品参数";
            cell.textLabel.font     = [UIFont systemFontOfSize:15];
            cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
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
        }
    }
    
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RandomColor;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 115;
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
        case 2:
        {
            return 100;
        }
            break;
        case 3:
        {
            return 40;
        }
            break;
        case 4:{
            CGFloat rowHeight = [_exchangeModel.remark getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH - 80, MAXFLOAT)].height + 40;
            if (rowHeight < 40) {
                return 40;
            }else
                return rowHeight;
        }
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //评论
    if (indexPath.section == 1) {
        if (_exchangeModel.commentsModelArray.count<=0) {
            [self showAlertWithAlertTitle:@"提示" message:@"当前商品暂无评论,是否进行评论" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
                //跳转评论界面
                
            }];
        }else{
            //跳转评论展示界面
        }
    }
    if (indexPath.section == 3) {
#warning 产品参数传值
        WPParameterInformationView * vc = [WPParameterInformationView createParameterInformationWithUrlString:nil];
        [self.view addSubview:vc];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3||section == 4) {
        return 20;
    }
    return 0;
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

-(void)createBottmView{

   
}

@end

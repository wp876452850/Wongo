//
//  WPNewHomeDreamingCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewHomeDreamingCollectionViewCell.h"
#import "WPNewHomeDreamingPhotoModel.h"
#import "WPHomeDreamingPhotoCollectionViewCell.h"
#import "WPDreamingDetailViewController.h"
#import "LYBaseController.h"

@interface WPNewHomeDreamingCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (nonatomic,strong)UICollectionView * collection;
@end

@implementation WPNewHomeDreamingCollectionViewCell

-(UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _backImage.bottom + 10, WINDOW_WIDTH, (WINDOW_WIDTH/3) + 90) collectionViewLayout:layout];
        _collection.backgroundColor = WhiteColor;
        [_collection registerNib:[UINib nibWithNibName:@"WPHomeDreamingPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WPHomeDreamingPhotoCollectionViewCell"];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = WhiteColor;
        _collection.scrollEnabled = NO;
        _collection.userInteractionEnabled = YES;
    }
    return _collection;;
}

- (IBAction)sender:(id)sender {
    LYBaseController * vc = [[LYBaseController alloc]init];
    vc.myNavItem.title = @"教程";
    UIScrollView * sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    
    UIImage * image = [UIImage imageNamed:@"jiaocheng.jpg"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, WINDOW_WIDTH, image.size.height/2*WINDOW_WIDTH/375);
    sv.contentSize = imageView.size;
    [vc.view addSubview:sv];
    [sv addSubview:imageView];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];;
    return;

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.category.layer.borderWidth = 1.f;
//    self.category.layer.borderColor = ColorWithRGB(255,255, 255).CGColor;
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.collection];
}

-(void)setModel:(WPDreamingModel *)model{
    _model = model;
    self.title.text = [NSString stringWithFormat:@"造梦物品:%@",@"手机"];
    self.category.text = model.proname;
    [self.collection reloadData];
    //[self drowLine];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.introduceModel.dreamingIntroduces.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WPHomeDreamingPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPHomeDreamingPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.model =  [WPNewHomeDreamingPhotoModel mj_objectWithKeyValues:_model.introduceModel.dreamingIntroduces[indexPath.row]];
    if (indexPath.row == 0) {
        cell.lunci.text = @"寄梦人";
    }
    else{
        cell.lunci.text = [NSString stringWithFormat:@"第%ld轮",indexPath.row];
        if (indexPath.row < _model.introduceModel.dreamingIntroduces.count-1) {
            cell.state.text = @"造梦完成";
        }else{
            cell.state.text = @"进行中";
        }
    }
    return cell;
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//每个单元格返回的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake((WINDOW_WIDTH/3), (WINDOW_WIDTH/3) + 90);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:_model.proid plid:_model.plid];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:_model.proid plid:_model.plid];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)drowLine{
    [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_category.left+5, _category.top) moveForPoint:CGPointMake(_category.right+5, _category.top) lineColor:WhiteColor]];
    
    [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_category.right+5, _category.top) moveForPoint:CGPointMake(_category.right+5, _category.bottom) lineColor:WhiteColor]];
    
    [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_category.left+5, _category.bottom) moveForPoint:CGPointMake(_category.right+5, _category.bottom) lineColor:WhiteColor]];
    
    [self.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(_category.left+5, _category.top) moveForPoint:CGPointMake(_category.left+5, _category.bottom) lineColor:WhiteColor]];
}
@end

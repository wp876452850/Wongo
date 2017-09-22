//
//  WPDreamingIntroduceTableViewCell.m
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情-物品介绍-文字内容

#import "WPDreamingIntroduceTableViewCell.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#define Window_Width [UIScreen mainScreen].bounds.size.width
#define ImageWidth (Window_Width-70)/4

@interface WPDreamingIntroduceTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *pushTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduce;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * images;

@end
@implementation WPDreamingIntroduceTableViewCell

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 80);
        //设置横向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置最小行间距
        layout.minimumLineSpacing = 10.f;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, _userName.bottom+20, WINDOW_WIDTH-20, 80) collectionViewLayout:layout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius  = 25.f;
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Window_Width - 20, Window_Width-20));
        make.top.mas_equalTo(_goodsIntroduce.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(10);
    }];
    self.images = [NSMutableArray arrayWithCapacity:3];
    [self.contentView addSubview:self.collectionView];
}

-(void)setModel:(WPDreamingIntroduceImageModel *)model{
    _model = model;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _userName.text = _model.uname;
    _goodsIntroduce.text = _model.remark;
    _images = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i<_model.listimg.count; i++) {
        [_images addObject:_model.listimg[i][@"proimg"]];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

-(void)setImages:(NSMutableArray *)images{
    _images = images;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    UIImageView * image = [[UIImageView alloc]initWithFrame:cell.contentView.frame];
    image.backgroundColor = RandomColor;
    [image sd_setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    [cell addSubview:image];
    image.layer.borderWidth = 0.5f;
    image.layer.borderColor = WongoGrayColor.CGColor;
    return cell;
}
@end

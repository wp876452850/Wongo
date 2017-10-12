//
//  WPNewDreamingSignUpTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/10.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewDreamingSignUpTableViewCell.h"
#import "WPDreamingDetailViewController.h"
#import "WPDreamingDirectoryModel.h"

#define ImageWidth (WINDOW_WIDTH / 2 - 7.5)

@interface WPNewDreamingSignUpTableViewCell (){
    WPNewDreamingSignUpTableViewCellClose _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (nonatomic,strong)UIView * imagebg;

@property (nonatomic,strong)NSMutableArray * images;
@end
@implementation WPNewDreamingSignUpTableViewCell
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:3];
    }
    return _images;
}
-(UIView *)imagebg{
    if (!_imagebg) {
        _imagebg = [[UIView alloc]initWithFrame:CGRectMake(0, _instructions.bottom, WINDOW_WIDTH,0)];
        [self.contentView addSubview:_imagebg];
    }
    return _imagebg;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    _imagebg.height = 0;
    [self.imagebg removeAllSubviews];
    
    
    for (int i = 0; i<_dataSource.count; i++) {
        WPDreamingDirectoryModel * model = [WPDreamingDirectoryModel mj_objectWithKeyValues:_dataSource[i]];
        UIImageView * imageView = [[UIImageView alloc]init];
        if (!_isongoing) {
            imageView.frame = CGRectMake(i%2*ImageWidth+5*(i%2+1), i/2*ImageWidth+5*(i/2+1), ImageWidth, ImageWidth);
        }else{
            imageView.frame = CGRectMake(0, 5, WINDOW_WIDTH, WINDOW_WIDTH);
        }
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10.0f;
        [self.imagebg addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.prourl] placeholderImage:[UIImage imageNamed:@"loadimage"]];
        self.title.text = model.contents;
        _imagebg.height = imageView.bottom;
    }
    
}

-(void)tap:(UITapGestureRecognizer *)tap{
    WPDreamingDirectoryModel * model  = [WPDreamingDirectoryModel mj_objectWithKeyValues:self.dataSource[tap.view.tag]];
    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:model.proid plid:model.plid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
 
- (IBAction)close:(UIButton *)sender {
    if (_block) {
        _block();
    }
}

-(void)closeWithBlock:(WPNewDreamingSignUpTableViewCellClose)block{
    _block = block;
}
@end

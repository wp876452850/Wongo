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
@property (weak, nonatomic) IBOutlet UILabel *browseNumber;
@property (weak, nonatomic) IBOutlet UITextView *instructions;

@property (nonatomic,strong)NSMutableArray * images;
@end
@implementation WPNewDreamingSignUpTableViewCell
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:3];
    }
    return _images;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    for (int i = 0; i<4; i++) {
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%2*ImageWidth+5*(i%2+1), i/2*ImageWidth+5*(i/2+1)+_instructions.bottom, ImageWidth, ImageWidth)];
//        imageView.userInteractionEnabled = YES;
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 10.0f;
//        [self.contentView addSubview:imageView];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        [imageView addGestureRecognizer:tap];
//        [_images addObject:imageView];
//    }
    
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    
    _dataSource = dataSource;
    for (int i = 0; i<_dataSource.count; i++) {
        WPDreamingDirectoryModel * model = [WPDreamingDirectoryModel mj_objectWithKeyValues:_dataSource[i]];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%2*ImageWidth+5*(i%2+1), i/2*ImageWidth+5*(i/2+1)+_instructions.bottom, ImageWidth, ImageWidth)];
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
        self.title.text = model.contents;
    }
}

-(void)tap:(UITapGestureRecognizer *)tap{
    
    WPDreamingDirectoryModel * model  = self.dataSource[tap.view.tag];
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

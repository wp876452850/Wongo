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

@interface WPNewDreamingSignUpTableViewCell ()
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
    for (int i = 0; i<4; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%2*ImageWidth+5*(i%2+1), i/2*ImageWidth+5*(i/2+1)+_instructions.bottom, ImageWidth, ImageWidth)];
        imageView.backgroundColor = WongoBlueColor;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        [_images addObject:imageView];
    }
    
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    for (int i = 0; i<_dataSource.count; i++) {
        WPDreamingDirectoryModel * model = _dataSource[i];
        UIImageView * image = _images[i];
        [image sd_setImageWithURL:[NSURL URLWithString:model.prourl] placeholderImage:nil];
    }
}

-(void)tap:(UITapGestureRecognizer *)tap{
    
    WPDreamingDirectoryModel * model  = self.dataSource[tap.view.tag];
    WPDreamingDetailViewController *vc = [WPDreamingDetailViewController createDreamingDetailWithPlid:model.plid subid:model.subid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

- (IBAction)close:(UIButton *)sender {
    
    
    
}

@end

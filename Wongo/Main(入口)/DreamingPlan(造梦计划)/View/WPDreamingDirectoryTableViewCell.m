//
//  WPDreamingDirectoryTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/5/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDirectoryTableViewCell.h"

@interface WPDreamingDirectoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *dreamingName;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end
@implementation WPDreamingDirectoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(- 5);
//        make.top.mas_equalTo(_dreamingName.mas_bottom).mas_offset(20);
//        make.height.mas_equalTo(20);
//    }];
//    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5);
//        make.top.mas_equalTo(_dreamingName.mas_bottom).mas_offset(20);
//        make.height.mas_equalTo(20);
//    }];
}

-(void)setModel:(WPDreamingDirectoryModel *)model
{
    _model = model;
    NSLog(@"model.pri%@",model.prourl);
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.prourl]];
    self.dreamingName.text  = model.contents;
    self.leftLabel.text     = model.story;
//    self.rightLabel.text    = model.subject;
}

@end

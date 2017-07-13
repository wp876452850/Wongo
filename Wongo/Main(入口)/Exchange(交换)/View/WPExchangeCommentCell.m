//
//  WPExchangeCommentCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeCommentCell.h"


@interface WPExchangeCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation WPExchangeCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius  = self.userImage.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(WPExchangeCommentsModel *)model{
    _model          = model;
    _comment.text   = model.comment;
    _time.text      = model.time;
    [_userName setTitle:model.userName forState:UIControlStateNormal];
    [_userImage sd_setImageWithURL:[NSURL URLWithString:model.userImage_url] placeholderImage:nil];
    
    
}
@end

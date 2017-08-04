//
//  WPCommentViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentViewCell.h"
#import "WPCommentMessageCell.h"

@interface WPCommentViewCell ()
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation WPCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headPortrait.layer.masksToBounds = YES;
    self.headPortrait.layer.cornerRadius  = 17.5;
}
/**点赞*/
- (IBAction)thumbUp:(UIButton *)sender {
    
}
/**进行评论*/
- (IBAction)comment:(UIButton *)sender {
    
}

-(void)setModel:(WPCommentModel *)model{
    _model = model;
    _headPortrait.image = model.headImage;
    _name.text = model.uname;
    _time.text = model.commentTime;
    _comment.text = model.commentText;
}
-(void)setCommentMessageModel:(WPCommentMessegeModel *)commentMessageModel{
    _commentMessageModel = commentMessageModel;
    _headPortrait.image = commentMessageModel.headImage;
    _name.text = commentMessageModel.uname;
    _time.text = commentMessageModel.commentTime;
    _comment.text = commentMessageModel.commentContent;
}

@end

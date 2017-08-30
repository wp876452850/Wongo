//
//  WPDreamingDetailIntroduceTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDetailIntroduceTableViewCell.h"

@interface WPDreamingDetailIntroduceTableViewCell ()
{
    WPDreamingDetailIntroduceBlock _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UITextView * introduceTextView;

@end
@implementation WPDreamingDetailIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _introduceTextView.frame = CGRectMake(10, _icon.bottom + 5, WINDOW_WIDTH - 20, 100);
}

-(void)setName:(NSString *)name{
    _name = name;
    _nameLabel.text = name;
}
-(void)setIntroduce:(NSString *)introduce{
    _introduce = introduce;
    _introduceTextView.text = introduce;
    CGFloat height = [introduce getSizeWithFont:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake(WINDOW_WIDTH - 20, MAXFLOAT)].height;
    _introduceTextView.height = height + 10;
    if (_block) {
        _block(_introduceTextView.bottom);
    }
}

-(void)getCellheightWithBlock:(WPDreamingDetailIntroduceBlock)block{
    _block = block;
}

@end

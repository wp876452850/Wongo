//
//  WPMyDreamingTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyDreamingTableViewCell.h"


@interface WPMyDreamingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
@implementation WPMyDreamingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5.f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

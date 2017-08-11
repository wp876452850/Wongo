//
//  WPNewDreamingSignUpTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/10.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewDreamingSignUpTableViewCell.h"
#define ImageWidth (WINDOW_WIDTH / 2 - 7.5)

@interface WPNewDreamingSignUpTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end
@implementation WPNewDreamingSignUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (int i = 0; i<4; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%2*ImageWidth+5*(i%2+1), i/2*ImageWidth+5*(i/2+1), ImageWidth, ImageWidth)];
        
        imageView.backgroundColor = WongoBlueColor;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:imageView];
    }
}

- (IBAction)close:(UIButton *)sender {
    
}

@end

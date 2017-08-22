//
//  WPNewDreamingNotSignUpTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/18.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewDreamingNotSignUpTableViewCell.h"

@interface WPNewDreamingNotSignUpTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (weak, nonatomic) IBOutlet UILabel *signUpNumber;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIImageView *userbg;

@end
@implementation WPNewDreamingNotSignUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 20;
    self.image.layer.borderColor = WhiteColor.CGColor;
    self.image.layer.borderWidth = 1.f;
    self.signUp.layer.masksToBounds = YES;
    self.signUp.layer.cornerRadius = 8.0f;
    self.userbg.layer.masksToBounds = YES;
    self.userbg.layer.cornerRadius = 20.f;
    
}


- (IBAction)goSignUp:(UIButton *)sender
{
    [[self findViewController:self]showAlertWithAlertTitle:@"提示" message:@"造梦活动暂未开始" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
}

@end

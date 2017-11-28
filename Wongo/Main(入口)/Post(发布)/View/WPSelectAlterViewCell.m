//
//  WPSelectAlterViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/7/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSelectAlterViewCell.h"

@implementation WPSelectAlterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectButton.layer.masksToBounds   = YES;
    self.selectButton.layer.cornerRadius    = 15;
    self.selectButton.layer.borderColor     = ColorWithRGB(147, 147, 147).CGColor;
    self.selectButton.layer.borderWidth     = 1.0f;
    [self.selectButton setTitleColor:ColorWithRGB(147, 147, 147) forState:UIControlStateNormal];
    //[self.selectButton setTitleColor:SelfThemeColor forState:UIControlStateSelected];
}

- (IBAction)select:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectButton.layer.borderColor = SelfThemeColor.CGColor;
    }else{
        self.selectButton.layer.borderColor = ColorWithRGB(147, 147, 147).CGColor;
    }
}

@end

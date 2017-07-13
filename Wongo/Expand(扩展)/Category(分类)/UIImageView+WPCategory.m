//
//  UIImageView+WPCategory.m
//  Wongo
//
//  Created by Winny on 2016/12/8.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "UIImageView+WPCategory.h"

@implementation UIImageView (WPCategory)

-(void)roundWithWithCornerRadius:(CGFloat)cornerRadiusd{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadiusd;
}
@end

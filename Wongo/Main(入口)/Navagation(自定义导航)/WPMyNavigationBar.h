//
//  WPMyNavigationBar.h
//  Wongo
//
//  Created by rexsu on 2016/12/20.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMyNavigationBar : UIView
@property (nonatomic,strong)UIButton * leftButton;
@property (nonatomic,strong)UIButton * rightButton;
@property (nonatomic,strong)UILabel * title;
-(void)showRightButton;
@end

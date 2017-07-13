//
//  WPUserInformationView.h
//  我的
//
//  Created by rexsu on 2016/11/28.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,UserType)
{
    UserTypeNotLoggedIN = 0,
    UserTypeHaveLogin
};


@interface WPUserInformationView : UIView

//改变消息红点
- (void)changeMessageBtnDot;


-(instancetype)initWithFrame:(CGRect)frame Type:(UserType)type;
-(void)loadDatas;
@end

//
//  WPSearchNavigationBar.h
//  Wongo
//
//  Created by rexsu on 2017/2/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ActionBlock)(NSString * type,NSString * keyWord);
typedef void(^ChooseBlock)();
@interface WPSearchNavigationBar : UIView
@property (nonatomic,strong)UIButton * back;

@property (nonatomic,strong)UIButton * choose;
//是否开启第一响应
@property (nonatomic,assign)BOOL openFirstResponder;

-(void)actionSearchWithBlock:(ActionBlock)block;
-(void)chooseButtonClickWithBlock:(ChooseBlock)block;
@end

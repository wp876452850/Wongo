//
//  NSObject+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WPCategory)
/**获得当前时间字符串*/
-(NSString *)getNowTime;

/**生成订单号*/
-(NSString *)getOrderNumber;

/**设置聊天导航条*/
-(void)setUpChatNavigationBar;

/**查找指定位置nav*/
-(UINavigationController *)getNavigationControllerOfCurrentView;

/**判断是否登录*/
-(BOOL)determineWhetherTheLogin;

/**寻找当前试图控制器*/
-(UIViewController *)findViewController:(UIView*)view;

/**判断商品是否为当前用户的*/
-(BOOL)determineCommodityIsMineWithUid:(NSString *)uid;

-(NSString *)getSelfUid;

-(BOOL)determineWhetherTheLoginWithViewController:(UIViewController*)viewController;

//判断密码正则判断
-(BOOL)checkPassword:(NSString *)password;
//判断电话号码正则判断
-(BOOL)isMobileNumber:(NSString *)mobileNum;
//判断用户名正则判读
-(BOOL)checkUserName:(NSString *)userName;
@end

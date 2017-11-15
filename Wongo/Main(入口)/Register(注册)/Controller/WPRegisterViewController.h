//
//  WPRegisterViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/11/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SuccessfulRegister)(NSString * user,NSString * password);

@interface WPRegisterViewController : UIViewController
-(void)getRegisterUserAndPasswordWithBlock:(SuccessfulRegister)block;
@end

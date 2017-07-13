//
//  RegisterViewController.h
//  MY
//
//  Created by rexsu on 2016/11/28.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SuccessfulRegister)(NSString * user,NSString * password);
@interface RegisterViewController : UIViewController
-(void)getRegisterUserAndPasswordWithBlock:(SuccessfulRegister)block;

@end

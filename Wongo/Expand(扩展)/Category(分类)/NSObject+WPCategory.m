//
//  NSObject+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "NSObject+WPCategory.h"
#import "LoginViewController.h"

@implementation NSObject (WPCategory)

-(NSString *)getNowTime{
    NSDate * beDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * timeStr = [df stringFromDate:beDate];
    return timeStr;
}

-(NSString *)getOrderNumber{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSInteger number = arc4random()%1000;
    return [NSString stringWithFormat:@"%.f%ld",interval,number];
}

-(void)setUpChatNavigationBar{
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]
     setBarTintColor:[UIColor colorWithRed:(1 / 255.0f) green:(149 / 255.0f) blue:(255 / 255.0f) alpha:1]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    
}
-(UINavigationController *)getNavigationControllerOfCurrentView{

    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    UINavigationController * nav = tabBar.selectedViewController;
    return nav;
}

-(BOOL)determineWhetherTheLogin{

    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:User_ID];
    if (uid.length<=0) {
        WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
        UINavigationController * nav = tabBar.selectedViewController;
        UIViewController * vc = nav.viewControllers.lastObject;
        [vc showAlertWithAlertTitle:@"提示" message:@"当前未登录,是否前往登录" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
            LoginViewController * login = [[LoginViewController alloc]init];
            [nav pushViewControllerAndHideBottomBar:login animated:YES];
            
        }];
        
        return NO;
    }
    return YES;
}
-(BOOL)determineWhetherTheLoginWithViewController:(UIViewController*)viewController{
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:User_ID];
    if (uid.length<=0) {

        [viewController showAlertWithAlertTitle:@"提示" message:@"当前未登录,是否前往登录" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
            LoginViewController * login = [[LoginViewController alloc]init];
          
            [viewController dismissViewControllerAnimated:YES completion:nil];
            [[self getNavigationControllerOfCurrentView] pushViewController:login animated:YES];
        }];
        
        return NO;
    }
    return YES;
}
-(UIViewController *)findViewController:(UIView*)view
{
    id responder = view;
    while (responder){
        NSLog(@"!!!%@!!!",[responder class]);
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

-(BOOL)determineCommodityIsMineWithUid:(NSString *)uid{
    return [[self getSelfUid]isEqualToString:uid]?YES:NO;
}

-(NSString *)getSelfUid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:User_ID];
}

-(NSString *)getUserName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:User_Name];
}

-(UIImage *)getUserHeadPortrait{
    NSData * headPortraitData = [[NSUserDefaults standardUserDefaults]objectForKey:User_Head];
    if (headPortraitData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:headPortraitData];
    }
    return nil;
}

-(BOOL)checkPassword:(NSString *)password
{
    /**
        1.  不能全部为数字
        2.  不能全部为字母
        3.  必须包含字母和数字
        4.  6-16位
     */
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
}

-(BOOL)checkUserName:(NSString *)userName
{
    /**
     1.  不能全部为数字
     2.  不能全部为字母
     3.  必须包含字母和数字
     4.  6-16位
     */
    NSString * regex = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:userName]) {
        return YES;
    }else
        return NO;
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

-(void)thumbUpGoodsWithSender:(UIButton *)sender gid:(NSString *)gid{
    //判断是否登录
    [self determineWhetherTheLogin];
    
    }

-(void)focusOnTheUserWithSender:(UIButton *)sender uid:(NSString *)uid{
    //判断是否登录
    [self determineWhetherTheLogin];
}

-(void)collectionOfGoodsWithSender:(UIButton *)sender gid:(NSString *)gid{
    //判断是否登录
    if ([self determineWhetherTheLogin]) {
        __block UIButton * button = sender;
        if (!sender.selected) {
            [WPNetWorking createPostRequestMenagerWithUrlString:CollectionAddUrl params:@{@"gid":gid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
            }];
            return;
        }
        [WPNetWorking createPostRequestMenagerWithUrlString:CollectionCancelUrl params:@{@"gid":gid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            button.selected = !button.selected;
        }];
    }
}


@end

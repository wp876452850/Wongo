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
    if ([self determineWhetherTheLogin]) {
        __block UIButton * button = sender;
        if (!sender.selected) {
            [WPNetWorking createPostRequestMenagerWithUrlString:ThumUpAddUrl params:@{@"gid":gid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [thumupArray addObject:gid];
            }];
        }
        else{
            [WPNetWorking createPostRequestMenagerWithUrlString:ThumUpCancelUrl params:@{@"gid":gid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [thumupArray removeObject:gid];
            }];
        }
    }
}

-(void)thumbUpGoodsWithSender:(UIButton *)sender proid:(NSString *)proid addBlock:(AddBlock)addBlock reduceBlock:(ReduceBlock)reduceBlock{
    //判断是否登录
    if ([self determineWhetherTheLogin]) {
        __block UIButton * button = sender;
        if (!sender.selected) {
            [WPNetWorking createPostRequestMenagerWithUrlString:IncensesproductAdd params:@{@"proid":proid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [thumupDreamingArray addObject:proid];
                addBlock();
            }];
        }
        else{
            [WPNetWorking createPostRequestMenagerWithUrlString:IncensesproductDel params:@{@"proid":proid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [thumupDreamingArray removeObject:proid];
                reduceBlock();
            }];
        }
    }
}
/**关注*/
-(void)focusOnTheUserWithSender:(UIButton *)sender uid:(NSString *)uid{
    //判断是否登录
    if ([self determineWhetherTheLogin]) {
        __block UIButton * button = sender;
        if (!sender.selected) {
            [WPNetWorking createPostRequestMenagerWithUrlString:FollowFAddUrl params:@{@"uidF":uid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [focusArray addObject:uid];
            }];
        }
        else{
            [WPNetWorking createPostRequestMenagerWithUrlString:FollowFDelUrl params:@{@"uidF":uid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [focusArray removeObject:uid];
            }];
        }
    }
}
/**收藏*/
-(void)collectionOfGoodsWithSender:(UIButton *)sender gid:(NSString *)gid{
    //判断是否登录
    if ([self determineWhetherTheLogin]) {
        __block UIButton * button = sender;
        
        if (!sender.selected) {
            [WPNetWorking createPostRequestMenagerWithUrlString:CollectionAddUrl params:@{@"gid":gid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
                button.selected = !button.selected;
                [collectionArray addObject:gid];
            }];
            return;
        }
        [WPNetWorking createPostRequestMenagerWithUrlString:CollectionCancelUrl params:@{@"gid":gid,@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            [collectionArray removeObject:gid];
            button.selected = !button.selected;
        }];
    }
}
/**************/


static id thumupArray;
static id thumupDreamingArray;
static id focusArray;
static id collectionArray;
static id fansArray;
static const NSString * selectUid;

+(instancetype)sharedThumupArray{
    
    if (thumupArray == nil) {
        
        @synchronized(self) {
            
            if(thumupArray == nil&&[selectUid getSelfUid].length>0) {
                selectUid = [selectUid getSelfUid];
                thumupArray = [[self alloc] init];
                [thumupArray loadThumUpDatas];
            }
        }
    }
    else if (![selectUid isEqualToString:[selectUid getSelfUid]]) {
        thumupArray = [[self alloc] init];
        selectUid = [self getSelfUid];
        [thumupArray loadThumUpDatas];
    }
    return thumupArray;
}
+(instancetype)sharedThumupDreamingArray{
    if (thumupDreamingArray == nil) {
        @synchronized(self) {
            if(thumupDreamingArray == nil&&[self getSelfUid].length>0) {
                selectUid = [self getSelfUid];
                thumupDreamingArray = [[self alloc] init];
                [thumupDreamingArray loadThumUpDreamingDatas];
            }
        }
    }
    else if (![selectUid isEqualToString:[selectUid getSelfUid]]) {
        thumupDreamingArray = [[self alloc] init];
        selectUid = [self getSelfUid];
        [thumupDreamingArray loadThumUpDreamingDatas];
    }
    return thumupDreamingArray;
}

+(instancetype)sharedFocusArray{
    if (focusArray == nil) {
        @synchronized(self) {
            if(focusArray == nil&&[self getSelfUid].length>0) {
                selectUid = [self getSelfUid];
                focusArray = [[self alloc] init];
                [focusArray loadFocusDatas];
            }
        }
    }
    else if (![selectUid isEqualToString:[self getSelfUid]]) {
        focusArray = [[self alloc] init];
        selectUid = [self getSelfUid];
        [focusArray loadFocusDatas];
    }
    return focusArray;
}
//粉丝
+(instancetype)sharedFansArray{
    if (fansArray == nil) {
        @synchronized(self) {
            if(fansArray == nil&&[self getSelfUid].length>0) {
                selectUid = [self getSelfUid];
                fansArray = [[self alloc] init];
                [fansArray loadFansDatas];
            }
        }
    }
    else if (![selectUid isEqualToString:[self getSelfUid]]) {
        fansArray = [[self alloc] init];
        selectUid = [self getSelfUid];
        [fansArray loadFansDatas];
    }
    return fansArray;
}

+(instancetype)sharedCollectionArray{
    if (collectionArray == nil) {
        
        @synchronized(self) {
            
            if(collectionArray == nil&&[self getSelfUid].length>0) {
                selectUid = [self getSelfUid];
                collectionArray = [[self alloc] init];
                [collectionArray loadCollectionDatas];
            }
        }
    }
    else if (![selectUid isEqualToString:[self getSelfUid]]) {
        collectionArray = [[self alloc] init];
        selectUid = [self getSelfUid];
        [collectionArray loadCollectionDatas];
    }
    return collectionArray;
}

#pragma mark - loadDatas
//收藏商品
-(void)loadCollectionDatas{
    if ([self getSelfUid].length>0) {
        [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCollectionUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            NSArray * list = responseObject[@"list"];
            for (NSDictionary * dic in list) {
                NSString * gid = dic[@"gid"];
                [collectionArray addObject:[NSString stringWithFormat:@"%@",gid]];
            }
        }];
    }
}
//点赞商品
-(void)loadThumUpDatas{
    if ([self getSelfUid].length>0) {
        [WPNetWorking createPostRequestMenagerWithUrlString:IncensesUidSelect params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            
        }];
    }
}
//造梦商品点赞商品
-(void)loadThumUpDreamingDatas{
    if ([self getSelfUid].length>0) {
        [WPNetWorking createPostRequestMenagerWithUrlString:IncensesUidSelectPrdouct params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            
        }];
    }
}
//关注用户
-(void)loadFocusDatas{
    if ([self getSelfUid].length>0) {
        [WPNetWorking createPostRequestMenagerWithUrlString:QueryUidFollowUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
            NSArray * listg = responseObject[@"listg"];
            for (NSDictionary * dic in listg) {
                [focusArray addObject:[NSString stringWithFormat:@"%@",dic[@"uids"]]];
            }
        }];
    }
}
//粉丝
-(void)loadFansDatas{
    if ([self getSelfUid].length>0) {
        [WPNetWorking createPostRequestMenagerWithUrlString:QueryUidFollowsUrl params:@{@"uidF":[self getSelfUid]} datas:^(NSDictionary *responseObject){
            NSArray * listg = responseObject[@"listg"];
            for (NSDictionary * dic in listg) {
                [fansArray addObject:[NSString stringWithFormat:@"%@",dic[@"uid"]]];
            }
        }];
    }
}

#pragma mark - predicate

-(BOOL)thumUpWithinArrayContainsGid:(NSString *)gid
{
    if ([self getSelfUid].length>0) {
        NSArray * collectionArray =  [NSArray arrayWithArray:[NSMutableArray sharedThumupArray]];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", gid];
        NSArray *results1 = [collectionArray filteredArrayUsingPredicate:predicate1];
        if (results1.count>0) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)thumUpDreamingWithinArrayContainsProid:(NSString *)proid
{
    if ([self getSelfUid].length>0) {
        NSArray * collectionArray =  [NSArray arrayWithArray:[NSMutableArray sharedThumupDreamingArray]];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", proid];
        NSArray *results1 = [collectionArray filteredArrayUsingPredicate:predicate1];
        if (results1.count>0) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)collectionWithinArrayContainsGid:(NSString *)gid
{
    if ([self getSelfUid].length>0) {
        NSArray * collectionArray =  [NSArray arrayWithArray:[NSMutableArray sharedCollectionArray]];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", gid];
        NSArray *results1 = [collectionArray filteredArrayUsingPredicate:predicate1];
        if (results1.count>0) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)focusOnWithinArrayContainsUid:(NSString *)uid{
    
    if ([self getSelfUid].length>0) {
        NSArray * collectionArray =  [NSArray arrayWithArray:[NSMutableArray sharedFocusArray]];
        if ([collectionArray containsObject:uid]) {
            return YES;
        }
    }
    return NO;
}

-(void)makePhoneCallWithTelNumber:(NSString *)telNumber{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",telNumber];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:telNumber preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    UINavigationController * nav = tabBar.viewControllers.lastObject;
    UIViewController * vc = nav.viewControllers.lastObject;
    [vc presentViewController:alertController animated:YES completion:nil];
}
@end

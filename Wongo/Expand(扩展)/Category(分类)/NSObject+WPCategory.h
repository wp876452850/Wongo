//
//  NSObject+WPCategory.h
//  Wongo
//
//  Created by rexsu on 2017/3/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AddBlock)(void);
typedef void(^ReduceBlock)(void);

@interface NSObject (WPCategory)
/**默认商品图片*/
-(UIImage *)getPlaceholderImage;

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

-(NSString *)getUserName;

-(NSString *)getUserToken;

-(UIImage *)getUserHeadPortrait;

-(BOOL)determineWhetherTheLoginWithViewController:(UIViewController*)viewController;



//判断密码正则判断
-(BOOL)checkPassword:(NSString *)password;
//判断电话号码正则判断
-(BOOL)isMobileNumber:(NSString *)mobileNum;
//判断用户名正则判读
-(BOOL)checkUserName:(NSString *)userName;

/**点赞商品*/
-(void)thumbUpGoodsWithSender:(UIButton *)sender gid:(NSString *)gid;
/**点赞造梦商品*/
-(void)thumbUpGoodsWithSender:(UIButton *)sender proid:(NSString *)proid addBlock:(AddBlock)addBlock reduceBlock:(ReduceBlock)reduceBlock;
/**关注用户*/
-(void)focusOnTheUserWithSender:(UIButton *)sender uid:(NSString *)uid;
/**收藏商品*/
-(void)collectionOfGoodsWithSender:(UIButton *)sender gid:(NSString *)gid;

+(instancetype)sharedThumupArray;
+(instancetype)sharedThumupDreamingArray;
+(instancetype)sharedFocusArray;
+(instancetype)sharedFansArray;
+(instancetype)sharedCollectionArray;


-(BOOL)thumUpWithinArrayContainsGid:(NSString *)gid;
-(BOOL)thumUpDreamingWithinArrayContainsProid:(NSString *)proid;
-(BOOL)collectionWithinArrayContainsGid:(NSString *)gid;
-(BOOL)focusOnWithinArrayContainsUid:(NSString *)uid;

//打电话
-(void)makePhoneCallWithTelNumber:(NSString *)telNumber;
/*-----------------------类方法-------------------------*/



 @end

//
//  WPSelectAlterView.h
//  Wongo
//
//  Created by rexsu on 2017/3/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectAlertBlock)(NSString * string,NSString * gcid);
@interface WPSelectAlterView : UIView

/**
 网络请求分类

 @param frame 控件frame
 @param urlString 请求url
 @param params 参数
 @param block 点击类型返回数据
 @param selectedCategoryName 已经选择的分类，如果没有传nil
 @return id
 */
+(instancetype)createURLSelectAlterWithFrame:(CGRect)frame urlString:(NSString *)urlString params:(NSDictionary *)params block:(SelectAlertBlock)block selectedCategoryName:(NSString *)selectedCategoryName;

/**
 自定义分类

 @param frame 控件frame
 @param array 自定义分类数组
 @param block 点击类型返回数据
 @param selectedCategoryName 已经选择的分类，如果没有传nil
 @return id
 */
+(instancetype)createArraySelectAlterWithFrame:(CGRect)frame array:(NSArray *)array block:(SelectAlertBlock)block selectedCategoryName:(NSString *)selectedCategoryName;

@end

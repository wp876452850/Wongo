//
//  WPAttributedString.h
//  test1
//
//  Created by  WanGao on 2017/7/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPMatching.h"
#import <UIKit/UIKit.h>

@interface WPAttributedString : NSObject
//该测试用的是UITextView，UIWebView没有测试过


/**
 *  计算字符size
 *
 *  @param attString 字符串
 *  @param size 预设宽高
 *  @return size(父控件为TextView时计算出的高度有偏差 要设置textView的以下属性 self.myTextView.textContainerInset = UIEdgeInsetsZero;
 self.myTextView.textContainer.lineFragmentPadding = 0;)
 */
+(CGSize)attributedStringSizeWithAttString:(NSAttributedString*)attString  preinstallSize:(CGSize)size;

/**
 *
 *
 *  @param string  要修改的字符串
 *  @param urlName 网页链接更改后的标识（例如 #网页链接#）
 *  @param isLine 是否显示网页标识下划线
 *  @return 返回网页链接富文本
 */
+(NSAttributedString*)attributedStringWithString:(NSString*)string andUrlStringName:(NSString*)urlName line:(BOOL)isLine;



/**
 
 *  @param string  要修改的字符串
 *  @param urlName 网页链接更改后的标识（例如 #网页链接#）
 *  @param urlStr  指定更改那个url字符串
 *  @param urlStr 网页下划线
 *  @return 更改指定链接后的NSAttributedString
 */
+(NSAttributedString*)attributedStringWithAttString:(NSAttributedString*)attString andUrlStringName:(NSString*)urlName urlStr:(NSString*)urlStr line:(BOOL)isLine;


/**
 *
 *
 *  @param attributedString 传人要修改的字符串
 *  @param stringColor      字符串的颜色
 *  @param font             字体
 *  @param range            要改变的位置（默认为字符串的长度）
 *
 *  @return 更改指定范围颜色字体的字符
 */
+(NSAttributedString*)attributedStringWithAttributedString:(NSAttributedString*)attributedString andColor:(UIColor *)stringColor  font:(UIFont*)font range:(NSRange)range;


/**
 *
 *
 *  @param attributedString 要插入图片的字符串
 *  @param image            要插入的图片
 *  @param index            插入的下标
 *
 *  @return 插入指定位置图片的字符串
 */
+(NSAttributedString*)attributedStringWithAttributedString:(NSAttributedString*)attributedString insertImage:(UIImage*)image atIndex:(NSInteger)index imageBounds:(CGRect)imageBounds;



/**
 *  isCall ：传人YES点击后调用打电话 NO调用发短信
 *  @return 用图片（文字）替换字符串中的手机号码（不传人图片默认点击手机号码拨打电话）
 */
+(NSAttributedString*)attributedPhoneStringWithString:(NSAttributedString*)attString insertImage:(UIImage *)image orPhoneNameString:(NSString*)phoneName isCall:(BOOL)isCall ;


/**
 *
 *  @return 用图片(文字)替换邮箱（不传人图片默认点击邮箱打开邮箱链接）
 */
+(NSAttributedString*)attributedEmailStringWithString:(NSAttributedString*)attString insertImage:(UIImage *)image orEmailNameString:(NSString*)emailName;

+(NSAttributedString*)attributedWithAttributedString:(NSAttributedString *)attributedString font:(UIFont *)font range:(NSRange)range;

@end

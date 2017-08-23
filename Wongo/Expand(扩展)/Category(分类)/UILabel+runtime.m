//
//  UILabel+runtime.m
//  Wongo
//
//  Created by  WanGao on 2017/8/18.
//  Copyright © 2017年 Winny. All rights reserved.
//



#import "UILabel+runtime.h"
#define CustomFontName @"AdobeHeitiStd-Regular"
@implementation UILabel (runtime)
//+ (void)load {
//    //方法交换应该被保证，在程序中只会执行一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //获得viewController的生命周期方法的selector
//        SEL systemSel = @selector(willMoveToSuperview:);
//        //自己实现的将要被交换的方法的selector
//        SEL swizzSel = @selector(myWillMoveToSuperview:);
//        //两个方法的Method
//        Method systemMethod = class_getInstanceMethod([self class], systemSel);
//        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
//        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
//        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
//        if (isAdd) {
//            //如果成功，说明类中不存在这个方法的实现
//            //将被交换方法的实现替换到这个并不存在的实现
//            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//        } else {
//            //否则，交换两个方法的实现
//            method_exchangeImplementations(systemMethod, swizzMethod);
//        }
//    });
//}
//- (void)myWillMoveToSuperview:(UIView *)newSuperview {
//    [self myWillMoveToSuperview:newSuperview];
//    //    if ([self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
//    //        return;
//    //    }
//    if (self) {
//        if (self.tag == 10086) {
//            self.font = [UIFont systemFontOfSize:self.font.pointSize];
//        } else {
//            if ([UIFont fontNamesForFamilyName:CustomFontName])
//                self.font  = [UIFont fontWithName:CustomFontName size:self.font.pointSize];
//        }
//    }
//}

+(void)load{
    
    //只执行一次这个方法
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        
        // Class class = object_getClass((id)self);
        
        //替换三个方法
        
        SEL originalSelector = @selector(init);
        
        SEL originalSelector2 = @selector(initWithFrame:);
        
        SEL originalSelector3 = @selector(awakeFromNib);
        
        SEL swizzledSelector = @selector(YHBaseInit);
        
        SEL swizzledSelector2 = @selector(YHBaseInitWithFrame:);
        
        SEL swizzledSelector3 = @selector(YHBaseAwakeFromNib);
        
        
        
        
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        
        Method originalMethod3 = class_getInstanceMethod(class, originalSelector3);
        
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        
        Method swizzledMethod3 = class_getInstanceMethod(class, swizzledSelector3);
        
        BOOL didAddMethod =
        
        class_addMethod(class,
                        
                        originalSelector,
                        
                        method_getImplementation(swizzledMethod),
                        
                        method_getTypeEncoding(swizzledMethod));
        
        BOOL didAddMethod2 =
        
        class_addMethod(class,
                        
                        originalSelector2,
                        
                        method_getImplementation(swizzledMethod2),
                        
                        method_getTypeEncoding(swizzledMethod2));
        
        BOOL didAddMethod3 =
        
        class_addMethod(class,
                        
                        originalSelector3,
                        
                        method_getImplementation(swizzledMethod3),
                        
                        method_getTypeEncoding(swizzledMethod3));
        
        
        
        if (didAddMethod) {
            
            class_replaceMethod(class,
                                
                                swizzledSelector,
                                
                                method_getImplementation(originalMethod),
                                
                                method_getTypeEncoding(originalMethod));
            
            
            
        } else {
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
            
        }
        
        if (didAddMethod2) {
            
            class_replaceMethod(class,
                                
                                swizzledSelector2,
                                
                                method_getImplementation(originalMethod2),
                                
                                method_getTypeEncoding(originalMethod2));
            
        }else {
            
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
            
        }
        
        if (didAddMethod3) {
            
            class_replaceMethod(class,
                                
                                swizzledSelector3,
                                
                                method_getImplementation(originalMethod3),
                                
                                method_getTypeEncoding(originalMethod3));
            
        }else {
            
            method_exchangeImplementations(originalMethod3, swizzledMethod3);
            
        }
        
    });
    
    
}
/**
 
 *在这些方法中将你的字体名字换进去
 
 */
- (instancetype)YHBaseInit
{
    
    id __self = [self YHBaseInit];
    
    UIFont * font = [UIFont fontWithName:CustomFontName size:self.font.pointSize];
    
    if (font) {
        
        self.font=font;
        
    }
    
    return __self;
}

-(instancetype)YHBaseInitWithFrame:(CGRect)rect{
    id __self = [self YHBaseInitWithFrame:rect];
    UIFont * font = [UIFont fontWithName:CustomFontName size:self.font.pointSize];
    if (font) {
        self.font=font;
    }
    return __self;
}

-(void)YHBaseAwakeFromNib{
    
    [self YHBaseAwakeFromNib];
    
    UIFont * font = [UIFont fontWithName:CustomFontName size:self.font.pointSize];
    
    if (font) {        
        self.font=font;
    }
    
    
}
@end

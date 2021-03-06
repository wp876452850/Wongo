//
//  WPCustomButton.h
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//  自定义按钮

#import <UIKit/UIKit.h>

@interface WPCustomButton : UIView

@property (nonatomic,strong)UIImageView * image;

@property (nonatomic,assign)BOOL selected;

@property (nonatomic,strong)NSString * title;

@property (nonatomic,strong)UIColor * normalTitleColor;

@property (nonatomic,strong)UIColor * selectedTitleColor;

@property (nonatomic,strong)UILabel * titleLabel;

@property (nonatomic,strong)NSAttributedString * normalAttrobuteString;

@property (nonatomic,strong)NSAttributedString * selectedAttrobuteString;

@end

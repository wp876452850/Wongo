//
//  WPVarietiesButton.h
//  Wongo
//
//  Created by  WanGao on 2017/10/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPVarietiesButton : UIButton
//品种图片
@property (nonatomic,strong)UIImageView * varietiesImageView;
//品种标题
@property (nonatomic,strong)UILabel * varietiesTitleLabel;

-(instancetype)initWithImage:(UIImage *)image title:(NSString *)title frame:(CGRect)frame;

@end

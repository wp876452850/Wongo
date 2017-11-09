//
//  WPChoiceContentCollectionView.h
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPChoiceContentCollectionView : UIScrollView
+(instancetype)createChoiceCollectionWithFrame:(CGRect)frame loadDatasUrls:(NSArray<NSString *> *)loadDatasUrls;
@end

//
//  WPChoiceSubCollectionView.h
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPChoiceSubCollectionView : UICollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout loadDatasUrl:(NSString *)url cellClass:(Class)cellClass;
@end

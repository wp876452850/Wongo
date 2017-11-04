//
//  LYHomeResponse.m
//  Wongo
//
//  Created by  WanGao on 2017/6/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYHomeResponse.h"

@implementation LYHomeResponse
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"listfk":@"LYHomeCategory",
             @"listfl":@"LYHomeCategory",
             @"listhk":@"LYHomeCategory",
             @"listhl":@"LYHomeCategory",
             @"listzk":@"LYHomeCategory",
             @"listzl":@"LYHomeCategory",
             @"listxk":@"LYHomeCategory",
             @"listxl":@"LYHomeCategory",
             };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"listfk":@"listf.listfk",
             @"listfl":@"listf.listfl",
             @"listhk":@"listh.listhk",
             @"listhl":@"listh.listhl",
             @"listzk":@"listz.listzk",
             @"listzl":@"listz.listzl",
             @"listxk":@"listx.listxk",
             @"listxl":@"listx.listxl",
             };
}

- (BOOL)hasBanner:(NSInteger)index{
    switch (index) {
        case 0:
            return self.listxl.count;
            break;
        case 1:
            return self.listfl.count;
            break;
        case 2:
            return self.listzl.count;
            break;
        default:
            return 0;
            break;
    }
}

- (BOOL)hasCategory:(NSInteger)section{
    switch (section) {
        case 0:
            return self.listxk.count + self.listxl.count;
            break;
        case 1:
            return self.listfk.count + self.listfl.count;
            break;
        case 2:
            return self.listzk.count + self.listzl.count;
            break;
        default:
            return 0;
            break;
    }
}

@end

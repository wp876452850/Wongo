//
//  NSString+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2017/1/3.
//  Copyright © 2017年 Wongo. All rights reserved.
//

#import "NSString+WPCategory.h"

@implementation NSString (WPCategory)
-(NSString *)getStringSegmentationRegionWithString:(NSString *)string
{
    if ([self rangeOfString:@"省"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@"省" withString:@"省-"];
    }
    if ([string rangeOfString:@"市"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@"市" withString:@"市-"];
    }
    if ([string rangeOfString:@"区"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@"区" withString:@"区-"];
    }
    if ([string rangeOfString:@"县"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@"县" withString:@"县-"];
    }
    return string;
}
@end

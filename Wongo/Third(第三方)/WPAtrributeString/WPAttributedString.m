//
//  WPAttributedString.m
//  test1
//
//  Created by  WanGao on 2017/7/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAttributedString.h"

@implementation WPAttributedString


+(CGSize)attributedStringSizeWithAttString:(NSAttributedString*)attString  preinstallSize:(CGSize)size
{
    
    NSRange range = NSMakeRange(0, attString.length);
    NSDictionary *dict =  [attString attributesAtIndex:0 effectiveRange:&range];
    
    CGSize stringSize  = [attString.string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return stringSize;
}


+(NSAttributedString*)attributedStringWithString:(NSString*)string andUrlStringName:(NSString*)urlName line:(BOOL)isLine
{
    if (string==nil || [string isEqualToString:@""]) return nil;
    
    NSArray *rangeArr = [WPMatching urlRangeArrWithString:string];
    
    NSString *urlStr  = nil;
    NSMutableAttributedString *attStr = nil;
    
    
    if (rangeArr)
    {
        
        //网页标识
        if (urlName==nil || [urlName isEqualToString:@""])
        {
            attStr = [[NSMutableAttributedString alloc]initWithString:string];
            
            for (NSDictionary *dict in rangeArr)
            {
                int locationI = [dict[locationKey]intValue];
                int lengthI = (int)[dict[lengthKey]integerValue];
                NSRange range = NSMakeRange(locationI, lengthI);
                
                urlStr = [string substringWithRange:range];
                
                attStr = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
                
                NSDictionary *attrDict;
                if (isLine)
                {
                    attrDict = @{ NSLinkAttributeName: [NSURL URLWithString: urlStr],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                }else
                {
                    attrDict = @{ NSLinkAttributeName: [NSURL URLWithString: urlStr]};
                }
                
                [attStr addAttributes:attrDict range:range];
                
            }
            
        }else
        {
            
            NSMutableArray *attrDict_Arr = [NSMutableArray array];
            NSMutableArray *urlRange_Arr = [NSMutableArray array];
            NSArray *url_Arr = [WPMatching urlArrWithString:string];
            
            
            
            NSString *sub_str = string;
            NSInteger index = 0;
            
            for (int i = 0; i < url_Arr.count; ++i)
            {
                NSString *urlStr = url_Arr[i];
                sub_str = [sub_str stringByReplacingOccurrencesOfString:urlStr withString:urlName];
                
                NSRange range = [sub_str rangeOfString:urlName];
                sub_str = [sub_str substringFromIndex:(range.location+range.length)];
                
                NSRange urlRange = NSMakeRange(range.location + index, urlName.length);
                index = (range.length + range.location +index);
                
                NSDictionary *ranDic = @{locationKey:@(urlRange.location),lengthKey:@(urlRange.length)};
                [urlRange_Arr addObject:ranDic];
                
                NSDictionary *attrDict1;
                if (isLine)
                {
                    attrDict1 = @{ NSLinkAttributeName: [NSURL URLWithString: urlStr],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
                }else
                {
                    attrDict1 = @{ NSLinkAttributeName: [NSURL URLWithString: urlStr]};
                }
                
                [attrDict_Arr addObject:attrDict1];
                
                string = [string stringByReplacingOccurrencesOfString:urlStr withString:urlName];
            }
            
            attStr = [[NSMutableAttributedString alloc]initWithString:string];
            
            for (int i = 0; i < urlRange_Arr.count; ++i)
            {
                
                NSDictionary *dict = urlRange_Arr[i];
                int locationI = [dict[locationKey]intValue];
                int lengthI = (int)[dict[lengthKey]integerValue];
                NSRange range = NSMakeRange(locationI, lengthI);
                
                NSDictionary *attrDict = attrDict_Arr[i];
                
                [attStr addAttributes:attrDict range:range];
            }
            
        }
        
    }
    
    return attStr.copy;
}




+(NSAttributedString*)attributedStringWithAttString:(NSAttributedString*)attString andUrlStringName:(NSString*)urlName urlStr:(NSString*)urlStr line:(BOOL)isLine
{
    NSRange range = [attString.string rangeOfString:urlStr];
    
    if (range.length==0) return attString;
    
    
    NSMutableAttributedString *att_str = [[NSMutableAttributedString alloc]initWithAttributedString:attString];
    
    
    NSInteger  index = 0;
    [att_str  replaceCharactersInRange:range withString:urlName];
    NSString *string = att_str.string;
    while (true)
    {
        NSRange tmpRange = [string rangeOfString:urlName];
        if (tmpRange.length==0) break;
        
        
        NSRange UrlNameRange = NSMakeRange(index + tmpRange.location, urlName.length);
        index = tmpRange.location +tmpRange.length+index;
        NSDictionary *attrDict;
        if (isLine)
        {
            attrDict = @{ NSLinkAttributeName: [NSURL URLWithString: urlStr],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        }else
        {
            attrDict = @{ NSLinkAttributeName: [NSURL URLWithString: urlStr]};
        }
        
        [att_str addAttributes:attrDict range:UrlNameRange];
        
        range = [att_str.string rangeOfString:urlStr];
        
        if (range.length!=0)
        {[att_str  replaceCharactersInRange:range withString:urlName];};
        
        
        string = att_str.string;
        string = [string substringFromIndex:index];
    }
    
    
    return att_str.copy;
}




+(NSAttributedString*)attributedStringWithAttributedString:(NSAttributedString*)attributedString andColor:(UIColor *)stringColor  font:(UIFont*)font range:(NSRange)range
{
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
    
    NSDictionary *dict;
    if (stringColor&&!font)
    {
        dict = @{NSForegroundColorAttributeName:stringColor};
    }
    
    if (font &&!stringColor)
    {
        dict = @{NSFontAttributeName:font};
    }
    
    if (stringColor && font)
    {
        //设置换行样式
        NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
        //        NSLineBreakByWordWrapping = 0, //自动换行，单词切断
        //        NSLineBreakByCharWrapping,     //自动换行，字母切断
        paraStyle02.lineBreakMode = NSLineBreakByCharWrapping;
        
        dict = @{NSForegroundColorAttributeName:stringColor,NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle02};
    }
    
    if (range.length==0)
    {
        range = NSMakeRange(0, attstr.length);
    }
    [attstr addAttributes:dict range:range];
    
    return attstr.copy;
}


+(NSAttributedString*)attributedStringWithAttributedString:(NSAttributedString*)attributedString insertImage:(UIImage*)image atIndex:(NSInteger)index imageBounds:(CGRect)imageBounds
{
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    
    textAttachment.image = image;
    
    textAttachment.bounds = imageBounds;
    
    NSAttributedString *att_str = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attstr insertAttributedString:att_str atIndex:index];
    
    return attstr.copy;
}




+(NSAttributedString*)attributedPhoneStringWithString:(NSAttributedString*)attString insertImage:(UIImage *)image orPhoneNameString:(NSString*)phoneName isCall:(BOOL)isCall
{
    
    NSString *originStr = attString.string;
    if (originStr==nil || [originStr isEqualToString:@""]) return nil;
    
    NSArray *rangeArr = [WPMatching phoneNumRangeArrWithString:originStr];
    NSArray *phoneNum_Arr = [WPMatching phoneNumArrWithString:originStr];
    
    //    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithAttributedString:attString];
    
    NSString *callStr = nil;
    if (isCall) {
        callStr = @"tel://";
    }else
    {
        callStr = @"sms://";
    }
    
    NSAttributedString* attStr = [WPAttributedString attributedStringWithString:attString insertImage:image orStringName:phoneName linkUrlString:callStr rangeArr:rangeArr originStringArr:phoneNum_Arr];
    
    
    
    
    return attStr.copy;
}



+(NSAttributedString*)attributedEmailStringWithString:(NSAttributedString*)attString insertImage:(UIImage *)image orEmailNameString:(NSString*)emailName
{
    NSString *originStr = attString.string;
    if (originStr==nil || [originStr isEqualToString:@""]) return nil;
    
    NSArray *rangeArr = [WPMatching emailRangeArrWithString:originStr];
    NSArray *emailNum_Arr = [WPMatching emailStringArrWithString:originStr];
    
    NSAttributedString* attStr = [WPAttributedString attributedStringWithString:attString insertImage:image orStringName:emailName linkUrlString:@"mailto://" rangeArr:rangeArr originStringArr:emailNum_Arr];
    
    
    return attStr;
}



//私有方法
+(NSAttributedString*)attributedStringWithString:(NSAttributedString*)attString insertImage:(UIImage *)image orStringName:(NSString*)stringName linkUrlString:(NSString*)urlString rangeArr:(NSArray*)rangeArr originStringArr:(NSArray*)originStringArr
{
    NSString *originStr = attString.string;
    if (originStr==nil || [originStr isEqualToString:@""]) return nil;
    
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithAttributedString:attString];
    
    if (rangeArr)
    {
        
        if (stringName)
        {
            NSString *sub_str = originStr;
            NSInteger index = 0;
            NSMutableArray *phoneRange_Arr = [NSMutableArray array];
            
            for (NSString *phone in originStringArr)
            {
                sub_str = [sub_str stringByReplacingOccurrencesOfString:phone withString:stringName];
                
                NSRange range = [sub_str rangeOfString:stringName];
                sub_str = [sub_str substringFromIndex:(range.location+range.length)];
                
                NSRange phoneRange = NSMakeRange(range.location + index, stringName.length);
                index = (range.length + range.location +index);
                
                NSDictionary *ranDic = @{locationKey:@(phoneRange.location),lengthKey:@(phoneRange.length)};
                [phoneRange_Arr addObject:ranDic];
                
                NSRange subRange = [originStr rangeOfString:phone];
                [attStr replaceCharactersInRange:subRange withString:stringName];
                originStr = attStr.string;
                
            }
            
            for (int i = 0;i<phoneRange_Arr.count;i++)
            {
                NSString *phone = originStringArr[i];
                NSDictionary *rangeDict = phoneRange_Arr[i];
                
                NSInteger locationI = [rangeDict[locationKey] integerValue];
                NSInteger lengthI = [rangeDict[lengthKey]integerValue];
                NSRange range = NSMakeRange(locationI, lengthI);
                
                NSDictionary *dict = @{NSLinkAttributeName:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,phone]]};
                [attStr addAttributes:dict range:range];
            }
            
        }else if(image)
        {
            
            NSMutableArray *imageRange_Arr = [NSMutableArray array];
            
            for (NSString *phone in originStringArr)
            {
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
                textAttachment.image = image;
                textAttachment.bounds = CGRectMake(0, -attString.size.height/5, attString.size.height, attString.size.height);
                
                NSAttributedString *imageAtt_str = [NSAttributedString attributedStringWithAttachment:textAttachment];
                NSDictionary *dict = @{NSLinkAttributeName:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,phone]]};
                NSMutableAttributedString *imageAttStrM = [[NSMutableAttributedString alloc]initWithAttributedString:imageAtt_str];
                [imageAttStrM addAttributes:dict range:NSMakeRange(0, imageAtt_str.length)];
                
                NSRange subRange = [originStr rangeOfString:phone];
                [attStr replaceCharactersInRange:subRange withAttributedString:imageAttStrM];
                originStr = attStr.string;
                NSRange imageRange = [originStr rangeOfString:imageAtt_str.string];
                NSDictionary *ranDic = @{locationKey:@(imageRange.location),lengthKey:@(imageRange.length)};
                [imageRange_Arr addObject:ranDic];
                
            }
            
        }else
        {
            for (int i = 0;i<originStringArr.count;i++)
            {
                NSString *phone = originStringArr[i];
                NSDictionary *rangeDict = rangeArr[i];
                
                NSInteger locationI = [rangeDict[locationKey] integerValue];
                NSInteger lengthI = [rangeDict[lengthKey]integerValue];
                NSRange range = NSMakeRange(locationI, lengthI);
                
                NSDictionary *dict = @{NSLinkAttributeName:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,phone]]};
                [attStr addAttributes:dict range:range];
            }
            
        }
        
    }
    
    return attStr.copy;
}

+(NSAttributedString *)attributedWithAttributedString:(NSAttributedString *)attributedString font:(UIFont *)font range:(NSRange)range{
    
    
    return attributedString;
}

+ (NSAttributedString *)changeWordSpaceForText:(NSString *)text WithSpace:(float)space {


    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    return attributedString;
}

+ (NSAttributedString *)changeSpaceForText:(NSString *)text withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    return attributedString;
}

@end

//
//  WPRegisterUserInformationView.m
//  Wongo
//
//  Created by  WanGao on 2017/11/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPRegisterUserInformationView.h"
#import "WPCostomTextField.h"

@interface WPRegisterUserInformationView ()
@property (nonatomic,strong)NSString * phoneNumber;
@property (nonatomic,strong)NSString * compare;

@property (nonatomic,strong)UIButton * registerButton;
@property (nonatomic,strong)WPCostomTextField * userName;
@property (nonatomic,strong)WPCostomTextField * password;

@end

@implementation WPRegisterUserInformationView

-(instancetype)initWithPhoneNumber:(NSString *)phoneNumber compare:(NSString *)compare{
    if (self = [super init]) {
        self.phoneNumber = phoneNumber;
        self.compare = compare;
    }
    return self;
}

@end

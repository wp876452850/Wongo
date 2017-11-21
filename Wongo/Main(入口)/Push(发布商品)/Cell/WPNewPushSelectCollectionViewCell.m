//
//  WPNewPushSelectCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushSelectCollectionViewCell.h"
#import "WPSelectAlterView.h"

@interface WPNewPushSelectCollectionViewCell ()
{
    //是否需要进行数据请求
    BOOL isNeedNetWorlk;
    
    WPNewPushSelectBlock _block;
}
@end
@implementation WPNewPushSelectCollectionViewCell


-(void)setUrl:(NSString *)url{
    _url = url;
    isNeedNetWorlk = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)actionSelect:(id)sender {
    __block typeof(self)weakSelf = self;
    if (isNeedNetWorlk) {
        WPSelectAlterView * selectAlterView = [WPSelectAlterView createURLSelectAlterWithFrame:[self findViewController:self].view.frame urlString:CommodityTypeUrl params:nil block:^(NSString *string ,NSString * gcid) {
            weakSelf.textField.text = string;
            if (_block) {
                _block(string,gcid);
            }
        } selectedCategoryName:self.textField.text];
        [[self findViewController:self].view addSubview:selectAlterView];
    }
    else{
        WPSelectAlterView * selectAlterView = [WPSelectAlterView createArraySelectAlterWithFrame:[self findViewController:self].view.frame array:self.selectDataArray block:^(NSString *string,NSString * gcid) {
            weakSelf.textField.text = string;
            if (_block) {
                _block(string,gcid);
            }
        } selectedCategoryName:self.textField.text];
        [[self findViewController:self].view addSubview:selectAlterView];
        
    }
}

-(void)getSelectWithBlock:(WPNewPushSelectBlock)block{
    _block = block;
}

@end

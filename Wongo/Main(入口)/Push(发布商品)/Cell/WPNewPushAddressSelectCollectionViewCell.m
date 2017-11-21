//
//  WPNewPushAddressSelectCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushAddressSelectCollectionViewCell.h"
#import "WPAddressSelectViewController.h"

@interface WPNewPushAddressSelectCollectionViewCell ()
{
    WPNewPushAddressBlock _block;
}
@property (weak, nonatomic) IBOutlet UITextField *address;

@end
@implementation WPNewPushAddressSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)selectAddress:(UIButton *)sender {
    WPAddressSelectViewController * vc = [[WPAddressSelectViewController alloc]init];
    [[self findViewController:self] presentViewController:vc animated:YES completion:nil];
    __block typeof(self)weakSelf = self;
    [vc getAdidAndAddressWithBlock:^(WPAddressModel *addr) {
        weakSelf.address.text = addr.address;
        if (_block) {
            _block(addr.adid);
        }
    }];

}
-(void)getAddressWithBlock:(WPNewPushAddressBlock)block
{
    _block = block;
}

@end

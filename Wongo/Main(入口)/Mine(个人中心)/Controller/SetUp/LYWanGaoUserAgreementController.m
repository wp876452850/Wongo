//
//  LYWanGaoUserAgreementController.m
//  Wongo
//
//  Created by  WanGao on 2017/6/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYWanGaoUserAgreementController.h"

@interface LYWanGaoUserAgreementController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation LYWanGaoUserAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)agree:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

//
//  WPCommentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentViewController.h"
#import "WPCommentModel.h"



@interface WPCommentViewController ()<ChatKeyBoardDataSource,ChatKeyBoardDelegate>

@property (nonatomic,strong)ChatKeyBoard * commentKeyBoard;
//记录最后点击cell的indexPath
@property (nonatomic,strong)NSIndexPath * indexPath;
/**数据数组*/
@property (nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation WPCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"评论";
    self.view.backgroundColor = WhiteColor;
}

-(ChatKeyBoard *)commentKeyBoard{
    if (!_commentKeyBoard) {
        _commentKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _commentKeyBoard.delegate = self;
        _commentKeyBoard.dataSource = self;
        _commentKeyBoard.allowVoice = NO;
        _commentKeyBoard.allowFace = NO;
        _commentKeyBoard.allowMore = NO;
        _commentKeyBoard.allowSwitchBar = NO;
        _commentKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        [self.view addSubview:_commentKeyBoard];
        [self.view bringSubviewToFront:_commentKeyBoard];
    }
    return _commentKeyBoard;
}


#pragma mark - ChatKeyBoardDelegate
-(void)chatKeyBoardSendText:(NSString *)text{
    
    
    
}










@end

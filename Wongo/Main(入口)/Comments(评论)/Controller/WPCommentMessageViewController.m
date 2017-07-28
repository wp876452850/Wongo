//
//  WPCommentMessageViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/7/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentMessageViewController.h"
#import "WPProductLinkView.h"
#import "WPCommentViewCell.h"
#import "WPCommentMessageCell.h"


@interface WPCommentMessageViewController ()<ChatKeyBoardDataSource,ChatKeyBoardDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)ChatKeyBoard * commentKeyBoard;

@property (nonatomic,strong)WPCommentModel * model;
@end

@implementation WPCommentMessageViewController
static NSString * const commentCell = @"commentCell";
static NSString * const commentMessageCell = @"commentMessageCell";

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
-(void)setUpTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT -104);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[WPCommentMessageCell class] forCellReuseIdentifier:commentMessageCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPCommentViewCell" bundle:nil] forCellReuseIdentifier:commentCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(instancetype)initWithCommentModel:(WPCommentModel *)model{
    if (self = [super init]) {
        self.model = model;
        [self setUpTableView];
        [self createBottomCommentButton];
        [self.view addSubview:self.tableView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"详情评论";
}

-(void)uploadDatas{
    
}
#pragma mark - ChatKeyBoardDelegate
//点击发送代理
-(void)chatKeyBoardSendText:(NSString *)text{
    WPCommentMessegeModel * commentMessageModel = [[WPCommentMessegeModel alloc]init];
    commentMessageModel.uid = [self getSelfUid];
    commentMessageModel.uname = [self getUserName];
    commentMessageModel.commentContent = text;
    commentMessageModel.byuid = _model.uid;
    commentMessageModel.byuname = _model.uname;
    commentMessageModel.commentTime = [self getNowTime];
    [_model.comments addObject:commentMessageModel];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

#pragma mark - ChatKeyBoardDataSource
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems{
    return nil;
}

#pragma mark - TableViewDelegate&&TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return self.model.comments.count+1;
}
//返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
//配置单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0) {
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            WPProductLinkView * productLinkView = [WPProductLinkView productLinkWithGid:_model.gid frame:CGRectMake(10, 20, 0, 0)];
            [cell.contentView addSubview:productLinkView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
        WPCommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = SelfOrangeColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    WPCommentMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:commentMessageCell forIndexPath:indexPath];
    cell.model = _model.comments[indexPath.row -1];
    return cell;
}
//点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 创建底部评论按钮
-(void)createBottomCommentButton{
    //评论按钮
    UIButton * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, WINDOW_HEIGHT - 40, WINDOW_WIDTH /2, 40);
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentButton.layer.masksToBounds = YES;
    commentButton.layer.borderWidth = 0.5;
    commentButton.layer.borderColor = GRAY_COLOR.CGColor;
    [commentButton addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];
    //点赞按钮
    UIButton * thumbUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thumbUpButton.frame = CGRectMake(WINDOW_WIDTH/2, commentButton.y, commentButton.width, commentButton.height);
    [thumbUpButton setTitle:@"评论" forState:UIControlStateNormal];
    [thumbUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    thumbUpButton.layer.masksToBounds = YES;
    thumbUpButton.layer.borderWidth = 0.5;
    thumbUpButton.layer.borderColor = GRAY_COLOR.CGColor;
    [commentButton addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commentButton];
    [self.view addSubview:thumbUpButton];
}

-(void)commentGoods{
    [self.commentKeyBoard keyboardUpforComment];
}
-(void)thumbUpGoods:(UIButton *)sender{
    [self thumbUpGoodsWithSender:sender gid:_model.gid];
}

@end

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

@property (nonatomic,assign)CGFloat commentHeight;

@property (nonatomic,strong)WPExchangeDetailModel * goodsModel;
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WPCommentViewCell" bundle:nil] forCellReuseIdentifier:commentCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(instancetype)initWithCommentModel:(WPCommentModel *)model goodsModel:(WPExchangeDetailModel *)goodsModel commentHeight:(CGFloat)commentHeight upKeyBoard:(BOOL)upKeyBoard{
    if (self = [super init]) {
        self.model = model;
        self.goodsModel = goodsModel;
        self.commentHeight = commentHeight;
        if (upKeyBoard) {
            [self.commentKeyBoard keyboardUpforComment];
        }
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
    commentMessageModel.headImage = [self getUserHeadPortrait];
    commentMessageModel.commentContent = text;
    commentMessageModel.byuid = _model.uid;
    commentMessageModel.byuname = _model.uname;
    commentMessageModel.commentTime = [self getNowTime];
    [_model.comments insertObject:commentMessageModel atIndex:0];
    //[self.tableView reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
//section头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0.01f;
}
//section脚步高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 130;
                break;
                
            default:return self.commentHeight;
                break;
        }
    }
    if (indexPath.row == 0) {
        return 40;
    }
    if (self.cellsHeight.count >= indexPath.row) {
        return [self.cellsHeight[indexPath.row] floatValue];
    }
    WPCommentMessegeModel * model = _model.comments[indexPath.row-1];
    CGFloat cellHeight = [model.commentContent getSizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)].height + 130;
    [self.cellsHeight insertObject:[NSString stringWithFormat:@"%f",cellHeight] atIndex:0];
    return cellHeight;
}

//配置单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            WPProductLinkView * productLinkView = [WPProductLinkView productLinkWithModel:self.goodsModel frame:CGRectMake(10, 20, 0, 0)];
            [cell.contentView addSubview:productLinkView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
        WPCommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
        cell.model = _model;
        cell.commentButton.hidden = YES;
        cell.thumbUp.hidden = YES;
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [NSString stringWithFormat:@"  全部评论(%ld)",_model.comments.count];
            cell.textLabel.font = [UIFont systemFontOfSize:19];
            [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
            return cell;
        }
        WPCommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
        cell.commentMessageModel = _model.comments[indexPath.row - 1];
        cell.commentButton.hidden = YES;
        [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
        return cell;
    }
    return nil;
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
    [thumbUpButton setTitle:@"点赞" forState:UIControlStateNormal];
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

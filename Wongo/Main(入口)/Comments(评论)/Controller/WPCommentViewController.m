//
//  WPCommentViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentViewController.h"
#import "WPCommentModel.h"
#import "WPCommentMessegeModel.h"
#import "WPCommentViewCell.h"
#import "WPCommentMessageViewController.h"

@interface WPCommentViewController ()<ChatKeyBoardDataSource,ChatKeyBoardDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)ChatKeyBoard * commentKeyBoard;
//记录最后点击cell的indexPath
@property (nonatomic,strong)NSIndexPath * indexPath;
/**数据数组*/
@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong)UITableView * tableView;
/**缓存所有cell高度*/
@property (nonatomic,strong)NSMutableArray * cellsHeight;

@property (nonatomic,strong)NSString * gid;
@end

@implementation WPCommentViewController

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)initWithGid:(NSString *)gid{
    if (self = [super init]) {
        self.gid = gid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavItem.title = @"评论";
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.tableView];
    [self createBottomCommentButton];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:3];
    }
    return _dataSource;
}
-(NSMutableArray *)cellsHeight{
    if (!_cellsHeight) {
        _cellsHeight = [NSMutableArray arrayWithCapacity:3];
    }
    return _cellsHeight;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 104) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"WPCommentViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        _tableView.backgroundColor = ColorWithRGB(247, 247, 247);
    }
    return _tableView;
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

#pragma mark - ChatKeyBoardDelegate
-(void)chatKeyBoardSendText:(NSString *)text{
    WPCommentModel * commentModel = [[WPCommentModel alloc]init];
    commentModel.gid = self.gid;
    commentModel.uname = [self getUserName];
    commentModel.uid = [self getSelfUid];
    commentModel.commentText = text;
    commentModel.commentTime = [self getNowTime];
    commentModel.headImage = [self getUserHeadPortrait];
    [self.dataSource insertObject:commentModel atIndex:0];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

#pragma mark - 更新单元格高度
-(void)reloadCellHeightForModel:(WPCommentModel *)model atIndexPath:(NSIndexPath *)indexPath{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TableViewDelegate&&TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
//section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellsHeight.count > indexPath.section) {
        return [self.cellsHeight[indexPath.section] floatValue];
    }
    WPCommentModel * model = self.dataSource[indexPath.section];
    CGFloat cellHeight = 130 + [model.commentText getSizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)].height;
    [self.cellsHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
    return cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPCommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    [self.view endEditing:YES];
    WPCommentMessageViewController * commentMessageVC = [[WPCommentMessageViewController alloc]initWithCommentModel:self.dataSource[indexPath.section]];
    [self.navigationController pushViewController:commentMessageVC animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 创建底部评论按钮
-(void)createBottomCommentButton{
    UIButton * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, WINDOW_HEIGHT - 40, WINDOW_WIDTH, 40);
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentButton.layer.masksToBounds = YES;
    commentButton.layer.borderWidth = 0.5;
    commentButton.layer.borderColor = GRAY_COLOR.CGColor;
    [commentButton addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentButton];
}

-(void)commentGoods{
    [self.commentKeyBoard keyboardUpforComment];
}


@end

//
//  MsgListVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MsgListVC.h"
#import "MsgListCell.h"
#import "MsgDataListModel.h"
#import "MsgDataModel.h"
#import "WebContentVC.h"

@interface MsgListVC ()
{
    MsgDataListModel *_msgListModel;
}

@property (nonatomic, strong) MsgListCell *prototypeCell;

@end

@implementation MsgListVC
@synthesize DataList;
@synthesize prototypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"我的消息";
    
    _msgListModel = [MsgDataListModel ShareMsgListModel];
    [self initSubviews];
    
    self.DataList = [[NSMutableArray alloc] initWithArray:_msgListModel.dataList];
    if([self.DataList count] == 0){
        __weak MsgListVC *weakSelf = self;
        self.tableview.pullTableIsRefreshing = YES;
        _msgListModel.pages = 0;
        [_msgListModel LoadMsgListWithBlock:^(int code, id content) {
            if(code == 1){
                [weakSelf.DataList addObjectsFromArray:content];
                [weakSelf.tableview reloadData];
            }
            
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[PullTableView alloc] initWithFrame:CGRectZero];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.pullDelegate = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.tableFooterView = [[UIView alloc] init];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[MsgListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    MsgDataModel *data = [DataList objectAtIndex:indexPath.row];
    [cell SetContentDataWithModel:data];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(prototypeCell == nil){
        prototypeCell = [[MsgListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MsgDataModel *data = [DataList objectAtIndex:indexPath.row];
    MsgListCell *cell = (MsgListCell *)self.prototypeCell;
    [cell SetContentDataWithModel:data];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"消息详情" url:@""];
    vc.hidesBottomBarWhenPushed = YES;
    MsgDataModel *data = [DataList objectAtIndex:indexPath.row];
    [vc loadInfoFromUrl:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, data.msgId]];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _msgListModel.pages = 0;
    self.tableview.pullTableIsRefreshing = YES;
    __weak MsgListVC *weakSelf = self;
    [_msgListModel LoadMsgListWithBlock:^(int code, id content) {
        if(code == 1){
            [weakSelf.DataList removeAllObjects];
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf.tableview reloadData];
        }
        
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1];
    }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _msgListModel.pages = _msgListModel.pages + 1;
    self.tableview.pullTableIsLoadingMore = YES;
    __weak MsgListVC *weakSelf = self;
    [_msgListModel LoadMsgListWithBlock:^(int code, id content) {
        if(code == 1){
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf.tableview reloadData];
        }
        
        [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1];
    }];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    NSLog(@"refreshTable");
    self.tableview.pullLastRefreshDate = [NSDate date];
    self.tableview.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    NSLog(@"loadMoreDataToTable");
    self.tableview.pullTableIsLoadingMore = NO;
}


@end

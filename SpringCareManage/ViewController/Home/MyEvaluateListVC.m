//
//  MyEvaluateListVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyEvaluateListVC.h"
#import "EvaluateListCell.h"
#import "EvaluateListModel.h"

@interface MyEvaluateListVC ()
{
    EvaluateListModel *_evaluateModel;
}

@property (nonatomic, strong) EvaluateListCell *prototypeCell;

@end

@implementation MyEvaluateListVC
@synthesize tableview = _tableview;
@synthesize DataList;
@synthesize prototypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _evaluateModel = [EvaluateListModel GetEvaluatesListModel];
    
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"我的评价";
    [self initSubviews];
    
    self.DataList = [[NSMutableArray alloc] initWithArray:_evaluateModel.evaluateList];
    if([self.DataList count] == 0){
        __weak MyEvaluateListVC *weakSelf = self;
        self.tableview.pullTableIsRefreshing = YES;
        _evaluateModel.pages = 0;
        [_evaluateModel RequestEvaluatesWithBlock:^(int code, id content) {
            if(code == 1){
                [weakSelf.DataList addObjectsFromArray:content];
                [weakSelf ValuationForTableHeader];
                [weakSelf.tableview reloadData];
            }
            
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1];
        }];
    }
    else{
        [self ValuationForTableHeader];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) ValuationForTableHeader
{
    NSString *title = [NSString stringWithFormat:@"累计评价%ld（好评%@%@）", (long)_evaluateModel.totals, _evaluateModel.commentsRate, @"%"];
    title = [title stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    lbTitle.text = title;
}

- (void) initSubviews
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 33)];
    lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    lbTitle.textColor = _COLOR(0x99, 0x99, 0x99);
    lbTitle.font = _FONT(15);
    lbTitle.backgroundColor = [UIColor clearColor];
    [headerView addSubview:lbTitle];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbTitle)]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-19-[lbTitle]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbTitle)]];
    
    _tableview = [[PullTableView alloc] initWithFrame:CGRectZero];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.pullDelegate = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.tableHeaderView = headerView;
    
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
    EvaluateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[EvaluateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    EvaluateInfoModel *data = [DataList objectAtIndex:indexPath.row];
    [cell SetContentWithModel:data];
    
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
        prototypeCell = [[EvaluateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    EvaluateInfoModel *data = [DataList objectAtIndex:indexPath.row];
    EvaluateListCell *cell = (EvaluateListCell *)self.prototypeCell;
    [cell SetContentWithModel:data];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
//    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    __weak MyEvaluateListVC *weakSelf = self;
    _evaluateModel.pages = 0;
    [_evaluateModel RequestEvaluatesWithBlock:^(int code, id content) {
        if(code == 1){
            [weakSelf.DataList removeAllObjects];
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf ValuationForTableHeader];
            [weakSelf.tableview reloadData];
        }
        
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1];
    }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    __weak MyEvaluateListVC *weakSelf = self;
    _evaluateModel.pages = _evaluateModel.pages + 1;
    [_evaluateModel RequestEvaluatesWithBlock:^(int code, id content) {
        if(code == 1){
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf ValuationForTableHeader];
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

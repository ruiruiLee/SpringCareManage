//
//  MyEscortObjectVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyEscortObjectVC.h"
#import "EscortObjectCell.h"

@interface MyEscortObjectVC ()

@property (nonatomic, strong) EscortObjectCell *prototypeCell;

@end

@implementation MyEscortObjectVC
@synthesize tableview = _tableview;
@synthesize DataList;
@synthesize prototypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"我的陪护";
    [self initSubviews];
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
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;//[DataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EscortObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[EscortObjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //    cell.textLabel.text = ((NurseListInfoModel*)[DataList objectAtIndex:indexPath.row]).name;
    //    NurseListInfoModel *model = [DataList objectAtIndex:indexPath.row];
    //    [cell SetContentData:model];
    
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
        prototypeCell = [[EscortObjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    NurseListInfoModel *data = [DataList objectAtIndex:indexPath.row];
    EscortObjectCell *cell = (EscortObjectCell *)self.prototypeCell;
    //    [cell SetContentData:data];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    NurseListInfoModel *model = [DataList objectAtIndex:indexPath.row];
    //    NurseDetailInfoVC *vc = [[NurseDetailInfoVC alloc] initWithModel:model];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    //
    //    [model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
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

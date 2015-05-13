//
//  UserCenterVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserCenterVC.h"

@interface UserCenterVC ()
{
    BOOL _reloading;
}

@end

@implementation UserCenterVC
@synthesize tableview;
@synthesize refreshView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.btnLeft.hidden = YES;
    self.NavigationBar.Title = @"个人中心";
    
    [self initSubviews];
}

- (void) initSubviews
{
    tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:tableview];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -100, ScreenWidth, 100)];
    refreshView.delegate = self;
    [tableview addSubview:refreshView];
    [refreshView refreshLastUpdatedDate];
    
    _reloading = NO;
    
//    tableview.tableHeaderView = [self createTableHeaderView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-49-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tableview];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    //    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
//    UserModel *userinfo = [UserModel sharedUserInfo];
    __weak UserCenterVC *weakSelf = self;
//    [userinfo LoadOrderInfo:^(int code, id content) {
        [weakSelf performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
//    }];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

@end

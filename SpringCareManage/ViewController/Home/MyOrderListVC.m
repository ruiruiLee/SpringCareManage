//
//  MyOrderListVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyOrderListVC.h"
#import "OrderListCell.h"

@interface MyOrderListVC ()

@property (nonatomic, strong) OrderListCell *prototypeCell;

@end

@implementation MyOrderListVC
@synthesize orderType;
@synthesize tableview = _tableview;
@synthesize DataList;
@synthesize prototypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    if(orderType == EnumOrderAll){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                  , 44)];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_searchBar sizeToFit];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.backgroundImage = [self imageWithColor:_COLOR(0xf3, 0xf5, 0xf7) size:CGSizeMake(ScreenWidth, 44)];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;//[DataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
        prototypeCell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    NurseListInfoModel *data = [DataList objectAtIndex:indexPath.row];
    OrderListCell *cell = (OrderListCell *)self.prototypeCell;
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

#pragma KVO/KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [_tableview reloadData];
    
}

#pragma mark - UISearchDisplayController delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
    NSString *searchStr = searchText;
    if(searchStr == nil || [searchStr isKindOfClass:[NSNull class]])
        searchStr = @"";
    if([_SearchConditionStr isEqual:searchStr])
        return;
    
    //    [pullTableView reloadData];
    self.tableview.pullTableIsRefreshing = YES;
    //    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    NSString *searchStr = _searchBar.text;
    if(searchStr == nil || [searchStr isKindOfClass:[NSNull class]])
        searchStr = @"";
    if([_SearchConditionStr isEqual:searchStr])
        return;
    
    //    [pullTableView reloadData];
    self.tableview.pullTableIsRefreshing = YES;
    //    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

@end

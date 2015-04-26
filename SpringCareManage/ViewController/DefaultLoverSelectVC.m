//
//  DefaultLoverSelectVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "DefaultLoverSelectVC.h"
#import "LoverSelectCell.h"
#import "EscortObjectListModel.h"

@interface DefaultLoverSelectVC ()
{
    EscortObjectListModel *_escortModel;
}

@property (nonatomic, strong) LoverSelectCell *prototypeCell;

@end

@implementation DefaultLoverSelectVC
@synthesize tableview = _tableview;
@synthesize DataList;
@synthesize prototypeCell;
@synthesize delegate;

- (id) initWithSelectLoverId:(NSString *) loverId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _defaultLoverId = loverId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"我的陪护";
    
    _escortModel = [[EscortObjectListModel alloc] init];
    self.DataList = [[NSMutableArray alloc] init];
    
    [self initSubviews];
    
    [self.DataList addObjectsFromArray:[EscortObjectListModel GetEscortObjectList]];
    if([self.DataList count] == 0){
        self.tableview.pullTableIsRefreshing = YES;
        __weak DefaultLoverSelectVC *weakSelf = self;
        [_escortModel RequsetEscortDataWithBlock:^(int code, id content) {
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
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    
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
    LoverSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[LoverSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    LoverInfoModel *data = [DataList objectAtIndex:indexPath.row];
    [cell SetContentDataWithModel:data];
    if([data.loverId isEqualToString:_defaultLoverId])
        cell.selectedBtn.selected = YES;
    else
        cell.selectedBtn.selected = NO;
    
    cell.selectedBtn.tag = indexPath.row + 100;
    
    [cell.selectedBtn addTarget:self action:@selector(doBtnSelectDefaultLover:) forControlEvents:UIControlEventTouchUpInside];
    
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
        prototypeCell = [[LoverSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LoverInfoModel *data = [DataList objectAtIndex:indexPath.row];
    LoverSelectCell *cell = (LoverSelectCell *)self.prototypeCell;
    [cell SetContentDataWithModel:data];
    
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
    _escortModel.pages = 0;
    self.tableview.pullTableIsRefreshing = YES;
    __weak DefaultLoverSelectVC *weakSelf = self;
    [_escortModel RequsetEscortDataWithBlock:^(int code, id content) {
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
    _escortModel.pages = _escortModel.pages + 1;
    self.tableview.pullTableIsLoadingMore = YES;
    __weak DefaultLoverSelectVC *weakSelf = self;
    [_escortModel RequsetEscortDataWithBlock:^(int code, id content) {
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

- (void) doBtnSelectDefaultLover:(UIButton *) sender
{
    if(sender.selected == YES)
        return;
    
    LoverInfoModel *data = [DataList objectAtIndex:sender.tag - 100];
    _defaultLoverId = data.loverId;
    [self.tableview reloadData];
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyCurrentSelectLoverModel:)]){
        
        [delegate NotifyCurrentSelectLoverModel:data];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

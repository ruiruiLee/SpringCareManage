//
//  MyEscortObjectVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyEscortObjectVC.h"
#import "EscortObjectCell.h"
#import "EscortObjectListModel.h"
#import "EditUserInfoVC.h"
#import "EditCellTypeData.h"

@interface MyEscortObjectVC ()<EditUserInfoVCDelegate>
{
    EscortObjectListModel *_escortModel;
}

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
    
    _escortModel = [[EscortObjectListModel alloc] init];
    self.DataList = [[NSMutableArray alloc] init];
    
    [self initSubviews];
    
//    [self.DataList addObjectsFromArray:[EscortObjectListModel GetEscortObjectList]];
//    if([self.DataList count] == 0){
    _escortModel.pages = 0;
        self.tableview.pullTableIsRefreshing = YES;
        __weak MyEscortObjectVC *weakSelf = self;
        [_escortModel RequsetEscortDataWithBlock:^(int code, id content) {
            if(code == 1){
                [weakSelf.DataList addObjectsFromArray:content];
                [weakSelf.tableview reloadData];
            }
            
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1];
        }];
//    }
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
    EscortObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[EscortObjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    LoverInfoModel *data = [DataList objectAtIndex:indexPath.row];
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
        prototypeCell = [[EscortObjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LoverInfoModel *data = [DataList objectAtIndex:indexPath.row];
    EscortObjectCell *cell = (EscortObjectCell *)self.prototypeCell;
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
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    NSArray *mArray = [self getContentArray];
    [vc setContentArray:mArray andmodel:[DataList objectAtIndex:indexPath.row]];//新增时为空
    vc.delegate = self;
    vc.NavTitle = @"编辑资料";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _escortModel.pages = 0;
    self.tableview.pullTableIsRefreshing = YES;
    __weak MyEscortObjectVC *weakSelf = self;
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
    __weak MyEscortObjectVC *weakSelf = self;
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

- (void) NotifyReloadData:(NSString*)loveID
{
    [self.tableview reloadData];
}

- (NSArray *)getContentArray
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    EditCellTypeData *data1 = [[EditCellTypeData alloc] init];
    data1.cellTitleName = @"地址";
    data1.cellType = EnumTypeAddress;
    [mArray addObject:data1];
    
    EditCellTypeData *data3 = [[EditCellTypeData alloc] init];
    data3.cellTitleName = @"姓名";
    data3.cellType = EnumTypeUserName;
    [mArray addObject:data3];
    
    EditCellTypeData *data4 = [[EditCellTypeData alloc] init];
    data4.cellTitleName = @"性别";
    data4.cellType = EnumTypeSex;
    [mArray addObject:data4];
    
    EditCellTypeData *data5 = [[EditCellTypeData alloc] init];
    data5.cellTitleName = @"年龄";
    data5.cellType = EnumTypeAge;
    [mArray addObject:data5];
    
    EditCellTypeData *data6 = [[EditCellTypeData alloc] init];
    data6.cellTitleName = @"电话";
    data6.cellType = EnumTypeMobile;
    [mArray addObject:data6];
    
    EditCellTypeData *data7 = [[EditCellTypeData alloc] init];
    data7.cellTitleName = @"身高";
    data7.cellType = EnumTypeHeight;
    [mArray addObject:data7];
    
    return mArray;
}

@end

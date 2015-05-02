//
//  WorkSummaryVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "WorkSummaryVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UserModel.h"
#import "EscortPublishCell.h"
#import "PublishInfoVC.h"

#import "DefaultLoverSelectVC.h"

@interface WorkSummaryVC ()<EscortPublishCellDelegate, DefaultLoverSelectDelegate>

@property (nonatomic, strong) EscortTimeTableCell *prototypeCell;

@end

@implementation WorkSummaryVC
@synthesize prototypeCell;
@synthesize tableView = tableView;
@synthesize dataList = _dataList;

- (void) SetHeaderInfoWithModel
{
    UserModel *model = [UserModel sharedUserInfo];
    OrderInfoModel *orderModel = model.userOrderInfo.orderModel;
    if(orderModel != nil){
        
        _defaultLover = orderModel.loverinfo;
        
        LoverInfoModel *loverInfo = orderModel.loverinfo;
        _lbName.text = loverInfo.name;
        [_btnAddr setTitle:loverInfo.addr forState:UIControlStateNormal];
        [_photoImgView sd_setImageWithURL:[NSURL URLWithString:loverInfo.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
        _lbAge.text = [NSString stringWithFormat:@"%d岁", loverInfo.age];
        _sex.image = ThemeImage([Util SexImagePathWith:[Util GetSexByName:loverInfo.sex]]);
        _lbPhone.text = loverInfo.phone;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnAddr, _sex, _lbAge, _btnMobile, _lbPhone, _imgvAddress);
        if([Util SexImagePathWith:[Util GetSexByName:_defaultLover.sex]] == nil){
            AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
        }
        else
            AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-10-[_sex]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
        [headerbg addConstraints:AttentionArray];
        
        pages = 0;
        totalPages = INT_MAX;
        self.tableView.pullTableIsRefreshing = YES;
        __weak WorkSummaryVC *weakSelf = self;
        [self RequestRecordList:^(int code, id content) {
            [weakSelf setContent];
            [weakSelf.tableView reloadData];
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
        }];
        
        [tableView setBackgroundView:nil];
        tableView.tableHeaderView.hidden=NO;
        isHasDefaultLover = YES;
    }
    else{
        
        isHasDefaultLover = NO;
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:TimeBackbroundImg];
        [tableView setBackgroundView:imageView];
        tableView.tableHeaderView.hidden=YES;
    }
}

- (void) setContent
{
    _lbName.text = _defaultLover.name;
    [_btnAddr setTitle:_defaultLover.addr forState:UIControlStateNormal];
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:_defaultLover.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
    _lbAge.text = [NSString stringWithFormat:@"%d岁", _defaultLover.age];
    _sex.image = ThemeImage([Util SexImagePathWith:[Util GetSexByName:_defaultLover.sex]]);
    //        [_btnMobile setTitle:loverInfo.phone forState:UIControlStateNormal];
    _lbPhone.text = _defaultLover.phone;
    
    [headerbg removeConstraints:AttentionArray];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnAddr, _sex, _lbAge, _btnMobile, _lbPhone, _imgvAddress);
    if([Util SexImagePathWith:[Util GetSexByName:_defaultLover.sex]] == nil){
        AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
    }
    else
        AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-10-[_sex]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
    [headerbg addConstraints:AttentionArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetHeaderInfoWithModel) name:User_DetailInfo_Get object:nil];
    pages = 0;
    _dataList = [[NSMutableArray alloc] init];
    self.NavigationBar.Title = @"护理日志";
    self.NavigationBar.btnLeft.hidden = YES;
    self.NavigationBar.btnRight.hidden = NO;
    
    tableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.ContentView addSubview:tableView];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.pullDelegate = self;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    
    [self creatHeadView];
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self SetHeaderInfoWithModel];
}

-(void)creatHeadView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    
    headerbg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:headerbg];
    headerbg.translatesAutoresizingMaskIntoConstraints = NO;
    headerbg.backgroundColor = _COLOR(233, 233, 233);
    
    _photoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_photoImgView];
    _photoImgView.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImgView.layer.cornerRadius = 36;
    _photoImgView.clipsToBounds = YES;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.font = _FONT(16);
    _lbName.textAlignment = NSTextAlignmentRight;
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    
    _imgvAddress = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_imgvAddress];
    _imgvAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _imgvAddress.image = ThemeImage(@"nurselistlocation");
    
    _btnAddr = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_btnAddr];
    _btnAddr.userInteractionEnabled = NO;
    _btnAddr.translatesAutoresizingMaskIntoConstraints = NO;
    _btnAddr.titleLabel.font = _FONT(14);
    [_btnAddr setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
//    [_btnAddr setImage:[UIImage imageNamed:@"nurselistlocation"] forState:UIControlStateNormal];
    
    _sex = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_sex];
    _sex.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbAge = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_lbAge];
    _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
    _lbAge.font = _FONT(14);
    _lbAge.textAlignment = NSTextAlignmentRight;
    _lbAge.textColor = _COLOR(0x99, 0x99, 0x99);
    
    _btnMobile = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_btnMobile];
    _btnMobile.userInteractionEnabled = NO;
    [_btnMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnMobile.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnMobile setImage:[UIImage imageNamed:@"orderdetailtel"] forState:UIControlStateNormal];
    _btnMobile.titleLabel.font = _FONT(14);
    
    _lbPhone = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_lbPhone];
    _lbPhone.translatesAutoresizingMaskIntoConstraints = NO;
    _lbPhone.font = _FONT(14);
    _lbPhone.textAlignment = NSTextAlignmentRight;
    _lbPhone.textColor = _COLOR(0x99, 0x99, 0x99);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnAddr, _sex, _lbAge, _btnMobile, _lbPhone, _imgvAddress);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerbg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerbg(100)]->=0-|" options:0 metrics:nil views:views]];
    
    AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-10-[_sex]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
    [headerbg addConstraints:AttentionArray];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_imgvAddress(15)]-2-[_btnAddr]->=20-|" options:0 metrics:nil views:views]];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_btnMobile]-2-[_lbPhone]->=20-|" options:0 metrics:nil views:views]];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_photoImgView(72)]-30-|" options:0 metrics:nil views:views]];
    
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbName(20)]-10-[_btnMobile(20)]-4-[_btnAddr(20)]-12-|" options:0 metrics:nil views:views]];
    
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_imgvAddress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnAddr attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_sex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_lbPhone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnMobile attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    DefaultLoverSelectVC *vc = [[DefaultLoverSelectVC alloc] initWithSelectLoverId:_defaultLover.loverId];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!isHasDefaultLover)
        return 0;
    
    return 2;
}

- (NSInteger) tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 80.f;
    EscortTimeDataModel *data = [_dataList objectAtIndex:indexPath.row];
    
    if(prototypeCell == nil){
        prototypeCell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
            [self replyContentWithId:itemId];
        }];
        prototypeCell.cellDelegate = self;
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGFloat cellHeight = [prototypeCell getContentHeightWithData:data];
    return cellHeight;
}

- (UITableViewCell*) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        EscortPublishCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell)
            cell = [[EscortPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.delegate = self;
        cell._lbTimeLine.backgroundColor = [UIColor clearColor];
        cell.lbToday.backgroundColor = [UIColor clearColor];
        cell.lbToday.textColor = _COLOR(0x22, 0x22, 0x22);
        return cell;
    }
    EscortTimeTableCell *cell = nil;
    cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
            [self replyContentWithId:itemId];
        }];
        cell.cellDelegate = self;
        cell._lbTimeLine.backgroundColor = [UIColor clearColor];
        cell._lbToday.backgroundColor = [UIColor clearColor];
        cell._lbToday.textColor = _COLOR(0x22, 0x22, 0x22);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell._btnReply.hidden = YES;
    }
    
    EscortTimeDataModel *data = [_dataList objectAtIndex:indexPath.row];
    [cell setContentData:data];
    
    return cell;
}

- (void) replyContentWithId:(NSString*)itemId
{
    
}

#pragma mark - 点中回复按钮
#pragma mark EscortTimeTableCellDelegate
-(void)commentButtonClick:(id)target ReplyName:(NSString*)ReplyName ReplyID:(NSString*)ReplyID{
    //    _replyContentModel = target.model;
    if([target isKindOfClass:[EscortTimeTableCell class]]){
        _replyContentModel = ((EscortTimeTableCell*)target)._model;
    }else
        _replyContentModel = nil;
    
    _reReplyPId = ReplyID;
    _reReplyName=ReplyName;
    if (_feedbackView == nil) {
        _feedbackView =[[feedbackView alloc ] initWithNibName:@"feedbackView" bundle:nil controlHidden:NO];
        _feedbackView.delegate=(id)self;
        [self.view addSubview:_feedbackView.view];
        
    }
    [_feedbackView.feedbackTextField becomeFirstResponder];
}

#pragma mark - feedbackViewDelegate
-(void)commitMessage:(NSString*)msg   //按确认按钮或者发送按钮实现消息发送
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:msg forKey:@"content"];
    //    [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"replyUserId"];
    if(_replyContentModel){
        [parmas setObject:_replyContentModel.itemId forKey:@"careTimeId"];
    }
    if(_reReplyPId){
        [parmas setObject:_reReplyPId forKey:@"orgUserId"];
    }
    
    [LCNetWorkBase postWithMethod:@"api/careTime/reply" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                if ([content objectForKey:@"code"] == nil) {
                    NSString *replyId = [content objectForKey:@"message"];
                    [self replyCompleteWithReplyId:replyId content:msg];
                }
            }
        }
    }];
}

#pragma  EscortTimeTableCellDelegate
- (void) ReloadTebleView{
    [tableView reloadData];
}

- (void) replyCompleteWithReplyId:(NSString *) replyId content:(NSString *) content
{
    NSMutableArray *replyinfos = (NSMutableArray*)_replyContentModel.replyInfos;
    EscortTimeReplyDataModel *replyModel = [[EscortTimeReplyDataModel alloc] init];
    replyModel.guId = replyId;
    
    //    replyModel.replyUserId = [UserModel sharedUserInfo].userId;
    //    replyModel.replyUserName = [UserModel sharedUserInfo].chineseName;
    if(_reReplyPId==nil){
        replyModel.content =[NSString stringWithFormat:@"%@:%@",@"我", content] ;
    }
    else{
        replyModel.content =[NSString stringWithFormat:@"我@%@:%@",_reReplyName,content]  ;
        replyModel.orgUserId = _reReplyPId;
    }
    [replyinfos addObject:replyModel];
    [tableView reloadData];
}


-(void)changeParentViewFram:(int)newHeight
{
    newHeight=newHeight>0?newHeight-20:newHeight+20;
    NSLog(@"%f",tableView.contentOffset.y);
    [tableView setContentOffset:CGPointMake(0.0,tableView.contentOffset.y+ newHeight) animated:YES];
    NSLog(@"%f",tableView.contentOffset.y);
}

#pragma mark - PullTableViewDelegate

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//
//    NSLog(@"%f",tableView.contentInset.bottom);
//}


- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    pages = 0;
//    [self loadDataList];
    [self RefreshDataList];
}

- (void) RefreshDataList
{
    UserModel *model = [UserModel sharedUserInfo];
    OrderInfoModel *orderModel = model.userOrderInfo.orderModel;
    if(orderModel.orderId != nil){
        __weak WorkSummaryVC *weakSelf = self;
        [self RequestRecordList:^(int code, id content) {
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
        }];
    }else{
        __weak WorkSummaryVC *weakSelf = self;
        [model LoadOrderInfo:^(int code, id content) {
            if(code == 1){
                OrderInfoModel *orderModel = model.userOrderInfo.orderModel;
                if(orderModel != nil){
                    [weakSelf.tableView setBackgroundView:nil];
                    weakSelf.tableView.tableHeaderView.hidden=NO;
                    isHasDefaultLover = YES;
                    
                    [self RequestRecordList:^(int code, id content) {
                        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
                    }];
                }else{
                    
                    isHasDefaultLover = NO;
                    
                    UIImageView *imageView=[[UIImageView alloc]initWithImage:TimeBackbroundImg];
                    [weakSelf.tableView setBackgroundView:imageView];
                    weakSelf.tableView.tableHeaderView.hidden=YES;
                    [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
                }
            }else
                [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
        }];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
    pages ++;
    __weak WorkSummaryVC *weakSelf = self;
    
    [self RequestRecordList:^(int code, id content) {
        [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2];
    }];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    NSLog(@"refreshTable");
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    NSLog(@"loadMoreDataToTable");
    self.tableView.pullTableIsLoadingMore = NO;
}

#pragma EscortPublishCellDelegate

- (void) NotifyToPublishEscort:(EscortPublishCell *) cell
{
    PublishInfoVC *vc = [[PublishInfoVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.NavTitle = @"发布护理日志";
    vc.contentType = EnumWorkSummary;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyCurrentSelectLoverModel:(LoverInfoModel *) model
{
    _defaultLover = model;
    
    [self setContent];
    
    [self pullTableViewDidTriggerRefresh:self.tableView];
}

- (void) RequestRecordList:(block) block
{
    UserModel *userinfo = [UserModel sharedUserInfo];
    if(userinfo.userId == nil){
        block(0, nil);
        return;
    }
    if(_defaultLover == nil){
        block(0, nil);
        return;
    }
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:userinfo.userId forKey:@"careId"];
    [parmas setObject:_defaultLover.loverId forKey:@"loverId"];
    [parmas setObject:[NSNumber numberWithInt:LIMIT_COUNT] forKey:@"limit"];
    [parmas setObject:[NSNumber numberWithInt:pages * LIMIT_COUNT] forKey:@"offset"];
    
    __weak WorkSummaryVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/record/list" Params:parmas Completion:^(int code, id content) {
        if(code){
            
            pages = [[content objectForKey:@"total"] integerValue];
            NSArray *array = [content objectForKey:@"rows"];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (int i = 0; i < [array count]; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                EscortTimeDataModel *model = [EscortTimeDataModel ObjectFromDictionary:dic];
                [result addObject:model];
            }
            if(pages == 0)
                [weakSelf.dataList removeAllObjects];
            
            [weakSelf.dataList addObjectsFromArray:result];
            if(block)
                block(1, nil);
        }
        if(block)
            block(0, nil);
    }];
}

@end

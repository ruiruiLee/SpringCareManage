//
//  EscortTimeVC.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UserModel.h"
#import "EscortPublishCell.h"
#import "PublishInfoVC.h"

#import "DefaultLoverSelectVC.h"

@interface EscortTimeVC ()<EscortPublishCellDelegate, DefaultLoverSelectDelegate>
{
    
}


@property (nonatomic, strong) EscortTimeTableCell *prototypeCell;

@end

@implementation EscortTimeVC
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
        RegisterInfoModel *registerInfo = orderModel.registerInfo;
        _lbName.text = loverInfo.name;
        [_btnAddr setTitle:loverInfo.addr forState:UIControlStateNormal];
        [_photoImgView sd_setImageWithURL:[NSURL URLWithString:loverInfo.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
        _lbAge.text = [NSString stringWithFormat:@"%d岁", loverInfo.age];
        _sex.image = ThemeImage([Util SexImagePathWith:[Util GetSexByName:loverInfo.sex]]);
        _lbMobile.text = registerInfo.phone;
        _relationName.text = [NSString stringWithFormat:@"联系人:%@", registerInfo.chineseName];
        
        [headerbg removeConstraints:AttentionArray];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnAddr, _sex, _lbAge, _relationName, _lbMobile, _btnRing);
        if([Util SexImagePathWith:[Util GetSexByName:_defaultLover.sex]] == nil){
            AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
        }
        else
            AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-10-[_sex]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
        [headerbg addConstraints:AttentionArray];
    }

    [self loadDataList];
}

- (void) setContent
{
    _lbName.text = _defaultLover.name;
    [_btnAddr setTitle:_defaultLover.addr forState:UIControlStateNormal];
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:_defaultLover.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
    _lbAge.text = [NSString stringWithFormat:@"%d岁", _defaultLover.age];
    _sex.image = ThemeImage([Util SexImagePathWith:[Util GetSexByName:_defaultLover.sex]]);
    _lbMobile.text = _defaultLover.registerPhone;
    _relationName.text = [NSString stringWithFormat:@"联系人:%@", _defaultLover.registerName];
    
    [headerbg removeConstraints:AttentionArray];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnAddr, _sex, _lbAge, _relationName, _lbMobile, _btnRing);
    if([Util SexImagePathWith:[Util GetSexByName:_defaultLover.sex]] == nil){
        AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
    }
    else
        AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-10-[_sex]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
    [headerbg addConstraints:AttentionArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetHeaderInfoWithModel) name:User_DetailInfo_Get object:nil];
    pages = 0;
    _dataList = [[NSMutableArray alloc] init];
    self.NavigationBar.Title = @"陪护时光";
    self.NavigationBar.btnLeft.hidden = YES;
    self.NavigationBar.alpha = 0.8;
    
    self.NavigationBar.btnRight.hidden = NO;
    self.NavigationBar.btnRight.backgroundColor = [UIColor redColor];

    tableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view insertSubview:tableView belowSubview:self.NavigationBar];
    self.ContentView.hidden = YES;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.pullDelegate = self;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    
    [self creatHeadView];
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] init];
}

-(void)loadDataList{

    UserModel *model = [UserModel sharedUserInfo];
    OrderInfoModel *orderModel = model.userOrderInfo.orderModel;
    if(orderModel != nil){
        __weak EscortTimeVC *weakSelf = self;
        self.tableView.pullTableIsRefreshing = YES;
        [EscortTimeDataModel LoadCareTimeListWithLoverId:_defaultLover.loverId Pages:pages block:^(int code, id content) {
            if([(NSArray*)content count]>0)
            {
                [weakSelf.dataList removeAllObjects];
                [weakSelf.dataList addObjectsFromArray:content];
                [weakSelf.tableView reloadData];
            }
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
        }];
    }
}

-(void)creatHeadView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    headerbg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:headerbg];
    headerbg.image = [UIImage imageNamed:@"relationheaderbg"];
    headerbg.translatesAutoresizingMaskIntoConstraints = NO;
    
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
    _lbName.textColor = _COLOR(0xff, 0xff, 0xff);
    
    _btnAddr = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_btnAddr];
    _btnAddr.userInteractionEnabled = NO;
    _btnAddr.translatesAutoresizingMaskIntoConstraints = NO;
    _btnAddr.titleLabel.font = _FONT(13);
    [_btnAddr setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    [_btnAddr setImage:[UIImage imageNamed:@"escortlocation"] forState:UIControlStateNormal];
    
    _sex = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_sex];
    _sex.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbAge = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_lbAge];
    _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
    _lbAge.font = _FONT(14);
    _lbAge.textAlignment = NSTextAlignmentRight;
    _lbAge.textColor = _COLOR(0xff, 0xff, 0xff);
    
    _relationName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_relationName];
    _relationName.translatesAutoresizingMaskIntoConstraints = NO;
    _relationName.font = _FONT(13);
    _relationName.textAlignment = NSTextAlignmentRight;
    _relationName.textColor = _COLOR(0xff, 0xff, 0xff);
    
    _lbMobile = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_lbMobile];
    _lbMobile.translatesAutoresizingMaskIntoConstraints = NO;
    _lbMobile.font = _FONT(13);
    _lbMobile.textAlignment = NSTextAlignmentRight;
    _lbMobile.textColor = _COLOR(0xff, 0xff, 0xff);
    
    _btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerbg addSubview:_btnRing];
    _btnRing.userInteractionEnabled = NO;
    _btnRing.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnRing setImage:[UIImage imageNamed:@"escortring"] forState:UIControlStateNormal];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnAddr, _sex, _lbAge, _relationName, _lbMobile, _btnRing);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerbg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerbg(182)]->=0-|" options:0 metrics:nil views:views]];
    
    AttentionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_lbName]-10-[_sex]-20-[_lbAge]->=20-|" options:0 metrics:nil views:views];
    [headerbg addConstraints:AttentionArray];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_btnAddr]->=20-|" options:0 metrics:nil views:views]];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgView(72)]-10-[_relationName]->=10-[_lbMobile]-4-[_btnRing]-20-|" options:0 metrics:nil views:views]];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_photoImgView(72)]-30-|" options:0 metrics:nil views:views]];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_btnRing]-32.5-|" options:0 metrics:nil views:views]];
    [headerbg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbName(20)]-0-[_btnAddr(30)]-0-[_relationName(16)]->=10-|" options:0 metrics:nil views:views]];
    
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_lbMobile attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_relationName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_sex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [headerbg addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self SetHeaderInfoWithModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    DefaultLoverSelectVC *vc = [[DefaultLoverSelectVC alloc] initWithSelectLoverId:_defaultLover.loverId];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self loadDataList];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
    pages ++;
    __weak EscortTimeVC *weakSelf = self;
    [EscortTimeDataModel LoadCareTimeListWithLoverId:_defaultLover.loverId Pages:pages block:^(int code, id content) {
        if([(NSArray*)content count]>0)
        {
            [weakSelf.dataList addObjectsFromArray:content];
            [weakSelf.tableView reloadData];
        }
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

#pragma mark -
#pragma mark EscortSendDelegate
- (void)delegetSendEnd:(Boolean)sucess
{
    if (sucess) {
        [self pullTableViewDidTriggerRefresh:self.tableView];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败请重新发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma EscortPublishCellDelegate

- (void) NotifyToPublishEscort:(EscortPublishCell *) cell
{
    PublishInfoVC *vc = [[PublishInfoVC alloc] initWithNibName:nil bundle:nil];
    vc.loverId = _defaultLover.loverId ;
    vc.contentType= EnumEscortTime;
    vc.hidesBottomBarWhenPushed = YES;
    vc.NavTitle = @"发布陪护时光";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyCurrentSelectLoverModel:(LoverInfoModel *) model
{
    _defaultLover = model;
    
    [self setContent];
    
    [self pullTableViewDidTriggerRefresh:self.tableView];
}

@end

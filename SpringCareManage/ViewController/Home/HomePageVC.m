//
//  HomePageVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HomePageVC.h"
#import "UIImageView+WebCache.h"
#import "MainTableCell.h"
#import "MyOrderListVC.h"
#import "MyEvaluateListVC.h"
#import "MyEscortObjectVC.h"
#import "MsgListVC.h"

#import "UserLoginVC.h"
#import "UserModel.h"
#import "UIView+MGBadgeView.h"

#import "UserCenterVC.h"

@interface HomePageVC ()
{
    BOOL _reloading;
    MyOrderListVC *_orderListVC;
}


@end

@implementation HomePageVC
@synthesize refreshView;
@synthesize tableview = _tableview;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//通知处理
- (void) NotifyDetailUserInfoGot:(NSNotification *) notify
{
    [self ValuationForView];
}

- (void) NotifyRefreshDefaultLover:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    LoverInfoModel *model = [dic objectForKey:@"model"];
    UserModel *userinfo = [UserModel sharedUserInfo];
    __weak HomePageVC *weakSelf = self;
    if([model.loverId isEqualToString:userinfo.userOrderInfo.orderModel.loverinfo.loverId]){
        userinfo.userOrderInfo.orderModel.loverinfo = model;
        [weakSelf ValuationForView];
        
    }
}

- (void) NotifyRefreshOrderInfo:(NSNotification *)notify
{
    [self egoRefreshTableHeaderDidTriggerRefresh:self.refreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    newCount = 0;
    subscribeCount = 0;
    treatPayCount = 0;
    evaluateCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyDetailUserInfoGot:) name:User_DetailInfo_Get object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyRefreshDefaultLover:) name:Notify_Lover_Moditify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyRefreshOrderInfo:) name:Notify_OrderInfo_Refresh object:nil];
    
    self.NavigationBar.Title = @"春风陪护";
    self.NavigationBar.btnLeft.hidden = YES;
    
    UIButton *btnSetting = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:btnSetting];
    btnSetting.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSetting addTarget:self action:@selector(NavRightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnSetting setImage:ThemeImage(@"setting") forState:UIControlStateNormal];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnSetting(40)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnSetting)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnSetting(40)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnSetting)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btnSetting attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btnSetting attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.NavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:-2]];
    
    [self initSubViews];
    
    if(![UserModel sharedUserInfo].isLogin){
        UserLoginVC *login = [[UserLoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else{
        [self ValuationForView];
    }
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    UserCenterVC *vc = [[UserCenterVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel*) createLabel:(UIFont*) font txtColor:(UIColor*)txtColor rootView:(UIView*)rootView
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [rootView addSubview:lb];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.textColor = txtColor;
    lb.font = font;
    lb.backgroundColor = [UIColor clearColor];
    return lb;
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -100, ScreenWidth, 100)];
    refreshView.delegate = self;
    [_tableview addSubview:refreshView];
    [refreshView refreshLastUpdatedDate];
    
    _reloading = NO;
    
    _tableview.tableHeaderView = [self createTableHeaderView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    if(_IPHONE_OS_VERSION_UNDER_7_0)
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    else
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-49-|" options:0 metrics:nil views:views]];
}

- (UIView*) createTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, INT_MAX)];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_bgView];
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    _bgView.backgroundColor = _COLOR(233, 233, 233);
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];//头像
    [_bgView addSubview:_photoImage];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImage.clipsToBounds = YES;
    _photoImage.layer.cornerRadius = 41;
    _photoImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _lbName = [self createLabel:_FONT(16) txtColor:_COLOR(0x22, 0x22, 0x22) rootView:_bgView];//姓名
    
    _btnCert =[[UIButton alloc] initWithFrame:CGRectZero] ;//证书
    [_bgView addSubview:_btnCert];
    _btnCert.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnCert setImage:[UIImage imageNamed:@"certLogo"] forState:UIControlStateNormal];
    [_btnCert addTarget:self action:@selector(lookImageAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnCert.hidden = YES;
    
    _lbMobile = [self createLabel:_FONT(13) txtColor:_COLOR(0x22, 0x22, 0x22) rootView:_bgView];//电话
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];//年龄，护龄信息
    [_bgView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnInfo setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnInfo.titleLabel.font = _FONT(13);
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    _btnInfo.userInteractionEnabled = NO;
    
    _workStatus = [[SwitchView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_workStatus];
    _workStatus.translatesAutoresizingMaskIntoConstraints = NO;
    
    _detailInfo = [self createLabel:_FONT(12) txtColor:_COLOR(0x99, 0x99, 0x99) rootView:_bgView];//详细信息
    _detailInfo.numberOfLines = 0;
    _detailInfo.preferredMaxLayoutWidth = ScreenWidth - 50;
    
    _btnNew = [[UIButton alloc] initWithFrame:CGRectZero];//新订单
    [headerView addSubview:_btnNew];
    _btnNew.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnNew setImage:[UIImage imageNamed:@"newOrder"] forState:UIControlStateNormal];
    _lbNew = [self createLabel:_FONT(13) txtColor:_COLOR(0x66, 0x66, 0x66) rootView:headerView];
    _lbNew.text = @"新订单";
    [_btnNew addTarget:self action:@selector(btnClickedToLoadOrders:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSubscribe = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnSubscribe];
    _btnSubscribe.translatesAutoresizingMaskIntoConstraints = NO;//已预约
    [_btnSubscribe setImage:[UIImage imageNamed:@"subscribeOrder"] forState:UIControlStateNormal];
    _lbSubscribe = [self createLabel:_FONT(13) txtColor:_COLOR(0x66, 0x66, 0x66) rootView:headerView];
    _lbSubscribe.text = @"已预约";
    [_btnSubscribe addTarget:self action:@selector(btnClickedToLoadOrders:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnTreatPay = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnTreatPay];
    _btnTreatPay.translatesAutoresizingMaskIntoConstraints = NO;//待付款
    [_btnTreatPay setImage:[UIImage imageNamed:@"treatPay"] forState:UIControlStateNormal];
    _lbTreatPay = [self createLabel:_FONT(13) txtColor:_COLOR(0x66, 0x66, 0x66) rootView:headerView];
    _lbTreatPay.text = @"待付款";
    [_btnTreatPay addTarget:self action:@selector(btnClickedToLoadOrders:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnEvaluate = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnEvaluate];
    _btnEvaluate.translatesAutoresizingMaskIntoConstraints = NO;;//待评价
    [_btnEvaluate setImage:[UIImage imageNamed:@"evaluate"] forState:UIControlStateNormal];
    _lbEvaluate = [self createLabel:_FONT(13) txtColor:_COLOR(0x66, 0x66, 0x66) rootView:headerView];
    _lbEvaluate.text = @"待评价";
    [_btnEvaluate addTarget:self action:@selector(btnClickedToLoadOrders:) forControlEvents:UIControlEventTouchUpInside];
    
    _OrderInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_OrderInfoView];
    _OrderInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _orderTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_orderTitleView];
    _orderTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    _orderTitleView.backgroundColor = _COLOR(233, 233, 233);
    
    _btnOrderOnDoing = [[UIButton alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_btnOrderOnDoing];
    _btnOrderOnDoing.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnOrderOnDoing setTitleColor:_COLOR(0xec, 0x5a, 0x4d) forState:UIControlStateNormal];
    _btnOrderOnDoing.titleLabel.font = _FONT(15);
    [_btnOrderOnDoing setTitle:@"服务中的订单" forState:UIControlStateNormal];
    [_btnOrderOnDoing setImage:[UIImage imageNamed:@"placeordered"] forState:UIControlStateNormal];
    _btnOrderOnDoing.userInteractionEnabled = NO;
    _btnOrderOnDoing.backgroundColor = [UIColor whiteColor];
    
    _line2 = [self createLabel:_FONT(13) txtColor:SeparatorLineColor rootView:_OrderInfoView];
    _line2.backgroundColor = SeparatorLineColor;
    
    _lbCareType = [self createLabel:_FONT(16) txtColor:_COLOR(0x3d, 0x3d, 0x3d) rootView:_OrderInfoView];
    
    _lbTotalValue = [self createLabel:_FONT_B(20) txtColor:_COLOR(0x99, 0x99, 0x99) rootView:_OrderInfoView];
    _lbRealValue = [self createLabel:_FONT_B(20) txtColor:_COLOR(0x3d, 0x3d, 0x3d) rootView:_OrderInfoView];
    
    _imgDay = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_imgDay];
    _imgDay.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbDetailText = [self createLabel:_FONT(13) txtColor:_COLOR(0xc2, 0xc2, 0xc2) rootView:_OrderInfoView];
    
    _line3 = [self createLabel:_FONT(13) txtColor:SeparatorLineColor rootView:_OrderInfoView];
    _line3.backgroundColor = SeparatorLineColor;
    
    _btnCustomerMobile = [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_btnCustomerMobile];
    _btnCustomerMobile.translatesAutoresizingMaskIntoConstraints = NO;
    _btnCustomerMobile.textColor = _COLOR(0xc2, 0xc2, 0xc2);
    _btnCustomerMobile.font = _FONT(15);
    _btnCustomerMobile.userInteractionEnabled = NO;
    _btnCustomerMobile.backgroundColor = [UIColor clearColor];
    
    _btnAddress = [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_btnAddress];
    _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _btnAddress.textColor = _COLOR(0x3d, 0x3d, 0x3d);
    _btnAddress.font = _FONT(14);
    _btnAddress.numberOfLines = 0;
    _btnAddress.preferredMaxLayoutWidth = ScreenWidth - 58;
    
    _lbOtherInfo = [self createLabel:_FONT(15) txtColor:_COLOR(0x3d, 0x3d, 0x3d) rootView:_OrderInfoView];
    
    _imgvAddress = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_imgvAddress];
    _imgvAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _imgvAddress.image = ThemeImage(@"locator");
    
    _imgvLover = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_imgvLover];
    _imgvLover.translatesAutoresizingMaskIntoConstraints = NO;
    _imgvLover.image = ThemeImage(@"loverLogo");
    
    _lbLoverInfo = [self createLabel:_FONT(15) txtColor:_COLOR(0x3d, 0x3d, 0x3d) rootView:_OrderInfoView];
    
    _imgvLoverSex = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_imgvLoverSex];
    _imgvLoverSex.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV1 = [[UIView alloc] initWithFrame:CGRectZero];
    intervalV1.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:intervalV1];
    
    intervalV2 = [[UIView alloc] initWithFrame:CGRectZero];
    intervalV2.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:intervalV2];
    
    intervalV3 = [[UIView alloc] initWithFrame:CGRectZero];
    intervalV3.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:intervalV3];
    
    _SepLine = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_SepLine];
    _SepLine.translatesAutoresizingMaskIntoConstraints = NO;
    _SepLine.backgroundColor = _COLOR(233, 233, 233);
    
    btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:btnRing];
    btnRing.translatesAutoresizingMaskIntoConstraints = NO;
    [btnRing setImage:ThemeImage(@"orderdetailtel") forState:UIControlStateNormal];
    [btnRing addTarget:self action:@selector(btnRingClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _couponInfoView = [[CouponLogoView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_couponInfoView];
    _couponInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self createAutoLayoutConstraintsForHeader:headerView];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
    
    return headerView;
}

- (void) createAutoLayoutConstraintsForHeader:(UIView*)rootview
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImage, _lbName, _btnCert, _lbMobile, _btnInfo, _detailInfo, _btnNew, _lbNew, _btnSubscribe, _lbSubscribe, _btnTreatPay, _lbTreatPay, _btnEvaluate, _lbEvaluate, _btnOrderOnDoing, _line2, _lbCareType, _imgDay, _lbDetailText, _btnCustomerMobile, _btnAddress, _line3, intervalV1, intervalV2, intervalV3, _SepLine, _OrderInfoView, _imgvAddress, _lbLoverInfo, _imgvLoverSex, btnRing, _workStatus, _orderTitleView, _lbOtherInfo, _lbRealValue, _imgvLover, _couponInfoView, _lbTotalValue);
    //H
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_orderTitleView]-0-|" options:0 metrics:nil views:views]];
    
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_lbName]->=10-[_btnCert]-32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage]-10-[_lbMobile]->=10-[_btnCert]-32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage]-10-[_btnInfo]->=32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage]-10-[_workStatus(120)]->=32-|" options:0 metrics:nil views:views]];
    
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-26-[_btnNew]-0-[intervalV1]-0-[_btnSubscribe]-0-[intervalV2]-0-[_btnTreatPay]-0-[intervalV3]-0-[_btnEvaluate]-26-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnOrderOnDoing]->=0-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line2]-18-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_lbCareType]->=0-[_lbRealValue]-18-|" options:0 metrics:nil views:views]];
//    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_lbTotalValue]-10-[_lbCouponValue]->=18-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRealValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbCareType attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_lbCouponValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTotalValue attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgDay]-6-[_lbDetailText]->=18-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnCustomerMobile]->=4-[btnRing(32)]-10-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnRing(32)]->=0-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgvAddress(16)]-6-[_btnAddress]->=18-|" options:0 metrics:nil views:views]];
    loverInfoConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgvLover]-6-[_lbLoverInfo]-10-[_imgvLoverSex(18)]-10-[_lbOtherInfo]->=22-|" options:0 metrics:nil views:views];
    [_OrderInfoView addConstraints:loverInfoConstraints];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTotalValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_couponInfoView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnCustomerMobile attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAddress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgvAddress attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_imgvLoverSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbLoverInfo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_lbOtherInfo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbLoverInfo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_imgvLover attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbLoverInfo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_OrderInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_couponInfoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnOrderOnDoing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_OrderInfoView]-0-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line3]-18-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_SepLine]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbNew attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbSubscribe attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnSubscribe attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbTreatPay attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnTreatPay attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbEvaluate attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnEvaluate attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    //V
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_photoImage(82)]-6-[_workStatus(36)]->=6-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbName]-4-[_lbMobile]-8-[_btnInfo]-10-[_workStatus]-10-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_btnCert]->=0-|" options:0 metrics:nil views:views]];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_OrderInfoView]-0-[_SepLine(12)]-0-|" options:0 metrics:nil views:views];
    [rootview addConstraints:constraints];
    
    couponConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_orderTitleView(12)]-10-[_btnOrderOnDoing]-10-[_line2(0.6)]-14-[_lbCareType]-8-[_lbDetailText]-8-[_line3(0.6)]-10-[_lbLoverInfo]-10-[_imgvAddress]-10-[_btnCustomerMobile]-10-|" options:0 metrics:nil views:views];
    [_OrderInfoView addConstraints:couponConstraints];
    
    coupons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=22-[_lbTotalValue]-4-[_couponInfoView]-19-|" options:0 metrics:nil views:views];
    [_OrderInfoView addConstraints:coupons];
    
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_imgDay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_btnSubscribe attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_btnTreatPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_btnEvaluate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbSubscribe attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbTreatPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbEvaluate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) ValuationForView
{
    UIView *headerView = _tableview.tableHeaderView;
    headerView.frame = CGRectMake(0, 0, ScreenWidth, INT_MAX);
    
    UserModel *userInfo = [UserModel sharedUserInfo];
    _lbName.text = userInfo.chineseName;
    
    _lbMobile.text = userInfo.userName;
    
    [_workStatus SetCurrentWorkStatus:userInfo.workStatus];
    
    if(userInfo.certList == nil || [userInfo.certList count] == 0){
        _btnCert.hidden = YES;
    }else
        _btnCert.hidden = NO;
    
    _btnTreatPay.badgeView.badgeValue = 0;
    _btnNew.badgeView.badgeValue = 0;
    _btnSubscribe.badgeView.badgeValue = 0;
    _btnEvaluate.badgeView.badgeValue = 0;
    
    if(userInfo.userOrderInfo != nil){
        UserDetailModel *detail = userInfo.userOrderInfo;
        if(newCount != detail.newCount){
            if(_orderListVC.orderType == EnumOrderNew){
                [_orderListVC pullTableViewDidTriggerRefresh:_orderListVC.tableview];
                newFlag = NO;
            }
            else
                newFlag = YES;
        }
        else
            newFlag = NO;
        if(subscribeCount != detail.confirmedCount){
            if(_orderListVC.orderType == EnumOrderSubscribe){
                [_orderListVC pullTableViewDidTriggerRefresh:_orderListVC.tableview];
                subscribeFlag = NO;
            }else
                subscribeFlag = YES;
        }
        else
            subscribeFlag = NO;
        if(treatPayCount != detail.waitPayCount){
            if(_orderListVC.orderType == EnumOrderTreatPay){
                [_orderListVC pullTableViewDidTriggerRefresh:_orderListVC.tableview];
                treatPayFlag = NO;
            }
            else
                treatPayFlag = YES;
        }
        else
            treatPayFlag = NO;
        if(evaluateCount != detail.waitCommentCount){
            if(_orderListVC.orderType == EnumOrderEvaluate){
                [_orderListVC pullTableViewDidTriggerRefresh:_orderListVC.tableview];
                evaluateFlag = NO;
            }else
                evaluateFlag = YES;
        }
        else
            evaluateFlag = NO;
        
        newCount = detail.newCount;
        subscribeCount = detail.confirmedCount;
        treatPayCount = detail.waitPayCount;
        evaluateCount = detail.waitCommentCount;
        
        if(detail.newCount > 0)
            _btnNew.badgeView.badgeValue = detail.newCount;
        if(detail.confirmedCount > 0)
            _btnSubscribe.badgeView.badgeValue = detail.confirmedCount;
        if(detail.waitPayCount > 0)
            _btnTreatPay.badgeView.badgeValue = detail.waitPayCount;
        if(detail.waitCommentCount > 0)
            _btnEvaluate.badgeView.badgeValue = detail.waitCommentCount;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %d岁 护龄%d年", userInfo.birthAddr, [Util getAgeWithBirthday:userInfo.birthDay], [Util getAgeWithBirthday:userInfo.beginCareDate]];
    [_btnInfo setTitle:title forState:UIControlStateNormal];
    
    UserSex sex = [Util GetSexByName:userInfo.sex];
    NSString *placeholderImage = @"nurselistfemale";
    if(sex == EnumMale)
        placeholderImage = @"nurselistmale";
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:userInfo.headerFile] placeholderImage:[UIImage imageNamed:placeholderImage]];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImage, _lbName, _btnCert, _lbMobile, _btnInfo, _detailInfo, _btnNew, _lbNew, _btnSubscribe, _lbSubscribe, _btnTreatPay, _lbTreatPay, _btnEvaluate, _lbEvaluate, _btnOrderOnDoing, _line2, _lbCareType, _imgDay, _lbDetailText, _btnCustomerMobile, _btnAddress, _line3, intervalV1, intervalV2, intervalV3, _SepLine, _OrderInfoView, _imgvAddress, _lbLoverInfo, _imgvLoverSex, btnRing, _workStatus, _orderTitleView, _lbOtherInfo, _lbRealValue, _imgvLover, _couponInfoView, _lbTotalValue);
    
    [headerView removeConstraints:constraints];
    if(userInfo.userOrderInfo.orderModel != nil){
        
        NSString *value = [NSString stringWithFormat:@"￥%d  × %@", (int)userInfo.userOrderInfo.orderModel.unitPrice, userInfo.userOrderInfo.orderModel.orderCountStr];
        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc]initWithString:value];
        NSRange range1 = [value rangeOfString:[NSString stringWithFormat:@"  × %@", userInfo.userOrderInfo.orderModel.orderCountStr]];
        [attString1 addAttribute:NSFontAttributeName value:_FONT(12) range:range1];
        _lbRealValue.attributedText = attString1;
    
        if(userInfo.userOrderInfo.orderModel.couponsAmount > 0){
            _lbTotalValue.hidden = NO;
            _couponInfoView.hidden = NO;
        }else{
            _lbTotalValue.hidden = YES;
            _couponInfoView.hidden = YES;
        }
        

        _lbCareType.text = [NSString stringWithFormat:@"%@(%@)", userInfo.userOrderInfo.orderModel.productInfo.name, userInfo.userOrderInfo.orderModel.productInfo.typeName];
        
        NSMutableAttributedString *totalValue = [self AttributedStringFromString:[NSString stringWithFormat:@"实付:￥%.0f", userInfo.userOrderInfo.orderModel.realyTotalPrice] subString:[NSString stringWithFormat:@"￥%.0f", userInfo.userOrderInfo.orderModel.realyTotalPrice]];
        [totalValue addAttribute:NSFontAttributeName value:_FONT(12) range:NSMakeRange(0, 3)];
        _lbTotalValue.attributedText = totalValue;//
        [_couponInfoView SetCouponValue:userInfo.userOrderInfo.orderModel.couponsAmount];
        
        _btnAddress.text = userInfo.userOrderInfo.orderModel.loverinfo.addr;
        
        if(userInfo.userOrderInfo.orderModel.registerInfo.chineseName != nil && [userInfo.userOrderInfo.orderModel.registerInfo.chineseName length] > 0)
            _btnCustomerMobile.text = [NSString stringWithFormat:@"下单人：%@   %@", userInfo.userOrderInfo.orderModel.registerInfo.chineseName, userInfo.userOrderInfo.orderModel.registerInfo.phone];
        else{
            _btnCustomerMobile.text = [NSString stringWithFormat:@"下单人：  %@", userInfo.userOrderInfo.orderModel.registerInfo.phone];
        }
        
        _lbDetailText.text = [Util GetOrderServiceTime:[Util convertDateFromDateString:userInfo.userOrderInfo.orderModel.beginDate] enddate:[Util convertDateFromDateString:userInfo.userOrderInfo.orderModel.endDate] datetype:userInfo.userOrderInfo.orderModel.dateType];
        
        _imgDay.image = [UIImage imageNamed:@"daytime"];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_OrderInfoView]-0-[_SepLine(12)]-0-|" options:0 metrics:nil views:views];
        [headerView addConstraints:constraints];
        _OrderInfoView.hidden = NO;
        _btnOrderOnDoing.hidden = NO;
        _orderTitleView.hidden = NO;
        
    }else{
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_SepLine(12)]-0-|" options:0 metrics:nil views:views];
        [headerView addConstraints:constraints];
        _OrderInfoView.hidden = YES;
        _btnOrderOnDoing.hidden = YES;
        _orderTitleView.hidden = YES;
    }
    
    NSString *age = @"";
    if(userInfo.userOrderInfo.orderModel.loverinfo.age > 0)
        age = [NSString stringWithFormat:@"%ld岁", userInfo.userOrderInfo.orderModel.loverinfo.age];
    else
        age = @"年龄";
    NSString *height = @"";
    if(userInfo.userOrderInfo.orderModel.loverinfo.height != nil)
        height = [NSString stringWithFormat:@"%@cm", userInfo.userOrderInfo.orderModel.loverinfo.height];
    else
        height = @"身高";
    
    NSString *name = @"";
    if(userInfo.userOrderInfo.orderModel.loverinfo.name != nil && [userInfo.userOrderInfo.orderModel.loverinfo.name length] > 0)
        name = userInfo.userOrderInfo.orderModel.loverinfo.name;
    else
        name = @"姓名";
    
    _lbLoverInfo.text = name;
    _lbOtherInfo.text = [NSString stringWithFormat:@"%@  %@",  age, height];
    
    if([Util GetSexByName:userInfo.userOrderInfo.orderModel.loverinfo.sex] == EnumMale)
        _imgvLoverSex.image = ThemeImage(@"mail");
    else if ([Util GetSexByName:userInfo.userOrderInfo.orderModel.loverinfo.sex] == EnumFemale)
        _imgvLoverSex.image = ThemeImage(@"femail");
    else
        _imgvLoverSex.image = nil;
    
    [_OrderInfoView removeConstraints:loverInfoConstraints];
    if(_imgvLoverSex.image == nil){
        loverInfoConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgvLover]-6-[_lbLoverInfo]-10-[_lbOtherInfo]->=18-|" options:0 metrics:nil views:views];
        [_OrderInfoView addConstraints:loverInfoConstraints];
    }else{
        loverInfoConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgvLover]-6-[_lbLoverInfo]-10-[_imgvLoverSex(18)]-10-[_lbOtherInfo]->=18-|" options:0 metrics:nil views:views];
        [_OrderInfoView addConstraints:loverInfoConstraints];
    }
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    
    _tableview.tableHeaderView = headerView;
}

- (void)btnRingClicked{
    UserModel *userInfo = [UserModel sharedUserInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?" message:userInfo.userOrderInfo.orderModel.registerInfo.phone delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView setTag:12];
    [alertView show];
}

#pragma alertdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UserModel *userInfo = [UserModel sharedUserInfo];
    if ([alertView tag] == 12) {
        if (buttonIndex==0) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",userInfo.userOrderInfo.orderModel.registerInfo.phone]];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[MainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.lbTitle.text = @"我的订单";
            cell.photoImgV.image = [UIImage imageNamed:@"allOrder"];
        }
            break;
        case 1:
        {
            cell.lbTitle.text = @"我的评价";
            cell.photoImgV.image = [UIImage imageNamed:@"myEvaluate"];
        }
            break;
//        case 2:
//        {
//            cell.lbTitle.text = @"我的陪护";
//            cell.photoImgV.image = [UIImage imageNamed:@"MyEscort"];
//        }
//            break;
        case 2:
        {
            cell.lbTitle.text = @"我的消息";
            cell.photoImgV.image = [UIImage imageNamed:@"Msg"];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        MyOrderListVC *vc = [[MyOrderListVC alloc] initWithOrderType:EnumOrderAll LoadFlag:NO];
        vc.hidesBottomBarWhenPushed = YES;
        vc.NavTitle = @"我的订单";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        MyEvaluateListVC *vc = [[MyEvaluateListVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }/*else if (indexPath.row == 2){
        MyEscortObjectVC *vc = [[MyEscortObjectVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }*/else{
        MsgListVC *vc = [[MsgListVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma ACTIONS

- (void) btnClickedToLoadOrders:(UIButton*) sender
{
    OrderListType type = EnumOrderAll;
    BOOL flag = YES;
    if(sender == _btnNew){
        type = EnumOrderNew;
        flag = newFlag;
        newFlag = NO;
    }
    else if (sender == _btnSubscribe){
        type = EnumOrderSubscribe;
        flag = subscribeFlag;
        subscribeFlag = NO;
    }
    else if (sender == _btnTreatPay){
        type = EnumOrderTreatPay;
        flag = treatPayFlag;
        treatPayFlag = NO;
    }
    else{
        type = EnumOrderEvaluate;
        flag = evaluateFlag;
        evaluateFlag = NO;
    }
    _orderListVC = [[MyOrderListVC alloc] initWithOrderType:type LoadFlag:flag];
    _orderListVC.hidesBottomBarWhenPushed = YES;
    if(sender == _btnNew)
        _orderListVC.NavTitle = @"新订单";
    else if (sender == _btnSubscribe)
        _orderListVC.NavTitle = @"已预约订单";
    else if (sender == _btnTreatPay)
        _orderListVC.NavTitle = @"待付款订单";
    else
        _orderListVC.NavTitle = @"待评价订单";
    [self.navigationController pushViewController:_orderListVC animated:YES];
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
    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableview];
    
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
    UserModel *userinfo = [UserModel sharedUserInfo];
    __weak HomePageVC *weakSelf = self;
    [userinfo LoadOrderInfo:^(int code, id content) {
        [weakSelf performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
    }];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

-(void)lookImageAction:(UIButton *)sender
{
    NSLog(@"lookImageAction");
    _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    [_imageList addImagesURL:[UserModel sharedUserInfo].certList withSmallImage:nil];
    [self.view.window addSubview:_imageList];
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
}

- (NSMutableAttributedString *)AttributedStringFromString:(NSString*)string subString:(NSString *)subString
{
    NSString *UnitPrice = string;//@"单价：¥300.00（24h） x 1天";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:subString];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    //    [attString addAttribute:NSFontAttributeName value:_FONT(22) range:range];
    return attString;
}

- (NSMutableAttributedString *)AttributedTitleFromString:(NSString*)string title:(NSString *)title
{
    NSString *UnitPrice = string;//@"单价：¥300.00（24h） x 1天";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:title];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    return attString;
}

@end

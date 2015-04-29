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

#import "UserLoginVC.h"
#import "UserModel.h"

@interface HomePageVC ()



@end

@implementation HomePageVC

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//通知处理
- (void) NotifyDetailUserInfoGot:(NSNotification *) notify
{
    [self ValuationForView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyDetailUserInfoGot:) name:User_DetailInfo_Get object:nil];
    
    self.NavigationBar.Title = @"春风陪护";
    self.NavigationBar.btnLeft.hidden = YES;
    
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

- (UILabel*) createLabel:(UIFont*) font txtColor:(UIColor*)txtColor rootView:(UIView*)rootView
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [rootView addSubview:lb];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.textColor = txtColor;
    lb.font = font;
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
    
    _tableview.tableHeaderView = [self createTableHeaderView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-49-|" options:0 metrics:nil views:views]];
}

- (UIView*) createTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1000)];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_bgView];
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    _bgView.backgroundColor = _COLOR(233, 233, 233);
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];//头像
    [_bgView addSubview:_photoImage];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbName = [self createLabel:_FONT(16) txtColor:_COLOR(0x22, 0x22, 0x22) rootView:_bgView];//姓名
    
    _btnCert =[[UIButton alloc] initWithFrame:CGRectZero] ;//证书
    [_bgView addSubview:_btnCert];
    _btnCert.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnCert setImage:[UIImage imageNamed:@"certLogo"] forState:UIControlStateNormal];
    
    _lbMobile = [self createLabel:_FONT(13) txtColor:_COLOR(0x22, 0x22, 0x22) rootView:_bgView];//电话
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];//年龄，护龄信息
    [_bgView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnInfo setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnInfo.titleLabel.font = _FONT(13);
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    _btnInfo.userInteractionEnabled = NO;
    
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
    
    _line1 = [self createLabel:_FONT(13) txtColor:SeparatorLineColor rootView:headerView];
    _line1.backgroundColor = SeparatorLineColor;
    
    _btnOrderOnDoing = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnOrderOnDoing];
    _btnOrderOnDoing.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnOrderOnDoing setTitleColor:_COLOR(0xec, 0x5a, 0x4d) forState:UIControlStateNormal];
    _btnOrderOnDoing.titleLabel.font = _FONT(13);
    [_btnOrderOnDoing setTitle:@"进行中的订单" forState:UIControlStateNormal];
    [_btnOrderOnDoing setImage:[UIImage imageNamed:@"placeordered"] forState:UIControlStateNormal];
    _btnOrderOnDoing.userInteractionEnabled = NO;
    
    _line2 = [self createLabel:_FONT(13) txtColor:SeparatorLineColor rootView:headerView];
    _line2.backgroundColor = SeparatorLineColor;
    
    _OrderInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_OrderInfoView];
    _OrderInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbCareType = [self createLabel:_FONT(13) txtColor:_COLOR(0x99, 0x99, 0x99) rootView:_OrderInfoView];
    
    _imgDay = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_imgDay];
    _imgDay.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imgNight = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_imgNight];
    _imgNight.translatesAutoresizingMaskIntoConstraints = NO;
    _lbDetailText = [self createLabel:_FONT(13) txtColor:_COLOR(0x99, 0x99, 0x99) rootView:_OrderInfoView];
    
    _line3 = [self createLabel:_FONT(13) txtColor:SeparatorLineColor rootView:_OrderInfoView];
    _line3.backgroundColor = SeparatorLineColor;
    
    _btnCustomerMobile = [[UIButton alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_btnCustomerMobile];
    _btnCustomerMobile.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnCustomerMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnCustomerMobile.titleLabel.font = _FONT(13);
    [_btnCustomerMobile setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    _btnCustomerMobile.userInteractionEnabled = NO;
    
    _btnAddress = [[UIButton alloc] initWithFrame:CGRectZero];
    [_OrderInfoView addSubview:_btnAddress];
    _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnAddress setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnAddress.titleLabel.font = _FONT(14);
    [_btnAddress setImage:[UIImage imageNamed:@"locator"] forState:UIControlStateNormal];
    
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
    
    [self createAutoLayoutConstraintsForHeader:headerView];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
    
    return headerView;
}

- (void) createAutoLayoutConstraintsForHeader:(UIView*)rootview
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImage, _lbName, _btnCert, _lbMobile, _btnInfo, _detailInfo, _btnNew, _lbNew, _btnSubscribe, _lbSubscribe, _btnTreatPay, _lbTreatPay, _btnEvaluate, _lbEvaluate, _line1, _btnOrderOnDoing, _line2, _lbCareType, _imgDay, _imgNight, _lbDetailText, _btnCustomerMobile, _btnAddress, _line3, intervalV1, intervalV2, intervalV3, _SepLine, _OrderInfoView);
    //H
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_lbName]->=10-[_btnCert]-32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_lbMobile]->=10-[_btnCert]-32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_btnInfo]->=32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_detailInfo]->=32-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-26-[_btnNew]-0-[intervalV1]-0-[_btnSubscribe]-0-[intervalV2]-0-[_btnTreatPay]-0-[intervalV3]-0-[_btnEvaluate]-26-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line1]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnOrderOnDoing]->=0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line2]-0-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_lbCareType]->=18-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgDay]-0-[_imgNight]-0-[_lbDetailText]->=18-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnCustomerMobile]->=18-|" options:0 metrics:nil views:views]];
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnAddress]->=18-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_OrderInfoView]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line3]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_SepLine]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbNew attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbSubscribe attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnSubscribe attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbTreatPay attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnTreatPay attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbEvaluate attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnEvaluate attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    //V
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_photoImage(82)]-6-[_detailInfo]->=6-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbName]-4-[_lbMobile]-8-[_btnInfo]-10-[_detailInfo]-10-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_btnCert]->=0-|" options:0 metrics:nil views:views]];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_line1(1)]-4-[_btnOrderOnDoing]-4-[_line2(1)]-0-[_OrderInfoView]-0-[_SepLine(7)]-0-|" options:0 metrics:nil views:views];
    [rootview addConstraints:constraints];
    
    [_OrderInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lbCareType]-8-[_lbDetailText]-10-[_line3(1)]-10-[_btnCustomerMobile]-10-[_btnAddress]-10-|" options:0 metrics:nil views:views]];
    
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_imgDay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_imgNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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

/*
- (void) createAutoLayoutConstraintsForHeader:(UIView*)rootview
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImage, _lbName, _btnCert, _lbMobile, _btnInfo, _detailInfo, _btnNew, _lbNew, _btnSubscribe, _lbSubscribe, _btnTreatPay, _lbTreatPay, _btnEvaluate, _lbEvaluate, _line1, _btnOrderOnDoing, _line2, _lbCareType, _imgDay, _imgNight, _lbDetailText, _btnCustomerMobile, _btnAddress, _line3, intervalV1, intervalV2, intervalV3, _SepLine, _OrderInfoView);
    //H
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_lbName]->=10-[_btnCert]-32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_lbMobile]->=10-[_btnCert]-32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImage(82)]-10-[_btnInfo]->=32-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_detailInfo]->=32-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-26-[_btnNew]-0-[intervalV1]-0-[_btnSubscribe]-0-[intervalV2]-0-[_btnTreatPay]-0-[intervalV3]-0-[_btnEvaluate]-26-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line1]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnOrderOnDoing]->=0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line2]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_lbCareType]->=18-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_imgDay]-0-[_imgNight]-0-[_lbDetailText]->=18-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnCustomerMobile]->=18-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_btnAddress]->=18-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_line3]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_SepLine]-0-|" options:0 metrics:nil views:views]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbNew attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbSubscribe attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnSubscribe attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbTreatPay attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnTreatPay attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbEvaluate attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnEvaluate attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    //V
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_photoImage(82)]-6-[_detailInfo]->=6-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbName]-4-[_lbMobile]-8-[_btnInfo]-10-[_detailInfo]-10-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_btnCert]->=0-|" options:0 metrics:nil views:views]];
    
    [rootview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_line1(1)]-4-[_btnOrderOnDoing]-4-[_line2(1)]-10-[_lbCareType]-8-[_lbDetailText]-10-[_line3(1)]-10-[_btnCustomerMobile]-10-[_btnAddress]-10-[_SepLine(7)]-0-|" options:0 metrics:nil views:views]];
    
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_imgDay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_imgNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_btnSubscribe attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_btnTreatPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_btnEvaluate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [rootview addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbSubscribe attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbTreatPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [rootview addConstraint:[NSLayoutConstraint constraintWithItem:_lbEvaluate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbNew attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}*/

- (void) ValuationForView
{
    UIView *headerView = _tableview.tableHeaderView;
    
    UserModel *userInfo = [UserModel sharedUserInfo];
    _lbName.text = userInfo.chineseName;
    
    _lbMobile.text = userInfo.mobilePhoneNumber;
    
    _detailInfo.text = userInfo.intro;
    
    NSString *title = [NSString stringWithFormat:@"%@ %d岁 护龄%d年", userInfo.birthAddr, [Util getAgeWithBirthday:userInfo.birthDay], [Util getAgeWithBirthday:userInfo.beginCareDate]];
    [_btnInfo setTitle:title forState:UIControlStateNormal];
    
    UserSex sex = [Util GetSexByName:userInfo.sex];
    NSString *placeholderImage = @"nurselistfemale";
    if(sex == EnumMale)
        placeholderImage = @"nurselistmale";
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:userInfo.headerImage] placeholderImage:[UIImage imageNamed:placeholderImage]];
    
    NSString *dayString = @"";
    NSString *hourString = @"";
    DateType dateType = userInfo.userOrderInfo.orderModel.dateType;
    if(dateType == EnumTypeHalfDay){
        dayString = @"天";
        hourString = @"12";
    }else if (dateType == EnumTypeOneDay){
        dayString = @"天";
        hourString = @"24";
    }
    else if (dateType == EnumTypeOneWeek){
        dayString = @"周";
        hourString = @"24";
    }
    else if (dateType == EnumTypeOneMounth){
        dayString = @"月";
        hourString = @"24";
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImage, _lbName, _btnCert, _lbMobile, _btnInfo, _detailInfo, _btnNew, _lbNew, _btnSubscribe, _lbSubscribe, _btnTreatPay, _lbTreatPay, _btnEvaluate, _lbEvaluate, _line1, _btnOrderOnDoing, _line2, _lbCareType, _imgDay, _imgNight, _lbDetailText, _btnCustomerMobile, _btnAddress, _line3, intervalV1, intervalV2, intervalV3, _SepLine, _OrderInfoView);
    
    [headerView removeConstraints:constraints];
    if(userInfo.userOrderInfo.orderModel != nil){
        _lbCareType.text = [NSString stringWithFormat:@"%@：¥%.2f/%@h x %ld%@ = ¥%.2f", userInfo.userOrderInfo.orderModel.productInfo.name, userInfo.userOrderInfo.orderModel.unitPrice, hourString, (long)userInfo.userOrderInfo.orderModel.orderCount,dayString, userInfo.userOrderInfo.orderModel.totalPrice];//@"医院陪护：¥180/12h";
        
        [_btnAddress setTitle:userInfo.userOrderInfo.orderModel.loverinfo.addr forState:UIControlStateNormal];
        NSString *phone = [NSString stringWithFormat:@"%@ %@", userInfo.userOrderInfo.orderModel.loverinfo.name, userInfo.userOrderInfo.orderModel.loverinfo.phone];
        [_btnCustomerMobile setTitle:phone forState:UIControlStateNormal];
        
        _lbDetailText.text = [Util GetOrderServiceTime:[Util convertDateFromDateString:userInfo.userOrderInfo.orderModel.beginDate] enddate:[Util convertDateFromDateString:userInfo.userOrderInfo.orderModel.endDate] datetype:userInfo.userOrderInfo.orderModel.dateType];
        
        _imgDay.image = [UIImage imageNamed:@"daytime"];
        _imgNight.image = [UIImage imageNamed:@"night"];
        if(userInfo.userOrderInfo.orderModel.dateType == EnumTypeHalfDay){
            ServiceTimeType type = [Util GetServiceTimeType:[Util convertDateFromDateString:userInfo.userOrderInfo.orderModel.beginDate]];
            if(type == EnumServiceTimeDay){
                _imgNight.image = nil;
            }
            else if (type == EnumServiceTimeNight){
                _imgDay.image = nil;
            }
        }
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_line1(1)]-4-[_btnOrderOnDoing]-4-[_line2(1)]-0-[_OrderInfoView]-0-[_SepLine(7)]-0-|" options:0 metrics:nil views:views];
        [headerView addConstraints:constraints];
        _OrderInfoView.hidden = NO;
        
    }else{
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-10-[_btnNew]-4-[_lbNew]-12-[_line1(1)]-4-[_btnOrderOnDoing]-4-[_line2(1)]-10-[_SepLine(7)]-0-|" options:0 metrics:nil views:views];
        [headerView addConstraints:constraints];
        _OrderInfoView.hidden = YES;
    }
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    
    _tableview.tableHeaderView = headerView;
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
    return 4;
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
            cell.lbTitle.text = @"全部订单";
            cell.photoImgV.image = [UIImage imageNamed:@"allOrder"];
        }
            break;
        case 1:
        {
            cell.lbTitle.text = @"我的评价";
            cell.photoImgV.image = [UIImage imageNamed:@"myEvaluate"];
        }
            break;
        case 2:
        {
            cell.lbTitle.text = @"我的陪护";
            cell.photoImgV.image = [UIImage imageNamed:@"MyEscort"];
        }
            break;
        case 3:
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
        MyOrderListVC *vc = [[MyOrderListVC alloc] initWithOrderType:EnumOrderAll];
        vc.hidesBottomBarWhenPushed = YES;
        vc.NavTitle = @"我的订单";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        MyEvaluateListVC *vc = [[MyEvaluateListVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        MyEscortObjectVC *vc = [[MyEscortObjectVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma ACTIONS

- (void) btnClickedToLoadOrders:(UIButton*) sender
{
    OrderListType type = EnumOrderAll;
    if(sender == _btnNew)
        type = EnumOrderNew;
    else if (sender == _btnSubscribe)
        type = EnumOrderSubscribe;
    else if (sender == _btnTreatPay)
        type = EnumOrderTreatPay;
    else
        type = EnumOrderEvaluate;
    MyOrderListVC *vc = [[MyOrderListVC alloc] initWithOrderType:type];
    vc.hidesBottomBarWhenPushed = YES;
    if(sender == _btnNew)
        vc.NavTitle = @"新订单";
    else if (sender == _btnSubscribe)
        vc.NavTitle = @"已预约订单";
    else if (sender == _btnTreatPay)
        vc.NavTitle = @"待付款订单";
    else
        vc.NavTitle = @"待评价订单";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
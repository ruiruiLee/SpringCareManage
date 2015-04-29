//
//  HomePageVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface HomePageVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UIView *_bgView;
    UIImageView *_photoImage;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnCert;//证书
    UILabel *_lbMobile;//电话
    UIButton *_btnInfo;//年龄，护龄信息
    UILabel *_detailInfo;//详细信息
    
    UIButton *_btnNew;//新订单
    UILabel *_lbNew;
    
    UIButton *_btnSubscribe;//已预约
    UILabel *_lbSubscribe;
    
    UIButton *_btnTreatPay;//待付款
    UILabel *_lbTreatPay;
    
    UIButton *_btnEvaluate;//待评价
    UILabel *_lbEvaluate;
    
    UIView *intervalV1;
    UIView *intervalV2;
    UIView *intervalV3;
    
    UIView *_OrderInfoView;
    
    UILabel *_line1;
    UIButton *_btnOrderOnDoing;
    UILabel *_line2;
    UILabel *_lbCareType;
    UIImageView *_imgDay;
    UIImageView *_imgNight;
    UILabel *_lbDetailText;
    UILabel *_line3;
    
    UIButton *_btnCustomerMobile;
    UIButton *_btnAddress;
    
    UIView *_SepLine;
    
    UITableView *_tableview;
    
    NSArray *constraints;
}

@end
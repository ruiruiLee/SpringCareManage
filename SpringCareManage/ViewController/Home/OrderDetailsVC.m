//
//  OrderDetailsVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "UserModel.h"

@implementation OrderPriceCell
@synthesize delegate;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbPrice.font = _FONT(15);
        _lbPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbPrice];
        
        _lbTotalPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTotalPrice.font = _FONT(15);
        _lbTotalPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbTotalPrice];
        
        _btnStatus = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnStatus.titleLabel.font = _FONT(16);
        [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnStatus.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_btnStatus];
        [_btnStatus addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnStatus.layer.cornerRadius = 5;
        _btnStatus.clipsToBounds = YES;
        
        _imgLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgLogo];
        _imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _imgLogo.image = [UIImage imageNamed:@"orderend"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbPrice, _lbTotalPrice, _btnStatus, _imgLogo);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]->=20-[_btnStatus(80)]-23-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbTotalPrice]->=20-[_btnStatus]-23-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbPrice(20)]-5-[_lbTotalPrice(20)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=20-[_imgLogo]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnStatus(32)]->=0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void) setContentData:(OrderInfoModel *) model
{
    _orderModel = model;
    
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"单价：¥%d", (int)model.unitPrice]];
    if(model.dateType == EnumTypeHalfDay){
        [priceStr appendString:[NSString stringWithFormat:@"/12h x %d天", (int)model.orderCount]];
    }
    else if (model.dateType == EnumTypeOneDay){
        [priceStr appendString:[NSString stringWithFormat:@"/天 x %d天", model.orderCount]];
    }
    else if (model.dateType == EnumTypeOneWeek){
        [priceStr appendString:[NSString stringWithFormat:@"/周 x %d周", model.orderCount]];
    }
    else if (model.dateType == EnumTypeOneMounth){
        [priceStr appendString:[NSString stringWithFormat:@"/月 x %d月", model.orderCount]];
    }
    
    _lbPrice.text = priceStr;
    NSString *total = [NSString stringWithFormat:@"总价：¥%d", (int)model.totalPrice];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:total];
    NSRange range = [total rangeOfString:[NSString stringWithFormat:@"¥%d", (int)model.totalPrice]];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    [string addAttribute:NSFontAttributeName value:_FONT(20) range:range];
    _lbTotalPrice.attributedText = string;
    
    _btnStatus.userInteractionEnabled = YES;
    [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnStatus.backgroundColor = [UIColor clearColor];
    _btnStatus.tag = 4;
    
    _imgLogo.hidden = YES;
    NSString *status = @"";
    _btnStatus.userInteractionEnabled = NO;
    UIImage *imageNormal = [Util imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
    UIImage *imageSelect = [Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)];
    [_btnStatus setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [_btnStatus setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    switch (model.orderStatus) {
        case EnumOrderStatusTypeNew:
            status = @"确认订单";
            _btnStatus.userInteractionEnabled = YES;
            [_btnStatus setBackgroundImage:imageSelect forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case EnumOrderStatusTypeConfirm:
            status = @"已预约";
            break;
        case EnumOrderStatusTypeServing:
            status = @"服务中";
            break;
        case EnumOrderStatusTypeFinish:{
            if(model.payStatus == EnumTypeNopay){
                status = @"待付款";
            }else if (model.commentStatus == EnumTypeNoComment){
                status = @"待评价";
            }else{
                status = @"服务完成";
                _imgLogo.hidden = NO;
            }
        }
            break;
        case EnumOrderStatusTypeCancel:
            status = @"已取消";
            break;
        default:
            break;
    }
    [_btnStatus setTitle:status forState:UIControlStateNormal];
}

- (void) doBtnClicked:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否接单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
        
        [parmas setObject:_orderModel.orderId forKey:@"orderId"];
        [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"currentUserId"];
        
        __weak OrderPriceCell *weakSelf = self;
        [LCNetWorkBase postWithMethod:@"api/order/confirm" Params:parmas Completion:^(int code, id content) {
            if(code){
                if([content objectForKey:@"code"] == nil){
                    _orderModel.orderStatus = EnumOrderStatusTypeConfirm;
                    [weakSelf setContentData:_orderModel];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_OrderInfo_Refresh object:nil];
                }
            }
        }];
    }
}

@end

@implementation OrderInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
         _imgPhoto.layer.masksToBounds = YES;
         _imgPhoto.layer.cornerRadius = 32;
        [self.contentView addSubview:_imgPhoto];
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(18);
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        
        _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnInfo];
        _btnInfo.titleLabel.font = _FONT(14);
        [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
        [_btnInfo setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbIntro = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbIntro];
        _lbIntro.translatesAutoresizingMaskIntoConstraints = NO;
        _lbIntro.numberOfLines = 0;
        _lbIntro.font = _FONT(13);
        _lbIntro.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbIntro.preferredMaxLayoutWidth = ScreenWidth - 132;
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = SeparatorLineColor;
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbType = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbType];
        _lbType.translatesAutoresizingMaskIntoConstraints = NO;
        _lbType.font = _FONT(15);
        _lbType.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbDetailTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbDetailTime];
        _lbDetailTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbDetailTime.font = _FONT(15);
        _lbDetailTime.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbPrice];
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        _lbPrice.font = _FONT(15);
        _lbPrice.textColor = _COLOR(0x99, 0x99, 0x99);
//        _lbPrice.text = @"单价：380元/24小时";
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_line]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbDetailTime]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbType]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_lbName]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_btnInfo]->=20-|" options:0 metrics:nil views:views]];
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_imgPhoto(82)]-16-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_lbIntro]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:constraintArray];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_lbName(20)]-3-[_btnInfo(20)]-1-[_lbIntro]->=0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:nurseConstraintArray];
    }
    return self;
}

- (void) setContentData:(OrderInfoModel *) model
{
    
    _lbType.text = [NSString stringWithFormat:@"类型：%@", model.productInfo.name];
    NSMutableString *detailTime = [[NSMutableString alloc] init];
    [detailTime appendString:@"时间："];
    [detailTime appendString:[NSString stringWithFormat:@"%d", model.orderCount]];
    if(model.dateType == EnumTypeHalfDay){
        [detailTime appendString:[NSString stringWithFormat:@"天"]];
    }
    else if (model.dateType == EnumTypeOneDay){
        [detailTime appendString:[NSString stringWithFormat:@"天"]];
    }
    else if (model.dateType == EnumTypeOneWeek){
        [detailTime appendString:[NSString stringWithFormat:@"周"]];
    }
    else if (model.dateType == EnumTypeOneMounth){
        [detailTime appendString:[NSString stringWithFormat:@"月"]];
    }
    
    [detailTime appendString:[NSString stringWithFormat:@"(%@点-%@点)", [Util convertShotStrFromDate:[Util convertDateFromDateString:model.beginDate]], [Util convertShotStrFromDate:[Util convertDateFromDateString:model.endDate]]]];
    _lbDetailTime.text = detailTime;
    
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"单价：%d元", (int)model.unitPrice]];
    if(model.dateType == EnumTypeHalfDay){
        [priceStr appendString:[NSString stringWithFormat:@"/12小时"]];
    }
    else if (model.dateType == EnumTypeOneDay){
        [priceStr appendString:[NSString stringWithFormat:@"/24小时"]];
    }
    else if (model.dateType == EnumTypeOneWeek){
        [priceStr appendString:[NSString stringWithFormat:@"/周"]];
    }
    else if (model.dateType == EnumTypeOneMounth){
        [priceStr appendString:[NSString stringWithFormat:@"/月"]];
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:priceStr];
    NSRange range = NSMakeRange(3, [priceStr length] - 3);
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    [string addAttribute:NSFontAttributeName value:_FONT(15) range:range];
    
    _lbPrice.attributedText = string;
    
    NSArray *nurseArray = nil;
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto);
    [self.contentView removeConstraints:constraintArray];
    [self.contentView removeConstraints:nurseConstraintArray];
    {
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imgPhoto(0)]-0-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        _btnInfo.hidden = YES;
    }
    
    [self.contentView addConstraints:constraintArray];
    [self.contentView addConstraints:nurseConstraintArray];
}

@end

@implementation BeCareInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgPhoto];
        _imgPhoto.layer.masksToBounds = YES;
        _imgPhoto.layer.cornerRadius = 32;
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(16);
        _lbName.textAlignment = NSTextAlignmentCenter;
        
        _LbRelation = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_LbRelation];
        _LbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _LbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        _LbRelation.font = _FONT(18);
        
        _lbAge = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbAge];
        _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
        _lbAge.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbAge.font = _FONT(15);
        
        _btnMobile = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnMobile];
        _btnMobile.translatesAutoresizingMaskIntoConstraints = NO;
//        [_btnMobile setImage:[UIImage imageNamed:@"orderdetailtel"] forState:UIControlStateNormal];
        [_btnMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnMobile.titleLabel.font = _FONT(15);
        
        _btnAddress = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnAddress];
        _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
//        [_btnAddress setImage:[UIImage imageNamed:@"nurselistlocation"] forState:UIControlStateNormal];
        [_btnAddress setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnAddress.titleLabel.font = _FONT(15);
        
        _imgvAddr = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgvAddr];
        _imgvAddr.translatesAutoresizingMaskIntoConstraints = NO;
        _imgvAddr.image = ThemeImage(@"nurselistlocation");
        
        _imgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgSex];
        _imgSex.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _LbRelation, _lbAge, _btnMobile, _btnAddress, _imgSex, _imgvAddr);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_LbRelation]-10-[_imgSex]-10-[_lbAge]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_btnMobile]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_imgvAddr]-1-[_btnAddress]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_lbName]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_imgPhoto(62)]->=10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_LbRelation(20)]-2-[_lbName(18)]-2-[_btnAddress(22)]->=10-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgvAddr attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnAddress attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void) setContentData:(OrderInfoModel *) model
{
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.loverinfo.headerImage] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    _lbName.text = model.loverinfo.name;
    if(model.loverinfo.name == nil || [model.loverinfo.name length] == 0)
        _lbName.text = @"姓名";
    _LbRelation.text = model.loverinfo.nickname;
    if(model.loverinfo.nickname == nil || [model.loverinfo.nickname length] == 0)
        _LbRelation.text = @"昵称";
    _lbAge.text = [NSString stringWithFormat:@"%d岁", model.loverinfo.age];
    [_btnAddress setTitle:model.loverinfo.addr forState:UIControlStateNormal];
    
    UserSex sex = [Util GetSexByName:model.loverinfo.sex];
    if(sex == EnumMale){
        _imgSex.image = [UIImage imageNamed:@"mail"];
    }
    else if (sex == EnumFemale){
        _imgSex.image = [UIImage imageNamed:@"femail"];
    }
    else
        {
            _imgSex.image = nil;
        }
}

@end


@interface OrderDetailsVC ()

@end

@implementation OrderDetailsVC
@synthesize _orderModel = _orderModel;
@synthesize _stepView = _stepView;
@synthesize delegate;

- (id) initWithOrderModel:(OrderInfoModel *) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _orderModel = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"订单详情";
    
    [self initSubviews];
    
//    if(!_orderModel.isLoadDetail){
//        __weak OrderDetailsVC *weakSelf = self;
//        __weak UITableView *weakTableView = _tableview;
//        [_orderModel LoadDetailOrderInfo:^(int code) {
//            if(code){
//                [weakTableView reloadData];
//                [weakSelf initDataForView];
//            }
//        }];
//    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableview registerClass:[OrderPriceCell class] forCellReuseIdentifier:@"cell0"];
    [_tableview registerClass:[OrderInfoCell class] forCellReuseIdentifier:@"cell1"];
    [_tableview registerClass:[BeCareInfoCell class] forCellReuseIdentifier:@"cell2"];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 93.f;
    else if (indexPath.section == 1){
//        return 223.f;
        if(!ordercell)
        ordercell = [[OrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        [ordercell setContentData:_orderModel];
        [ordercell setNeedsLayout];
        [ordercell layoutIfNeeded];
        
        CGSize size = [ordercell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
    else
        return 92.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        OrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1){
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        BeCareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    if(section == 0){
        _stepView = [[OrderStepView alloc] initWithFrame:CGRectZero];
        _stepView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:_stepView];
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stepView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stepView)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stepView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stepView)]];
        if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
            [_stepView SetStepViewType:StepViewType2Step];
            [_stepView SetCurrentStepWithIdx:3];//此处为3
        }else{
            [_stepView SetStepViewType:StepViewType4Step];
            [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
        }
    }
    else if (section == 1){
        lbOrderNum = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderNum.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderNum];
        lbOrderNum.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderNum.font = _FONT(14);
        lbOrderNum.text = [NSString stringWithFormat:@"订 单 号 ：%@", _orderModel.serialNumber];
        
        lbOrderTime = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderTime.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderTime];
        lbOrderTime.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderTime.font = _FONT(14);
        lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@", _orderModel.createdDate];//@"下单时间：2015-03-19 12:46";
        
        NSDictionary*views = NSDictionaryOfVariableBindings(lbOrderNum, lbOrderTime);
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbOrderNum]-20-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbOrderTime]-20-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[lbOrderNum(20)]-2-[lbOrderTime(20)]-6-|" options:0 metrics:nil views:views]];
    }
    else{
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
        lb.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lb];
        lb.textColor = _COLOR(0x66, 0x66, 0x66);
        lb.font = _FONT(14);
        lb.text = @"被陪护人信息";
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lb]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    }
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 85.f;
    }else if(section == 1)
        return 54.f;
    else
        return 29.f;
}

- (void) initDataForView
{
    lbOrderNum.text = [NSString stringWithFormat:@"订 单 号 ：%@", _orderModel.serialNumber];
    lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@", _orderModel.createdDate];//@"下单时间：2015-03-19 12:46";
    if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
        [_stepView SetStepViewType:StepViewType2Step];
        [_stepView SetCurrentStepWithIdx:3];//此处为3
    }else{
        [_stepView SetStepViewType:StepViewType4Step];
        [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
    }
}

- (int) GetStepWithModel:(OrderInfoModel *) model
{
    if(model.orderStatus == EnumOrderStatusTypeNew)
        return 1;
    else if (model.orderStatus == EnumOrderStatusTypeConfirm)
        return 2;
    else if (model.orderStatus == EnumOrderStatusTypeServing)
        return 3;
    else if (model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeNoComment)
        return 4;
    else if (model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeCommented)
        return 5;
    else
        return 0;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)NotifyCommentChanged:(NSNotification *) notify
{
    [_tableview reloadData];
}

@end

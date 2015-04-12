//
//  EscortTimeTableCell.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeTableCell.h"

@implementation EscortTimeTableCell
@synthesize cellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        limitLines = 5;
        numOfLines = 0;
        
        [self initMainViewsWithBlock:nil];
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier blocks:(ReplayAction)blocks
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){
        limitLines = 5;
        numOfLines = 0;
        
        [self initMainViewsWithBlock:blocks];
    }
    return self;
}

- (void) initMainViewsWithBlock:(ReplayAction)block
{
    //时间轴
    _lbToday = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 60)];
    _lbToday.font = _FONT(20);
    _lbToday.textAlignment = NSTextAlignmentCenter;
    _lbToday.textColor = [UIColor whiteColor];
    _lbToday.backgroundColor = Abled_Color;
    _lbToday.layer.cornerRadius = 30;
    _lbToday.clipsToBounds = YES;
    _lbToday.text = @"14/03";
    
    _lbTimeLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbTimeLine];
    _lbTimeLine.backgroundColor = Abled_Color;
    _lbTimeLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lbToday];
    
    //文字内容
    _lbContent = [[HBCoreLabel alloc] initWithFrame:CGRectZero];
    _lbContent.backgroundColor = [UIColor clearColor];
    _lbContent.font = _FONT(14);
    _lbContent.textColor = _COLOR(73, 73, 73);
    _lbContent.numberOfLines = 0;
    [self.contentView addSubview:_lbContent];
    _lbContent.translatesAutoresizingMaskIntoConstraints = NO;
    [_lbContent setLineBreakMode:NSLineBreakByClipping];
    _lbContent.preferredMaxLayoutWidth = Content_Width;
    
    //展开或关闭
    _btnFoldOrUnfold = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnFoldOrUnfold];
    _btnFoldOrUnfold.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnFoldOrUnfold setTitleColor:_COLOR(0x10, 0x9d, 0x59) forState:UIControlStateNormal];
    _btnFoldOrUnfold.titleLabel.font = _FONT(14);
    [_btnFoldOrUnfold addTarget:self action:@selector(FoldOrUnfoldButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"escorttimevolice"];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width-5, 0, 2);
    
    //音频
    _btnVolice = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnVolice];
    _btnVolice.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnVolice setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
    //音频时间
    _lbVoliceLimit = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbVoliceLimit];
    _lbVoliceLimit.font = _FONT(14);
    _lbVoliceLimit.numberOfLines = 1;
    _lbVoliceLimit.textColor = _COLOR(130, 130, 130);
    _lbVoliceLimit.backgroundColor = [UIColor clearColor];
    _lbVoliceLimit.translatesAutoresizingMaskIntoConstraints = NO;
    
    //图片
    _imageContent = [[ImageLayoutView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageContent];
    _imageContent.translatesAutoresizingMaskIntoConstraints = NO;
    
    //回复
    _replyContent = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_replyContent];
    _replyContent.translatesAutoresizingMaskIntoConstraints = NO;
    
    //创建回复视图
    [self initReplyViewWithBlock:block];
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.backgroundColor = SeparatorLineColor;
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbContent, _btnFoldOrUnfold, _btnVolice, _lbVoliceLimit, _imageContent, _replyContent, _lbTimeLine, _line);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_lbContent]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_btnFoldOrUnfold]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_btnVolice(120)]-5-[_lbVoliceLimit]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_imageContent]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_replyContent]-20-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-48-[_lbTimeLine(4)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbTimeLine]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbVoliceLimit attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnVolice attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    //中间view间隔都是3个像素
    hLayoutInfoArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbContent]-3-[_btnFoldOrUnfold]-3-[_btnVolice]-10-[_imageContent]-3-[_replyContent]-10-[_line(1)]-0-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:hLayoutInfoArray];
}

- (void) initReplyViewWithBlock:(ReplayAction)block
{
    //发表时间
    _lbPublishTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbPublishTime.font = _FONT(12);
    _lbPublishTime.textColor = _COLOR(190, 190, 190);
    _lbPublishTime.numberOfLines = 1;
    _lbPublishTime.backgroundColor = [UIColor clearColor];
    [_replyContent addSubview:_lbPublishTime];
    _lbPublishTime.translatesAutoresizingMaskIntoConstraints = NO;
    
    //回复按钮
    _btnReply = [[UIButton alloc] initWithFrame:CGRectZero];
    [_replyContent addSubview:_btnReply];
    _btnReply.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnReply setImage:[UIImage imageNamed:@"escorttimereply"] forState:UIControlStateNormal];
    
    //回复列表背景
    _replyTableBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_replyContent addSubview:_replyTableBg];
    _replyTableBg.translatesAutoresizingMaskIntoConstraints = NO;
    _replyTableBg.backgroundColor = _COLOR(233, 233, 233);
    
    //回复列表
    _replyTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [_replyTableBg addSubview:_replyTableView];
    _replyTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _replyTableView.dataSource = self;
    _replyTableView.delegate = self;
    _replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _replyTableView.backgroundColor = [UIColor clearColor];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbPublishTime, _btnReply, _replyTableView, _replyTableBg);
    [_replyContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbPublishTime(120)]->=10-[_btnReply(50)]-4-|" options:0 metrics:nil views:views]];
    [_replyContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_replyTableBg]-0-|" options:0 metrics:nil views:views]];
    
    hReplyBgLayoutArry = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnReply(25)]-3-[_replyTableBg]-0-|" options:0 metrics:nil views:views];
    [_replyContent addConstraints:hReplyBgLayoutArry];
    [_replyContent addConstraint:[NSLayoutConstraint constraintWithItem:_lbPublishTime attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_btnReply attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_replyContent addConstraint:[NSLayoutConstraint constraintWithItem:_lbPublishTime attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnReply attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [_replyTableBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_replyTableView]-0-|" options:0 metrics:nil views:views]];
    hReplyTableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_replyTableView]-5-|" options:0 metrics:nil views:views];
    [_replyTableBg addConstraints:hReplyTableLayoutArray];
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_model.replyData count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 80.f;
    NSArray *dataArray =  _model.replyData;
    EscortTimeReplyDataModel *data = [dataArray objectAtIndex:indexPath.row];
    //    return [EscortTimeTableCell GetCellHeightWithData:data];
    return data.height + 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"replyCell";
    EscortTimeReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[EscortTimeReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    EscortTimeReplyDataModel *model = [_model.replyData objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    
    return cell;
}

- (void) setContentData:(EscortTimeDataModel*)data
{
    _model = data;
    
    NSString *textContent = data.textContent;//文字内容
    NSString *voiceContentUrl = data.voiceContentUrl;//音频内容地址
//    NSString *voiceLen = data.voiceLen;//音频时长
    NSString *publishTime = data.publishTime;//发布时间;
    NSArray *replyData = data.replyData;//回复数据
    NSArray *imgPicArray = data.imgPicArray;//图片数据列表
    
//    NSMutableString *format = @"V:|-10-[_lbContent]-3-[_btnFoldOrUnfold]-3-[_btnVolice]-3-[_imageContent]-3-[_replyContent]-10-|";
    NSMutableString *format = [[NSMutableString alloc] init];
    [format appendString:@"V:|-20-"];
    if(textContent != nil && ![textContent isKindOfClass:[NSNull class]]){
        
        [format appendString:@"[_lbContent]"];
        [format appendString:@"-2-"];
        _lbContent.text = textContent;
        [_lbContent setMatch:data.parser];
        
        _btnFoldOrUnfold.hidden = NO;
        if (data.numberOfLinesTotal > data.numberOfLineLimit) {
            if(!data.isShut){
                _lbContent.numberOfLines = data.numberOfLineLimit;
                [format appendString:@"[_btnFoldOrUnfold]"];
                [format appendString:@"-3-"];
                [_btnFoldOrUnfold setTitle:@"全文" forState:UIControlStateNormal];
            }else{
                _lbContent.numberOfLines = 0;
                [format appendString:@"[_btnFoldOrUnfold]"];
                [format appendString:@"-3-"];
                [_btnFoldOrUnfold setTitle:@"收起" forState:UIControlStateNormal];
            }
            
        }else{
            _lbContent.numberOfLines = 0;
            _btnFoldOrUnfold.hidden = YES;
        }
        
    }
    
    if(voiceContentUrl != nil && ![voiceContentUrl isKindOfClass:[NSNull class]])
    {
        [format appendString:@"[_btnVolice]"];
        [format appendString:@"-10-"];
        _lbVoliceLimit.text = @"12\"";
        _lbVoliceLimit.hidden = NO;
    }else
    {
        _lbVoliceLimit.hidden = YES;
    }
    
    if(imgPicArray != nil && [imgPicArray count] > 0)
    {
        CGFloat height = [ImageLayoutView heightForFiles:imgPicArray];
        
        NSString *string = [NSString stringWithFormat:@"[_imageContent(%f)]", height];
        [format appendString:string];
        [format appendString:@"-3-"];
        [_imageContent AddImages:imgPicArray];
    }
    
    [format appendString:@"[_replyContent]-10-[_line(1)]-0-|"];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbContent, _btnFoldOrUnfold, _btnVolice, _lbVoliceLimit, _imageContent, _replyContent, _btnReply, _replyTableBg, _replyTableView, _line);
    [self.contentView removeConstraints:hLayoutInfoArray];
    hLayoutInfoArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:hLayoutInfoArray];
    
    _lbPublishTime.text = publishTime;
    
    NSMutableString *replyFormat = [[NSMutableString alloc] init];
    [replyFormat appendString:@"V:|-0-[_btnReply(25)]"];
    if([replyData count] > 0){
        [replyFormat appendString:@"-3-[_replyTableBg]"];
    }
    [replyFormat appendString:@"-0-|"];
    [_replyContent removeConstraints:hReplyBgLayoutArry];
    hReplyBgLayoutArry = [NSLayoutConstraint constraintsWithVisualFormat:replyFormat options:0 metrics:nil views:views];
    [_replyContent addConstraints:hReplyBgLayoutArry];
    
    [_replyTableBg removeConstraints:hReplyTableLayoutArray];
    if([replyData count] > 0){
        CGFloat height = 0;
        for (int i = 0; i < [replyData count]; i++) {
            EscortTimeReplyDataModel *model = [replyData objectAtIndex:i];
            height += model.height;
            height += 4;
        }
        NSString *tableviewformat = [NSString stringWithFormat:@"V:|-5-[_replyTableView(%f)]-5-|", height];
        hReplyTableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:tableviewformat options:0 metrics:nil views:views];
        [_replyTableBg addConstraints:hReplyTableLayoutArray];
    }
    else{
        hReplyTableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_replyTableView]-0-|" options:0 metrics:nil views:views];
        [_replyTableBg addConstraints:hReplyTableLayoutArray];
    }
}

- (void) FoldOrUnfoldButtonClicked:(UIButton*)sender
{
    _model.isShut = !_model.isShut;
    
    if(cellDelegate && [cellDelegate respondsToSelector:@selector(ReloadTebleView)])
        [cellDelegate ReloadTebleView];
}

@end

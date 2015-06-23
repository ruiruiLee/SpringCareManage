//
//  EscortTimeTableCell.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeTableCell.h"
#import "NSStrUtil.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

@implementation EscortTimeTableCell
@synthesize cellDelegate;
@synthesize _lbToday;
@synthesize _model = _model;
@synthesize _btnReply = _btnReply;
@synthesize _lbTimeLine = _lbTimeLine;
@synthesize lbday;
@synthesize lbmounth;
@synthesize imageview;

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
    _lbToday = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
    _lbToday.font = _FONT_B(20);
    _lbToday.textAlignment = NSTextAlignmentCenter;
    _lbToday.textColor = [UIColor whiteColor];
    _lbToday.backgroundColor = Abled_Color;
    _lbToday.layer.cornerRadius = 30;
    _lbToday.clipsToBounds = YES;
    
    imageview = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, 60, 60)];
    [_lbToday addSubview:imageview];
    imageview.image = ThemeImage(@"timeintervalline");
    
    lbday = [[UILabel alloc] initWithFrame:CGRectMake(6, 10, 30, 22)];
    lbday.font = _FONT(26);
    lbday.textColor = [UIColor whiteColor];
    lbday.backgroundColor = [UIColor clearColor];
    [_lbToday addSubview:lbday];
    lbday.textAlignment = NSTextAlignmentRight;
    
    lbmounth = [[UILabel alloc] initWithFrame:CGRectMake(32, 30, 26, 20)];
    lbmounth.font = _FONT(16);
    lbmounth.textColor = [UIColor whiteColor];
    lbmounth.backgroundColor = [UIColor clearColor];
    [_lbToday addSubview:lbmounth];

    
    _lbTimeLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbTimeLine];
    _lbTimeLine.backgroundColor = Abled_Color;
    _lbTimeLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lbToday];
    
    //文字内容
    _lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbContent.backgroundColor = [UIColor clearColor];
    _lbContent.font = _FONT(15);
    _lbContent.textColor = _COLOR(73, 73, 73);
    _lbContent.numberOfLines = 0;
    [self.contentView addSubview:_lbContent];
    _lbContent.translatesAutoresizingMaskIntoConstraints = NO;
    [_lbContent setLineBreakMode:NSLineBreakByWordWrapping];
    _lbContent.preferredMaxLayoutWidth = Content_Width;
//    _lbContent.backgroundColor = [UIColor redColor];
    
    //展开或关闭
    _btnFoldOrUnfold = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnFoldOrUnfold];
    _btnFoldOrUnfold.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnFoldOrUnfold setTitleColor:_COLOR(0x10, 0x9d, 0x59) forState:UIControlStateNormal];
    _btnFoldOrUnfold.titleLabel.font = _FONT(14);
    [_btnFoldOrUnfold addTarget:self action:@selector(FoldOrUnfoldButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"escorttimevolice"];
    
    //音频
    _btnVolice = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnVolice];
    _btnVolice.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnVolice setBackgroundImage:[image stretchableImageWithLeftCapWidth:40 topCapHeight:5] forState:UIControlStateNormal];
    [_btnVolice addTarget:self action:@selector(VoicePlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnVolice.clipsToBounds = YES;
    _btnVolice.layer.cornerRadius = 5;
    //音频时间
    _lbVoliceLimit = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbVoliceLimit];
    _lbVoliceLimit.font = _FONT(13);
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
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_lbContent]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_btnFoldOrUnfold]->=20-|" options:0 metrics:nil views:views]];
    
    Constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_btnVolice(120)]-5-[_lbVoliceLimit]->=20-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:Constraints];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_imageContent]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_replyContent]-20-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-39-[_lbTimeLine(2)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbTimeLine]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_line]-0-|" options:0 metrics:nil views:views]];
    
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
    [_btnReply addTarget:self action:@selector(btnReplyPressed) forControlEvents:UIControlEventTouchUpInside];

    //回复列表背景
    _replyTableBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _replyTableBg.image=[[UIImage imageNamed:@"escorttimereply_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:20];
    _replyTableBg.userInteractionEnabled=YES;
    [_replyContent addSubview:_replyTableBg];
    _replyTableBg.translatesAutoresizingMaskIntoConstraints = NO;
    //_replyTableBg.backgroundColor = _COLOR(233, 233, 233);
    
    //回复列表
    _replyTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [_replyTableBg addSubview:_replyTableView];
    _replyTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _replyTableView.dataSource = self;
    _replyTableView.delegate = self;
    _replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _replyTableView.backgroundColor = [UIColor clearColor];
     _replyTableView.scrollEnabled = NO;
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbPublishTime, _btnReply, _replyTableView, _replyTableBg);
    [_replyContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbPublishTime(120)]->=10-[_btnReply(50)]-4-|" options:0 metrics:nil views:views]];
    [_replyContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_replyTableBg]-0-|" options:0 metrics:nil views:views]];
    
    hReplyBgLayoutArry = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnReply(25)]-4-[_replyTableBg]-0-|" options:0 metrics:nil views:views];
    [_replyContent addConstraints:hReplyBgLayoutArry];
    [_replyContent addConstraint:[NSLayoutConstraint constraintWithItem:_lbPublishTime attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_btnReply attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_replyContent addConstraint:[NSLayoutConstraint constraintWithItem:_lbPublishTime attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnReply attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [_replyTableBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_replyTableView]-0-|" options:0 metrics:nil views:views]];
    hReplyTableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[_replyTableView]-5-|" options:0 metrics:nil views:views];
    [_replyTableBg addConstraints:hReplyTableLayoutArray];
}

- (void)btnReplyPressed {
    if ([cellDelegate respondsToSelector:@selector(commentButtonClick:ReplyName:ReplyID:subframe:)]) {
        [cellDelegate commentButtonClick:self ReplyName:nil ReplyID:nil subframe:self.bounds];
    }

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
    return [_model.replyInfos count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 80.f;
    NSArray *dataArray =  _model.replyInfos;
    EscortTimeReplyDataModel *data = [dataArray objectAtIndex:indexPath.row];
    
//    data.height =[self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    return data.height;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"replyCell";
    EscortTimeReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[EscortTimeReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;

    }
    
    EscortTimeReplyDataModel *model = [_model.replyInfos objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EscortTimeReplyDataModel *model = [_model.replyInfos objectAtIndex:indexPath.row];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([cellDelegate respondsToSelector:@selector(commentButtonClick:ReplyName:ReplyID:subframe:)]) {
        EscortTimeReplyCell *replyCell = (EscortTimeReplyCell*)[tableView cellForRowAtIndexPath:indexPath];
        CGRect frame = [self convertRect:replyCell.frame fromView:tableView];
        [cellDelegate commentButtonClick:self ReplyName:model.replyUserName ReplyID:model.replyUserId subframe:frame];
    }
}


/**
 @Brief 根据语音时间长度计算控件长度
 **/
#define kAveVoiceImageWidth 1.2
#define kMinVoiceImageWidth 40.0
- (CGFloat) VoiceButtonWithVoiceTimeLength:(float)timeLength {
    CGFloat ratioLegth = kAveVoiceImageWidth * timeLength;
    return kMinVoiceImageWidth + ratioLegth;
}

- (void) setContentData:(EscortTimeDataModel*)data
{
    _model = data;
    NSString *textContent = data.content;//文字内容
    NSString *voiceContentUrl = data.VoliceDataModel.url;//音频内容地址
    NSString *voiceLen = data.VoliceDataModel.seconds;//音频时长
   _lbPublishTime.text = data.createTime;//发布时间;
    
//    if (data.showTime) {
//        
//        _lbToday.text =  [Util convertTimetoBroadFormat:data.createDate]; //发布日期
//        _lbToday.hidden = NO;
//      }else{
//        _lbToday.hidden = YES;
//    }
    NSArray *replyData = data.replyInfos;//回复数据
    NSArray *imgPicArray = data.imgPathArray;//图片数据列表
    
    NSMutableString *format = [[NSMutableString alloc] init];
    [format appendString:@"V:|-20-"];
    if(textContent != nil && ![textContent isKindOfClass:[NSNull class]]){
        
        [format appendString:@"[_lbContent]"];
        [format appendString:@"-2-"];
        _lbContent.text = textContent;

        _btnFoldOrUnfold.hidden = NO;
        if (data.numberOfLinesTotal > numberOfLineLimit) {
            if(!data.isShut){
                _lbContent.numberOfLines = numberOfLineLimit;
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
    else{
        _lbContent.text = @"";
    }
    
    if(voiceContentUrl != nil && ![voiceContentUrl isKindOfClass:[NSNull class]])
    {
        [format appendString:@"[_btnVolice(25)]"];
        [format appendString:@"-10-"];
        _lbVoliceLimit.text = [NSString stringWithFormat:@"%@\"", voiceLen];//@"12\"";
        _lbVoliceLimit.hidden = NO;
        _btnVolice.hidden = NO;
        [self.contentView removeConstraints:Constraints];
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbContent, _btnFoldOrUnfold, _btnVolice, _lbVoliceLimit, _imageContent, _replyContent, _lbTimeLine, _line);
        NSString *format = [NSString stringWithFormat:@"H:|-80-[_btnVolice(%f)]-5-[_lbVoliceLimit]->=20-|", [self VoiceButtonWithVoiceTimeLength:[voiceLen floatValue]]];
        Constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
        [self.contentView addConstraints:Constraints];
        
    }else
    {
        _lbVoliceLimit.hidden = YES;
        _btnVolice.hidden = YES;
    }
    
    if(imgPicArray != nil && [imgPicArray count] > 0)
    {
        CGFloat height = [ImageLayoutView heightForFiles:imgPicArray];
        
        NSString *string = [NSString stringWithFormat:@"[_imageContent(%f)]", height];
        [format appendString:string];
        [format appendString:@"-3-"];
        [_imageContent AddImages:imgPicArray];
        _imageContent.hidden = NO;
    }else{
        _imageContent.hidden = YES;
    }
    
    [format appendString:@"[_replyContent]-10-[_line(1)]-0-|"];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbContent, _btnFoldOrUnfold, _btnVolice, _lbVoliceLimit, _imageContent, _replyContent, _btnReply, _replyTableBg, _replyTableView, _line);
    [self.contentView removeConstraints:hLayoutInfoArray];
    hLayoutInfoArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:hLayoutInfoArray];
    
    
    
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
        float height = 0;
        for (int i = 0; i < [replyData count]; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            EscortTimeReplyDataModel *data = [replyData objectAtIndex:indexpath.row];
            height += data.height;
        }
        NSString *tableviewformat = [NSString stringWithFormat:@"V:|-13-[_replyTableView(%f)]-5-|", height];
        hReplyTableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:tableviewformat options:0 metrics:nil views:views];
        [_replyTableBg addConstraints:hReplyTableLayoutArray];
        _replyTableBg.hidden = NO;
        [_replyTableView reloadData];
    }
    else{
        hReplyTableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_replyTableView]-0-|" options:0 metrics:nil views:views];
        [_replyTableBg addConstraints:hReplyTableLayoutArray];
        _replyTableBg.hidden = YES;
    }
}

- (CGFloat) getContentHeightWithData:(EscortTimeDataModel *) modelData
{
    NSString *textContent = modelData.content;//文字内容
    NSString *voiceContentUrl = modelData.VoliceDataModel.url;//音频内容地址
    //    NSString *voiceLen = data.voiceLen;//音频时长
    NSArray *replyData = modelData.replyInfos;//回复数据
    NSArray *imgPicArray = modelData.imgPathArray;//图片数据列表
    
    CGFloat cellHeight = 20.f;
    if(textContent != nil && ![textContent isKindOfClass:[NSNull class]] && [textContent length] > 0){
        cellHeight += 2;
        _lbContent.text = textContent;
        
        if(modelData.numberOfLinesTotal == 0)
            modelData.numberOfLinesTotal = [NSStrUtil NumberOfLinesForString:textContent fontSize:_lbContent.font.pointSize andWidth:ScreenWidth-100];
        
        if (modelData.numberOfLinesTotal > numberOfLineLimit) {
            if(modelData.isShut){
                CGFloat labcontentHeight=[NSStrUtil heightForString:_lbContent.text
                                                           fontSize:_lbContent.font.pointSize
                                                           andWidth:ScreenWidth-100];
                cellHeight += labcontentHeight;
                cellHeight += 23;
            }
            else{
                cellHeight += [[textContent substringToIndex:1] sizeWithFont:_lbContent.font].height * 5;
                cellHeight += 23;
            }
        }else{
            CGFloat labcontentHeight=[NSStrUtil heightForString:_lbContent.text
                                                       fontSize:_lbContent.font.pointSize
                                                       andWidth:ScreenWidth-100];
            cellHeight += labcontentHeight;
            cellHeight += 3;
        }
    }
    
    if(voiceContentUrl != nil && ![voiceContentUrl isKindOfClass:[NSNull class]])
    {
        cellHeight += 35;
    }
    
    if(imgPicArray != nil && [imgPicArray count] > 0)
    {
        CGFloat height = [ImageLayoutView heightForFiles:imgPicArray];
        cellHeight += height;
        cellHeight += 3;
    }
    
    cellHeight += 39;
    if([replyData count] > 0){
        CGFloat height = 0;
        for (int i = 0; i < [replyData count]; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            EscortTimeReplyDataModel *data = [replyData objectAtIndex:indexpath.row];
            data.height = [NSStrUtil HeightOfString:data.content fontSize:15.f andWidth:ScreenWidth - 115] + 9;
            height += data.height;
        }
        cellHeight += 18;
        cellHeight += height;
    }
    
    return cellHeight;
}

- (void) VoicePlayClicked:(UIButton*)sender{
    
    _recoderAndPlayer = [RecoderAndPlayer sharedRecoderAndPlayer];
    _recoderAndPlayer.delegate=(id)self;
     AVFile *voiceFile =   [AVFile fileWithURL: _model.VoliceDataModel.url];
     NSArray *array =  [ voiceFile.url componentsSeparatedByString:@"/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: array[array.count-1]]) {
        [_recoderAndPlayer startPlaying:array[array.count-1]];
    }
    else{
    sender.userInteractionEnabled=false;
    [voiceFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
         NSString *recordAmrPath = [_recoderAndPlayer getPathByFileName:array[array.count-1] ofType:nil];
         [ data writeToFile:recordAmrPath atomically:YES];
          [_recoderAndPlayer startPlaying:array[array.count-1]];
          sender.userInteractionEnabled=true;
        
    }];
   
    }

}
- (void) FoldOrUnfoldButtonClicked:(UIButton*)sender
{
    _model.isShut = !_model.isShut;
    
    if(cellDelegate && [cellDelegate respondsToSelector:@selector(ReloadTebleView)])
        [cellDelegate ReloadTebleView];
}

@end

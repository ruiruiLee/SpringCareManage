//
//  ImageLayoutView.m
//  Demo
//
//  Created by LiuZach on 15/3/31.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "ImageLayoutView.h"
#import "NSStrUtil.h"
#import "UIImageView+WebCache.h"
#import "ObjImageDataInfo.h"
#import "HBImageViewList.h"
#import "NSImageUtil.h"
#import "define.h"

#define imageMaxWidth 200
#define imageMaxHeight 120
#define imageSpace 6
#define imageSize (ScreenWidth - 112)/3

@interface ImageLayoutView ()
{

}

//- (void) ReLayoutSubviews;

@end

@implementation ImageLayoutView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
     
        self.clipsToBounds = NO;
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void) AddImages:(NSArray*) images
{
    for (id obj in self.subviews) {
        [obj removeFromSuperview];
    }
    _imgurls = images;
    _bigUrls = [[NSMutableArray alloc]init];
    _images = [[NSMutableArray alloc]init];
    _imageViews = [[NSMutableArray alloc]init];
    
    [self layoutImages];
}

-(void)layoutImages
{
    NSUInteger count=[_imgurls count];
    if(count==1) {
//        if (bFirstSmall) {
//            [self drawLessThree];
//        } else {
            [self drawSingleImage:[_imgurls objectAtIndex:0]];
//        }
    }
    else if(count<=3)
        [self drawLessThree];
    else if(count==4)
        [self drawFour];
    else
        [self drawMoreFour];
    [self drawFile];
    
}

-(void)drawFile
{
    if([_files count]>0){
        float y;
        NSInteger imgCount = [_imgurls count];
        if(imgCount == 0){
            y = 0;
        }else if(imgCount == 1){
            y = imageMaxHeight;
        }else{
            y = ([_imgurls count]/4+1)*(imageSpace + imageSize);
        }
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, y+5, 44, 29)];
        imageView.image=[UIImage imageNamed:@"f_attach"];
        [self addSubview:imageView];
        UIImageView * countView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 18, 18)];
        countView.image=[UIImage imageNamed:@"f_attach_count@2x"];
        UILabel * countLabel=[[UILabel alloc]initWithFrame:CGRectMake(22, 10, 18, 18)];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.textAlignment=NSTextAlignmentCenter;
        countLabel.textColor=[UIColor whiteColor];
        countLabel.font=[UIFont systemFontOfSize:12];
//        countLabel.text=[NSString stringWithFormat:@"%d",[_files count]];
        [imageView addSubview:countView];
        [imageView addSubview:countLabel];
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookFileAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled=YES;
    }
    
}

-(void)drawSingleImage:(ObjImageDataInfo*) url
{
    NSMutableString * smlStr=[[NSMutableString alloc]init];
    NSMutableString * bigStr=[[NSMutableString alloc]init];
    if([NSStrUtil notEmptyOrNull:url.urlPath]){
        [smlStr appendFormat:@"%@",url.urlPath];
        [bigStr appendFormat:@"%@",url.urlPath];
    }
    [_bigUrls addObject:bigStr];
    
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageMaxWidth, imageMaxHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:smlStr] placeholderImage:[UIImage imageNamed:@"img_loading_for_talk"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image == nil)return ;
        CGSize size = image.size;
        float scale = size.height/size.width;
        float width = imageMaxHeight/scale,height = imageMaxHeight;
        if(scale<=(imageMaxHeight/imageMaxWidth)&&width >= imageMaxWidth)
        {
            width = imageMaxWidth;
            height = width*scale;
        }
        scale= width/size.width;
        if(scale!=1){
            image=[UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
        }
        size=image.size;
        imageView.frame=CGRectMake(0, 0, width, height);
        imageView.image=image;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookImageAction:)];
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:tap];
    }];
    [self addSubview:imageView];
    [ _imageViews addObject:imageView];
}

-(void)drawLessThree
{
    NSInteger count = [_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((imageSize+imageSpace)*i, 0, imageSize, imageSize)];
        ObjImageDataInfo * file = [_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(count-1 == i){
            [self uploadFinish];
        }
    }
}

-(void)uploadFinish
{
//    if(delegate&&[delegate respondsToSelector:@selector(showImageControlFinishLoad:)])
//        [delegate showImageControlFinishLoad:self];
}

-(void)drawFour
{
    NSInteger count = [_imgurls count];
    for(int i=0; i<count; i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((imageSpace + imageSize) *( i%2),(imageSpace+imageSize)*(i/2), imageSize, imageSize)];
        ObjImageDataInfo * file = [_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(i==count-1)
            [self uploadFinish];
    }
}

-(void)drawMoreFour
{
    NSInteger count=[_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((imageSpace+imageSize)*(i%3),(imageSpace+imageSize)*(i/3), imageSize, imageSize)];
        ObjImageDataInfo * file = [_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(i==count-1)
            [self uploadFinish];
    }
}

-(void)drawImage:(UIImageView*)imageView file:(ObjImageDataInfo*)file
{
    [_bigUrls addObject:file.urlPath];
    [ _imageViews addObject:imageView];
    
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    __block UIImageView * wimageView=imageView;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:file.urlPath] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookImageAction:)];
        wimageView.userInteractionEnabled=YES;
        [wimageView addGestureRecognizer:tap];
    }];
}

#pragma -mark 事件响应方法
-(void)lookFileAction:(UIGestureRecognizer*)sender
{
    NSLog(@"lookFileAction");
//    if(delegate&&[delegate respondsToSelector:@selector(lookFileAction:files:)]){
//        [delegate lookFileAction:self files:_files];
//    }
}

-(void)lookImageAction:(UIGestureRecognizer*)sender
{
    NSLog(@"lookImageAction");
//    if(delegate&&[delegate respondsToSelector:@selector(lookImageAction:)])
//        [delegate lookImageAction:self];
    _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    NSInteger index = [_imageViews indexOfObject:sender.view];
//    UIImageView * view=(UIImageView*)sender.view;
//    NSString * url=[_bigUrls objectAtIndex:index];
//    NSImageUtil *_util = [[NSImageUtil alloc]init];
    NSInteger count = [_imageViews count];
    for(int i=0;i<count;i++){
        UIImage * image=((UIImageView*)[_imageViews objectAtIndex:i]).image;
        if(image){
            [_images addObject:image];
        }else{
            [_images addObject:[UIImage imageNamed:@"img_loading_for_talk"] ];
        }
    }
//    [_util showBigImageWithUrl:url fromView:view complete:^(UIView * backView) {
//        [backView setHidden:YES];
        [_imageList addImagesURL:_bigUrls withSmallImage:_images];
        [_imageList setIndex:(int)index];
        [self.window addSubview:_imageList];
//    }];
}
-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
}

+(float)heightForFiles:(NSArray*)files1
{
    NSInteger count = [files1 count];
    float offset = 0;
    if(count == 0)
        return offset;
    else if(count == 1){
        return  imageMaxHeight + offset;
    }else{
        return (count/4+1)*(imageSize + imageSpace)+offset;
    }
}

@end

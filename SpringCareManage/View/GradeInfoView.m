//
//  GradeInfoView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/5.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "GradeInfoView.h"

@implementation GradeInfoView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = NO;
        _viewArray = [[NSMutableArray alloc] init];
        
        [self initSubviews];
        [self setScore:4];
    }
    return self;
}

- (void) initSubviews
{
    for (int i = 0; i < 5; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14 * i, 0, 14, 14)];
        [self addSubview:imgView];
        [_viewArray addObject:imgView];
    }
}

//- (void) layoutSubviews
//{
//    [super layoutSubviews];
//    
//    for (int i = 0; i < 5; i++) {
//        UIImageView *imgview = [_viewArray objectAtIndex:i];
//        CGRect frame= imgview.frame;
//        imgview.frame = CGRectMake(frame.origin.x, self.frame.size.height - 16, 16, 16);
//    }
//}

- (void) setScore:(NSInteger) score
{
    [self ResetScore];
    if(score > 5)
        score = 5;
    for (int i = 0; i < score; i++) {
        UIImageView *imgview = [_viewArray objectAtIndex:i];
        imgview.image = [UIImage imageNamed:@"b27_icon_star_yellow"];
    }
}

- (void) ResetScore
{
    for (int i = 0; i < 5; i++) {
        UIImageView *imgview = [_viewArray objectAtIndex:i];
        imgview.image = [UIImage imageNamed:@"b27_icon_star_gray"];
    }
}

@end

//
//  GradeInfoView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/5.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeInfoView : UIView
{
    NSMutableArray *_viewArray;
}

- (void) setScore:(NSInteger) score;

@end

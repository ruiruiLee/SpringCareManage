//
//  OrderStepView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StepViewType4Step,
    StepViewType2Step,
} StepViewType;

@interface OrderStepView : UIView
{
    NSArray *ImageCArray;
    NSArray *lbCArrary;
}

- (void) SetCurrentStepWithIdx:(NSInteger) idx;

- (void) SetStepViewType:(StepViewType) type;

@end

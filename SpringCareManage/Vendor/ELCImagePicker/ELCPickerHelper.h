//
//  ELCPickerHelper.h
//  EducationVersion
//
//  Created by forrestlee
//  Copyright (c) 2013年 cfph All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol DelegateDismissPick<NSObject>
- (void)dismissViewConttroller; // 取消按钮触发
@end

typedef void(^ELCBlock)(NSArray *info);

@interface ELCPickerHelper : NSObject

+ (id)sharedElcPickerHelper;

/**
 *@Brief 相册照片多选
 *@Param currentViewController 当前需要打开picker的controller
 *@Param completion 将选图图片以数组返回
 **/
- (void)openELImagePicker:(UIViewController*)currentViewController
            maxImageCount:(int)maxImageCount
               completion:(void(^)(NSArray *imageArray))completion;
-(void)defineDeleget:(id)deleget;
@end

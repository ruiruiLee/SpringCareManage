//

//表情view 转化公共控件
//  Created by forrestlee
//

#import <UIKit/UIKit.h>

@interface TextAndEmojiView : UIView

@property (nonatomic, strong) NSString *textString;
@property (nonatomic, assign) int maxWidth;
@property (nonatomic, assign) float fontsize;
@property (nonatomic, retain) UIColor* fontcolor;
@property (nonatomic, assign) int maxTextHeight;//如果设置wordWrop为YES，被截取的内容高度
@property (nonatomic, assign) BOOL wordWrop; //设置是否只取到截断的高度
@end
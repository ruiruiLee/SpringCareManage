

#import "TextAndEmojiView.h"
/****************************** TextAndEmojiView ****************************/


//定义表情计算参数
#define kEmojiSize 20
#define kMaxTextLableWidth 208.0
#define kSigleTextHeight 18.0
#define kMinVoiceImageWidth 40.0
#define kMaxVoiceImageWidth 160.0
#define kTextPadding 8
@implementation TextAndEmojiView
- (id)init {
    if (self = [super init]) {
        _fontsize=15.0f;
        _fontcolor= [UIColor blackColor];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
         _fontsize=15.0f;
         _fontcolor= [UIColor blackColor];
    }
    return self;
}
- (void)setTextString:(NSString *)textString {
    _textString = textString;
    
    [self assemebleMessage];
}

- (void)assemebleMessage {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    NSString    *regextString = @"fx_\\d{3}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regextString];
    CGFloat     x = 0.0f;
    CGFloat     y = 0.0f;
    int breakWordNum=1;
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    [self getImageRange:_textString array:messageArray];
    
    NSUInteger count = [messageArray count];
    for (int i = 0; i < count; i ++) {
       
        NSString *str = [messageArray objectAtIndex:i];
        if ([predicate evaluateWithObject:str]) {
            if ((x+kEmojiSize) <= _maxWidth) {
                
            }else {
                x = 0.0f;
                y += kSigleTextHeight+3;
            }
             @autoreleasepool {
            //添加单个表情
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(x, y, kEmojiSize, kEmojiSize);
                imageView.backgroundColor= [UIColor clearColor];
                [self addSubview:imageView];
            }
            //重设x
            x += kEmojiSize;
            
        }
        else {
            NSUInteger length = [str length];
            CGFloat strWidth = 0.0f;
            //记录单行文字
            NSMutableString *onelineString = [NSMutableString string];
            for (int j = 0; j < length; j ++) {
                //取出单个文字
                NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                //单个字的size
                CGSize tempSize = [temp sizeWithFont:[UIFont systemFontOfSize:_fontsize]];
                //当文字的宽度不超过最大行宽时，继续执行，并记录文字的宽度
                if ((x+strWidth+tempSize.width) <= _maxWidth) {
                    //记录文字宽度
                    strWidth += tempSize.width;
                    //将单个文字记录并保存
                    [onelineString appendString:temp];
                    if ([temp isEqual: @"\n"]) {
                        breakWordNum++;
                      }
                    continue;
                 }
                else {
                    @autoreleasepool {
                    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(x, y, strWidth, breakWordNum*kSigleTextHeight)];
                    lable.font = [UIFont systemFontOfSize:_fontsize];
                     lable.textColor = _fontcolor;
                    [lable setLineBreakMode:NSLineBreakByWordWrapping];
                    [lable setNumberOfLines:0];
                    lable.text = onelineString;
                    lable.backgroundColor = [UIColor clearColor];
                    [self addSubview:lable];
                    //重新记录x,y
                    x = 0.0f;
                    y +=  breakWordNum*kSigleTextHeight;
                    //重新记录单行文字宽度
                    strWidth = tempSize.width;
                    //重新记录单行文字,清空字符串,记录当前字符
                    onelineString.string = @"";
                    breakWordNum=1;
                    [onelineString appendString:temp];
                    if (_wordWrop && y>_maxTextHeight) {
                        y=_maxTextHeight;
                        lable.text = [NSString stringWithFormat:@"%@……", lable.text ];
                        break;
                      }
                    }
                }
              }
            
            //添加最后一行的字符串
            if (onelineString.length>0) {
               UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(x, y, strWidth, breakWordNum*kSigleTextHeight)];
               lable.font = [UIFont systemFontOfSize:_fontsize];
                lable.textColor = _fontcolor;
               [lable setLineBreakMode:NSLineBreakByWordWrapping];
               [lable setNumberOfLines:0];
               lable.text = onelineString;
               lable.backgroundColor = [UIColor clearColor];
               [self addSubview:lable];
                //重新记录x
                x += strWidth;
            }

         }
        
    }
    
    if (y < kSigleTextHeight) {
        self.frame = CGRectMake(0,0,x,breakWordNum*kSigleTextHeight);
    }else {
        self.frame = CGRectMake(0,0,_maxWidth,y+breakWordNum*kSigleTextHeight);
    }
    
}
/**
 @Brief 按序取出文字与表情,并排列成数组,存入传进来的数组中
 **/
- (void)getImageRange:(NSString*)message array:(NSMutableArray*)array {
    NSError     *error;
    NSString    *regextString = @"fx_\\d{3}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regextString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:message
                                                    options:NSMatchingReportProgress
                                                      range:NSMakeRange(0, message.length)];
    NSRange matchRange = [match range];
    
    if (!NSEqualRanges(matchRange, NSMakeRange(0, 0))) {
        if (matchRange.location > 0) {
            [array addObject:[message substringToIndex:matchRange.location]];
            [array addObject:[message substringWithRange:matchRange]];
            NSString *str = [message substringFromIndex:matchRange.location + matchRange.length];
            [self getImageRange:str array:array];
        }else {
            NSString *emojiStr = [message substringWithRange:matchRange];
            if (![emojiStr isEqualToString:@""]) {
                [array addObject:emojiStr];
                NSString *str = [message substringFromIndex:matchRange.location + matchRange.length];
                [self getImageRange:str array:array];
            }else {
                return;
            }
        }
    }else {
        [array addObject:message];
    }
}

@end

//
//  FaceBoardView.m
//  EducationVersion
//
//  Created by wuhuping on 13-9-9.
//  Copyright (c) 2013年 share. All rights reserved.
//

#import "FaceBoardView.h"
#import <QuartzCore/QuartzCore.h>
#import "define.h"
#define TSEMOJIVIEW_ROWS 3
#define TSEMOJIVIEW_COLUMNS 7
#define TSEMOJIVIEW_KEYTOP_WIDTH 82
#define TSEMOJIVIEW_KEYTOP_HEIGHT 111
#define TSKEYTOP_SIZE 40
#define TSEMOJI_SIZE 30
#define KEYBOARD_HEIGHT 216
#define KEYBOARD_WIDTH 320

/************************  TSEmojiViewLayer *************************/
@interface TSEmojiViewLayer : CALayer {
@private
    CGImageRef _keyTopImage;
}

@property (nonatomic, strong) UIImage *emojiImage;
@end

@implementation TSEmojiViewLayer

- (id)init {
    if (self = [super init]) {   
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    _keyTopImage = [[UIImage imageNamed:@"emoji_touch.png"] CGImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(TSEMOJIVIEW_KEYTOP_WIDTH, TSEMOJIVIEW_KEYTOP_HEIGHT));
    CGContextTranslateCTM(ctx, 0.0, TSEMOJIVIEW_KEYTOP_HEIGHT);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    CGContextDrawImage(ctx, CGRectMake(0, 0, TSEMOJIVIEW_KEYTOP_WIDTH, TSEMOJIVIEW_KEYTOP_HEIGHT), _keyTopImage);
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(CGSizeMake(TSKEYTOP_SIZE, TSKEYTOP_SIZE));
    CGContextDrawImage(ctx, CGRectMake((TSEMOJIVIEW_KEYTOP_WIDTH - TSKEYTOP_SIZE) / 2 , 60, TSKEYTOP_SIZE, TSKEYTOP_SIZE), [_emojiImage CGImage]);
    UIGraphicsEndImageContext();
}

@end


/************************  SingleEmojiView *************************/

@protocol SingleEmojiViewDelegate <NSObject>
@optional
- (void)didTouchEmojiView:(NSString*)string;
- (void)deleteButtonPressed;
@end

@interface SingleEmojiView : UIView {
    TSEmojiViewLayer    *_emojiPadLayer;
    NSInteger           _touchedIndex;
}

@property (nonatomic, strong) NSArray *emojiArray;
@property (nonatomic, assign) id<SingleEmojiViewDelegate> delegate;
@end

@implementation SingleEmojiView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _emojiPadLayer = [TSEmojiViewLayer layer];
        _emojiPadLayer.masksToBounds = NO;
        
        [self.layer addSublayer:_emojiPadLayer];
        [self setBackgroundColor:_COLOR(236, 236, 236)];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    unsigned long arrayCount = _emojiArray.count;
    for (int i = 0; i < arrayCount ; i ++) {
        @autoreleasepool {
            NSString *imageStr = _emojiArray[i];
            
            float originX = (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) * (i % TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE)/2;
            float originY = (self.bounds.size.height / TSEMOJIVIEW_ROWS ) * (i / TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.height / TSEMOJIVIEW_ROWS) - TSEMOJI_SIZE)/2;
            
            UIImage  *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageStr]];
            [image drawInRect:CGRectMake(originX, originY, TSEMOJI_SIZE, TSEMOJI_SIZE)];
        }
    }
    
    //delete button
    float originX = (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) * (20 % TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE)/2;
    float originY = (self.bounds.size.height / TSEMOJIVIEW_ROWS ) * (20 / TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.height / TSEMOJIVIEW_ROWS) - TSEMOJI_SIZE)/2;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(originX, originY, TSEMOJI_SIZE, TSEMOJI_SIZE);
    [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
    
    [self addSubview:deleteButton];
}

- (void)deleteButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteButtonPressed)]) {
        [self.delegate deleteButtonPressed];
    }
}

#pragma mark -
#pragma mark Touchs
- (NSUInteger)indexWithEvent:(UIEvent*)event
{
    UITouch* touch = [[event allTouches] anyObject];
    NSUInteger x = [touch locationInView:self].x / (self.bounds.size.width / TSEMOJIVIEW_COLUMNS);
    NSUInteger y = [touch locationInView:self].y / (self.bounds.size.height / TSEMOJIVIEW_ROWS);
    
    return x + (y * TSEMOJIVIEW_COLUMNS);
}

- (void)updateWithIndex:(NSUInteger)index {
    if (index < _emojiArray.count) {
        _touchedIndex = index;
        
        _emojiPadLayer.opacity = 1.0;
        if (_emojiPadLayer.opacity != 1.0) {
            _emojiPadLayer.opacity = 1.0;
        }
        
        float originX = (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) * (index % TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE)/2;
        float originY = (self.bounds.size.height / TSEMOJIVIEW_ROWS ) * (index / TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.height / TSEMOJIVIEW_ROWS) - TSEMOJI_SIZE)/2;
        UIImage     *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_emojiArray[index]]];
        [_emojiPadLayer setEmojiImage:image];
        [_emojiPadLayer setFrame:CGRectMake(originX - (TSEMOJIVIEW_KEYTOP_WIDTH - TSEMOJI_SIZE)/2, originY - (TSEMOJIVIEW_KEYTOP_HEIGHT - TSEMOJI_SIZE)+10, TSEMOJIVIEW_KEYTOP_WIDTH, TSEMOJIVIEW_KEYTOP_HEIGHT)];
        [_emojiPadLayer setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger index = [self indexWithEvent:event];
    if (index < _emojiArray.count) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self updateWithIndex:index];
        [CATransaction commit];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger index = [self indexWithEvent:event];
    if (_touchedIndex >=0 && index != _touchedIndex && index < _emojiArray.count) {
        [self updateWithIndex:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEnd];
}

- (void)touchEnd {
    if (self.delegate && _touchedIndex >= 0) {
        if ([self.delegate respondsToSelector:@selector(didTouchEmojiView:)]) {
            [self.delegate didTouchEmojiView:_emojiArray[_touchedIndex]];
        }
    }
    _touchedIndex = -1;
    _emojiPadLayer.opacity = 0.0;
    [self setNeedsDisplay];
    [_emojiPadLayer setNeedsDisplay];
}

@end

/************************  FaceBoardView *************************/

#define kMoreHeight 100.0
#define bottomHeight 30.0
@interface FaceBoardView ()<
UIScrollViewDelegate,
SingleEmojiViewDelegate>
{
    NSArray             *_emojiArray;
    UIScrollView        *_emojiScrollView;
    unsigned long                 pageCount;
    NSDictionary        *_plistDic;
    UIView              *_bottomView;
    UIPageControl       *_pageControl;
}

@end

@implementation FaceBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _plistDic =[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                            pathForResource:@"faceMap_ch"
                                                                            ofType:@"plist"]];
        _emojiArray = [[NSArray alloc] init];
        _emojiArray = [[_plistDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *obj1Str = obj1;
            NSString *obj2Str = obj2;
            return [obj1Str compare:obj2Str options:NSLiteralSearch];
        }];
            
        pageCount = _emojiArray.count / 20 + (_emojiArray.count % 20 ? 1 : 0);
        _emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -kMoreHeight, frame.size.width, frame.size.height+kMoreHeight-bottomHeight)];
        _emojiScrollView.delegate = self;
        _emojiScrollView.pagingEnabled = YES;
        _emojiScrollView.showsHorizontalScrollIndicator = NO;
        _emojiScrollView.showsVerticalScrollIndicator = NO;
        _emojiScrollView.contentSize = CGSizeMake(_emojiScrollView.frame.size.width * pageCount, _emojiScrollView.frame.size.height);
        [self addSubview:_emojiScrollView]; // 加载横向滚动视图
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake((frame.size.width - 100)/2, frame.size.height- 10-bottomHeight, 100, 10);
        _pageControl.numberOfPages = pageCount;
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
        
        [self addSingleEmojiView];  //加载表情视图
        [self addBottonView];
    }
    return self;
}

- (void)addBottonView{
    _bottomView =[[UIView alloc] initWithFrame:CGRectMake(0,_emojiScrollView.frame.origin.y+_emojiScrollView.frame.size.height,_emojiScrollView.frame.size.width,bottomHeight)];
    [_bottomView setBackgroundColor: _COLOR(236, 236, 236)];   //RGBwithHex(0xeeeff4)
    UIButton * btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(_bottomView.frame.size.width-53,_bottomView.frame.origin.y-2,50,bottomHeight);
     btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
   //[btnSend setBackgroundImage:ThemeImage(@"nav_btn") forState:UIControlStateNormal];
    btnSend.backgroundColor = Abled_Color;
    btnSend.layer.cornerRadius = 3;
     [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bottomView];
    [self addSubview:btnSend];
    
}
- (void)sendButtonPressed {
    if ([self.delegate respondsToSelector:@selector(sendButtonPressed)]) {
        [self.delegate sendButtonPressed];
    }
}
- (void)addSingleEmojiView {
    for (int i = 0; i < pageCount; i ++) {
        SingleEmojiView *singleEmojiView = [[SingleEmojiView alloc] initWithFrame:CGRectMake(_emojiScrollView.frame.size.width*i, kMoreHeight, _emojiScrollView.frame.size.width, _emojiScrollView.frame.size.height-kMoreHeight)];
        singleEmojiView.delegate = self;
        if (i == pageCount - 1) {
            singleEmojiView.emojiArray = [_emojiArray subarrayWithRange:NSMakeRange(i * 20, _emojiArray.count - i*20)];
        }else
            singleEmojiView.emojiArray = [_emojiArray subarrayWithRange:NSMakeRange(i * 20, 20)];
        [_emojiScrollView addSubview:singleEmojiView];
        
    }
}


#pragma mark -
#pragma mark SingleEmojiViewDelegate
- (void)didTouchEmojiView:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(didTouchEmojiView:touchedEmoji:)]) {
        NSString *value = [_plistDic valueForKey:string];
        [self.delegate didTouchEmojiView:self touchedEmoji:[NSDictionary dictionaryWithObject:value forKey:string]];
    }
}

- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(deleteButtonPressed)]) {
        [self.delegate deleteButtonPressed];
    }
}
#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = index;
}
@end

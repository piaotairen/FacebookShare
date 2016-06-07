//
//  LSShareContentView.m
//  FacebookShare
//
//  Created by Cobb on 16/6/6.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "LSShareContentView.h"
#import "masonry.h"

static CGFloat LSShareButtonWidth = 100.f; //分享按钮的宽度
static CGFloat LSShareButtonHeight = 120.f; //分享按钮的高度
static CGFloat LSShareTitleHeight = 20.f; //分享标题的高度

static CGFloat LSShareViewHeight = 300.f; //分享视图的高度
static CGFloat LSCancelButtonHeight = 60.f; //取消按钮的高度
static CGFloat LSShareViewMargin = 10.f; //分享视图中间间隙

static NSInteger LSBaseTagNum = 1000; //分享按钮tag值区间

/**
 * 分享视图显示方向
 */
typedef NS_ENUM(NSUInteger, LSShowDirection) {
    LSShareViewShowFromBottom,
    LSShareViewShowFromTop,
    LSShareViewShowFromLeft,
    LSShareViewShowFromRight,
    LSShareViewShowFromCenter
};

/**
 * 分享按钮
 */
@interface LSShareButton : UIControl

/**
 * 分享按钮图片
 */
@property (nonatomic,readwrite,strong) UIImageView *buttonIcon;
/**
 * 分享按钮标题
 */
@property (nonatomic,readwrite,strong) UILabel *buttonTitle;

/**
 * @breif 类方法返回实例
 */
+ (instancetype)ButtonWithIcon:(NSString *)imageName Title:(NSString *)title;
/**
 * @breif 实例方法返回实例
 */
- (instancetype)initWithIcon:(NSString *)imageName Title:(NSString *)title;
- (instancetype)init UNAVAILABLE_ATTRIBUTE; //使用initWithIcon:Title:

@end

@implementation LSShareButton

#pragma mark - private
/**
 * @brief 获取按钮图片
 */
- (UIImageView *)buttonIcon
{
    if (!_buttonIcon) {
        _buttonIcon = [[UIImageView alloc]init];
        [self addSubview:_buttonIcon];
    }
    return _buttonIcon;
}
/**
 * @brief 获取按钮图片
 */
- (UILabel *)buttonTitle
{
    if (!_buttonTitle) {
        _buttonTitle = [[UILabel alloc]init];
        _buttonTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_buttonTitle];
    }
    return _buttonTitle;
}
/**
 * @breif 更新约束
 */
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_buttonIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(LSShareButtonWidth);
        make.height.mas_equalTo(LSShareButtonHeight-LSShareTitleHeight);
    }];
    
    [_buttonTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.buttonIcon.mas_bottom).offset(0);
        make.width.mas_equalTo(LSShareButtonWidth);
        make.height.mas_equalTo(LSShareButtonHeight);
    }];
}

#pragma mark - public
+ (instancetype)ButtonWithIcon:(NSString *)imageName Title:(NSString *)title
{
    return [[[self class] alloc]initWithIcon:imageName Title:title];
}

- (instancetype)initWithIcon:(NSString *)imageName Title:(NSString *)title
{
    self = [super init];
    if (!self) return nil;
    
    self.bounds = CGRectMake(0, 0, LSShareButtonWidth, LSShareButtonHeight);
    self.buttonIcon.image = [UIImage imageNamed:imageName];
    self.buttonTitle.text = title;
    [self addTarget:self action:@selector(shareButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    
    [self setNeedsUpdateConstraints];
    
    return self;
}
#pragma mark - 按钮事件
/**
 * 分享按钮按下
 */
- (void)shareButtonTouchDown
{
    self.alpha = 0.8;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.alpha = 1.f;
    });
}
@end

@interface LSShareContentView ()

/**
 * 分享按钮父视图
 */
@property (nonatomic,readwrite,strong) UIView *shareButtonContentView;
/**
 * 取消按钮
 */
@property (nonatomic,readwrite,strong) UIButton *cancelButton;
/**
 *  底部隐藏视图手势蒙层
 */
@property (nonatomic,readwrite,strong) UIControl *downTapControl;
/**
 * 动画显示时间
 */
@property (nonatomic,readwrite,assign) NSTimeInterval fadeInAnimationDuration;
/**
 * 动画隐藏时间
 */
@property (nonatomic,readwrite,assign) NSTimeInterval fadeOutAnimationDuration;
/**
 * 完成显示后的回调
 */
@property (nonatomic,readwrite,copy) LSShowCompletion showCompletionBlock;
/**
 * 完成显示后的回调
 */
@property (nonatomic,readwrite,copy) LSShowCompletion dismissCompletionBlock;
/**
 * 屏幕尺寸
 */
@property (nonatomic,readwrite,assign) CGRect screenRect;

@end

@implementation LSShareContentView

#pragma mark - 实例化
/**
 * @breif 获取分享视图实例
 */
+ (instancetype)sharedView {
    static dispatch_once_t once;
    static LSShareContentView *sharedView;
    
    dispatch_once(&once, ^{
        sharedView = [[self alloc] init];
    });
    return sharedView;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _screenRect = [[UIScreen mainScreen]bounds];
    
    self.frame = CGRectMake(0, _screenRect.size.height, _screenRect.size.width, LSShareViewHeight);
    self.backgroundColor = [UIColor whiteColor];
    self.fadeInAnimationDuration = 0.35;
    self.fadeOutAnimationDuration = 0.15;
    
    [self setNeedsUpdateConstraints];
    
    return self;
}
#pragma mark - private
/**
 * @breif 获取分享按钮父视图
 */
- (UIView *)shareButtonContentView
{
    if (!_shareButtonContentView)
    {
        _shareButtonContentView = [[UIView alloc]init];
        
        NSArray *shareButtonIcons = @[@"Icon_facebook",
                                      @"Icon_Instagram",
                                      @"Icon_twitter"];
        NSArray *shareButtonTitles = @[@"Facebook",
                                       @"Twitter",
                                       @"Instagram"];
        for (int i = 0; i < 3; i++) {
            LSShareButton *button = [LSShareButton ButtonWithIcon:shareButtonIcons[i] Title:shareButtonTitles[i]];
            button.tag = LSBaseTagNum+i;
            [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_shareButtonContentView addSubview:button];
        }
        [self addSubview:_shareButtonContentView];
    }
    return _shareButtonContentView;
}
/**
 * @breif 获取取消按钮父视图
 */
- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}
/**
 * @breif 更新视图约束
 */
- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.shareButtonContentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(LSShareViewHeight-LSCancelButtonHeight-LSShareViewMargin);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.shareButtonContentView.mas_bottom).offset(LSShareViewMargin);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(LSCancelButtonHeight);
    }];
    
    for (int i = 0; i < 3; i++) {
        LSShareButton *button = (LSShareButton *)[self.shareButtonContentView viewWithTag:LSBaseTagNum+i];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.shareButtonContentView.mas_top).offset(0);
            make.bottom.equalTo(self.shareButtonContentView.mas_bottom).offset(0);
            make.left.equalTo(self.shareButtonContentView.mas_left).offset(i*_screenRect.size.width/3);
            make.width.mas_equalTo(_screenRect.size.width/3);
        }];
    }
}
#pragma mark - 添加蒙层
/**
 * @brief 添加蒙层与手势
 */
-(void)addTapGesture
{
    [self removeTapGesture];
    
    _downTapControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, _screenRect.size.width, _screenRect.size.height-LSShareViewHeight)];
    [_downTapControl addTarget:self action:@selector(downTapControlTouch) forControlEvents:UIControlEventTouchDown];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_downTapControl];
}
/**
 * @brief 删除蒙层与手势
 */
-(void)removeTapGesture
{
    if (_downTapControl) {
        [_downTapControl removeFromSuperview];
        _downTapControl = nil;
    }
}
/**
 * @brief 点击手势蒙层视图
 */
-(void)downTapControlTouch
{
    [self dismissWithCompletion:nil];
}
#pragma mark - public
/**
 * @breif 默认的显示视图方法
 */
- (void)show
{
    [self showWithCompletion:nil];
}
/**
 * @breif 显示视图方法带回调
 */
- (void)showWithCompletion:(LSShowCompletion)completion
{
    LSShareContentView *shareView = [[self class] sharedView];
    
    if (completion) {
        shareView.showCompletionBlock = [completion copy];
    }
    
    [shareView showWithDirection:LSShareViewShowFromBottom];
    [self addTapGesture];
}
/**
 * @breif 隐藏视图
 */
- (void)dismiss
{
    [self dismissWithCompletion:nil];
}
/**
 * @breif 隐藏视图方法带回调
 */
- (void)dismissWithCompletion:(LSDismissCompletion)completion
{
    LSShareContentView *shareView = [[self class] sharedView];
    
    if (completion) {
        shareView.dismissCompletionBlock = completion;
    }
    [shareView dismissAnimated];
}
#pragma mark - 显示/隐藏方法
/**
 * @brief 视图显示
 */
- (void)showWithDirection:(LSShowDirection)direction {
    
    // Zoom HUD a little to make a nice appear / pop up animation
    self.alpha = 0.5f;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    // Define blocks
    __weak LSShareContentView *weakSelf = self;
    
    __block void (^animationsBlock)(void) = ^{
        __strong LSShareContentView *strongSelf = weakSelf;
        if(strongSelf) {
            // Shrink HUD to finish pop up animation
            strongSelf.transform =  CGAffineTransformMakeTranslation(0, -LSShareViewHeight);
            strongSelf.alpha = 1.0f;
        }
    };
    
    // Animate appearance
    [UIView animateWithDuration:self.fadeOutAnimationDuration delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        animationsBlock();
    } completion:^(BOOL finished) {
                         if (self.showCompletionBlock) {
                             self.showCompletionBlock();
                         }
                     }];
    
}
/**
 * @brief 视图隐藏
 */
- (void)dismissAnimated
{
    [self removeTapGesture];
    
    // Define blocks
    __weak LSShareContentView *weakSelf = self;
    
    __block void (^animationsBlock)(void) = ^{
        __strong LSShareContentView *strongSelf = weakSelf;
        if(strongSelf) {
            self.transform = CGAffineTransformIdentity;;
            strongSelf.alpha = 0.5f;
        }
    };
    
    [UIView animateWithDuration:self.fadeOutAnimationDuration delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        animationsBlock();
    } completion:^(BOOL finished) {
        if (self.dismissCompletionBlock) {
            self.dismissCompletionBlock();
        }
        [self removeFromSuperview];
    }];
    
}
#pragma mark - 按钮事件
/**
 * @breif 取消按钮点击
 */
- (void)cancelButtonClick:(UIButton *)sender
{
    [self dismissAnimated];
}
/**
 * @breif 分享按钮点击
 */
- (void)shareButtonClick:(UIControl *)sender
{
    NSLog(@"分享按钮点击 tag is %ld",(long)sender.tag);
    [self dismissAnimated];
    if (_delegate && [_delegate respondsToSelector:@selector(shareWithType:)]) {
        [_delegate shareWithType:sender.tag-LSBaseTagNum];
    }
}
@end

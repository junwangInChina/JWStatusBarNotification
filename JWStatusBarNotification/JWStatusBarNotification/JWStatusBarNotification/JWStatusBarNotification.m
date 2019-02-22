//
//  JWStatusBarNotification.m
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/20.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import "JWStatusBarNotification.h"

#import "JWStatusBarView.h"

@interface JWStatusBarStyle (Default)

+ (NSArray *)allDefaultIdentifier;
+ (JWStatusBarStyle *)defaultStyleWithIdentifier:(NSString *)identifier;

@end

static JWStatusBarNotification *statusBarNotification;

@interface JWStatusBarNotification()

@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) JWStatusBarView *topBarView;
@property (nonatomic, strong) UIView *topCustomView;
@property (nonatomic, strong) NSMutableDictionary *userStyles;
@property (nonatomic, strong) JWStatusBarStyle *defaultStyle;
@property (nonatomic, strong) JWStatusBarStyle *activeStyle;
@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, copy) JWStatusBarDidSelected statusBarDidSelected;

@end

@implementation JWStatusBarNotification

+ (JWStatusBarNotification *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusBarNotification = [[self alloc] init];
    });
    return statusBarNotification;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self configDefaultStyle];
    }
    return self;
}

- (void)configDefaultStyle
{
    self.defaultStyle = [JWStatusBarStyle defaultStyleWithIdentifier:JWStatusBarStyleDefault];
    
    self.userStyles = [NSMutableDictionary dictionary];
    for (NSString *tempIdentifier in [JWStatusBarStyle allDefaultIdentifier])
    {
        [self.userStyles setObject:[JWStatusBarStyle defaultStyleWithIdentifier:tempIdentifier]
                            forKey:tempIdentifier];
    }
}

- (UIWindow *)overlayWindow
{
    if (!_overlayWindow)
    {
        self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.rootViewController = [[UIViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tempGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(topBarViewDidSelected:)];
        [_overlayWindow addGestureRecognizer:tempGesture];
    }
    return _overlayWindow;
}

- (JWStatusBarView *)topBarView
{
    if (!_topBarView)
    {
        self.topBarView = [[JWStatusBarView alloc] init];
        [self.overlayWindow.rootViewController.view addSubview:_topBarView];
    }
    return _topBarView;
}

#pragma mark - Public Method
- (void)configStyle:(NSString *)identifier
            prepare:(JWPrepareStyleBlock)prepareBlock
{
    NSAssert(identifier != nil, @"配置Style时，identifier不能为空");
    NSAssert(prepareBlock != nil, @"配置Style时，配置项不能为空");
    
    JWStatusBarStyle *tempStyle = [self.defaultStyle copy];
    [self.userStyles setObject:prepareBlock(tempStyle) forKey:identifier];
}

- (void)show:(NSString *)message
{
    if (message.length <= 0) return;

    [self show:message style:self.defaultStyle];
}

- (void)show:(NSString *)message complete:(JWStatusBarDidSelected)complete
{
    self.statusBarDidSelected = complete;
    
    [self show:message];
}

- (void)show:(NSString *)message identifier:(NSString *)identifier
{
    if (message.length <= 0) return;
    
    JWStatusBarStyle *tempStyle = nil;
    if (identifier != nil)
    {
        tempStyle = self.userStyles[identifier];
    }
    if (tempStyle == nil) tempStyle = self.defaultStyle;
    
    [self show:message style:tempStyle];
}

- (void)show:(NSString *)message identifier:(NSString *)identifier complete:(JWStatusBarDidSelected)complete
{
    self.statusBarDidSelected = complete;

    [self show:message identifier:identifier];
}

- (void)showView:(UIView *)view
{
    if (view == nil) return;
    self.topCustomView = view;
    
    JWStatusBarStyle *tempStyle = self.defaultStyle;
    if (tempStyle.barPositionType != JWStatusBarPositionTypeCustom) tempStyle.barPositionType = JWStatusBarPositionTypeCustom;

    [self show:nil style:tempStyle];
}

- (void)showView:(UIView *)view complete:(JWStatusBarDidSelected)complete
{
    self.statusBarDidSelected = complete;
    
    [self showView:view];
}

- (void)showView:(UIView *)view identifier:(NSString *)identifier
{
    if (view == nil) return;
    self.topCustomView = view;

    JWStatusBarStyle *tempStyle = nil;
    if (identifier != nil)
    {
        tempStyle = self.userStyles[identifier];
    }
    if (tempStyle == nil) tempStyle = self.defaultStyle;
    if (tempStyle.barPositionType != JWStatusBarPositionTypeCustom) tempStyle.barPositionType = JWStatusBarPositionTypeCustom;
    
    [self show:nil style:tempStyle];
}

- (void)showView:(UIView *)view identifier:(NSString *)identifier complete:(JWStatusBarDidSelected)complete
{
    self.statusBarDidSelected = complete;

    [self showView:view identifier:identifier];
}

- (void)dismiss
{
    if (self.topCustomView != nil)
    {
        CGFloat tempDamping = self.activeStyle.barAnimationType == JWStatusBarAnimationTypeBounce ? 0.5 : 1.0;
        CGFloat tempVelocity = self.activeStyle.barAnimationType == JWStatusBarAnimationTypeBounce ? 1 : 0;
        [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:tempDamping initialSpringVelocity:tempVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.topCustomView.frame = [self beforeRectWithStyle:self.activeStyle];
            self.topCustomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.overlayWindow removeFromSuperview];
            [self.overlayWindow setHidden:YES];
            self.overlayWindow.rootViewController = nil;
            self.overlayWindow = nil;
            self.topCustomView = nil;
        }];
    }
    else
    {
        CGFloat tempDamping = self.activeStyle.barAnimationType == JWStatusBarAnimationTypeBounce ? 0.5 : 1.0;
        CGFloat tempVelocity = self.activeStyle.barAnimationType == JWStatusBarAnimationTypeBounce ? 1 : 0;
        [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:tempDamping initialSpringVelocity:tempVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.topBarView.frame = [self beforeRectWithStyle:self.activeStyle];
            self.topBarView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.overlayWindow removeFromSuperview];
            [self.overlayWindow setHidden:YES];
            self.overlayWindow.rootViewController = nil;
            self.overlayWindow = nil;
            self.topBarView = nil;
        }];
    }
}

#pragma mark - Private Method
- (void)show:(NSString *)message style:(JWStatusBarStyle *)style
{
    [self dismissTimeStop];
    [self.overlayWindow setHidden:NO];
    
    self.activeStyle = style;
    
    if (self.topCustomView != nil)
    {
        [self showCustom:style];
    }
    else
    {
        [self showDefault:message style:style];
    }
}

- (void)showCustom:(JWStatusBarStyle *)style
{
    self.topCustomView.frame = [self beforeRectWithStyle:style];
    [self.overlayWindow.rootViewController.view addSubview:self.topCustomView];

    CGFloat tempDamping = style.barAnimationType == JWStatusBarAnimationTypeBounce ? 0.5 : 1.0;
    CGFloat tempVelocity = style.barAnimationType == JWStatusBarAnimationTypeBounce ? 1 : 0;
    CGFloat tempBeforeAlpha = style.barAnimationType == JWStatusBarAnimationTypeFade ? 0.0 : 1.0;
    self.topBarView.alpha = tempBeforeAlpha;
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:tempDamping initialSpringVelocity:tempVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.topCustomView.frame = [self afterRectWithStyle:style];
        self.topCustomView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self dismissTimerRun];
    }];
}

- (void)showDefault:(NSString *)message style:(JWStatusBarStyle *)style
{
    self.topBarView.frame = [self beforeRectWithStyle:style];
    self.topBarView.backgroundColor = style.barBackgroundColor;
    UILabel *textLabel = self.topBarView.textLabel;
    textLabel.textColor = style.barTextColor;
    textLabel.font = style.barTextFont;
    textLabel.accessibilityLabel = message;
    textLabel.text = message;
    if (JW_STATUS_SCREEN_IS_IPHONE_X_PRODUCTS &&
        (style.barPositionType == JWStatusBarPositionTypeCoverStatusBar ||
         style.barPositionType == JWStatusBarPositionTypeCoverStatusBarAndNavigation))
    {
        self.topBarView.textVerticalPositionAdjustment = 32;
    }
    else
    {
        self.topBarView.textVerticalPositionAdjustment = 0;
    }
    CGFloat tempDamping = style.barAnimationType == JWStatusBarAnimationTypeBounce ? 0.5 : 1.0;
    CGFloat tempVelocity = style.barAnimationType == JWStatusBarAnimationTypeBounce ? 1 : 0;
    CGFloat tempBeforeAlpha = style.barAnimationType == JWStatusBarAnimationTypeFade ? 0.0 : 1.0;
    self.topBarView.alpha = tempBeforeAlpha;
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:tempDamping initialSpringVelocity:tempVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.topBarView.frame = [self afterRectWithStyle:style];
        self.topBarView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self dismissTimerRun];
    }];
}

- (CGRect)beforeRectWithStyle:(JWStatusBarStyle *)style
{
    CGFloat tempWidth = (self.topCustomView != nil) ? CGRectGetWidth(self.topCustomView.frame) : JW_STSTUS_SCREEN_WIDTH;
    CGFloat tempHeight = (self.topCustomView != nil) ? CGRectGetHeight(self.topCustomView.frame) : (JW_STATUS_SCREEN_IS_IPHONE_X_PRODUCTS ? 44 : 20);
    CGFloat tempX = (self.topCustomView != nil) ? (JW_STSTUS_SCREEN_WIDTH - CGRectGetWidth(self.topCustomView.frame))/2.0 : 0;
    CGFloat tempY = 0;
    switch (style.barPositionType) {
        case JWStatusBarPositionTypeCoverStatusBar:
        {
            tempHeight = tempHeight == 44 ? tempHeight + 8 : 0;
        }
            break;
        case JWStatusBarPositionTypeCoverNavigation:
        {
            tempHeight = 44;
            tempY = tempHeight;
        }
            break;
        case JWStatusBarPositionTypeCoverStatusBarAndNavigation:
        {
            tempHeight += 44;
        }
            break;
        case JWStatusBarPositionTypeCustom:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    switch (style.barAnimationType) {
        case JWStatusBarAnimationTypeNone:
        {
            
        }
            break;
        case JWStatusBarAnimationTypeDrop:
        {
            tempX = self.topCustomView != nil ? tempX : 0;
            tempY = -tempHeight;
        }
            break;
        case JWStatusBarAnimationTypeLeftToRight:
        {
            tempX = -JW_STSTUS_SCREEN_WIDTH;
            tempY = self.topCustomView != nil ? self.activeStyle.barEdgeInsets.top : tempY;
        }
            break;
        case JWStatusBarAnimationTypeRightToLeft:
        {
            tempX = JW_STSTUS_SCREEN_WIDTH;
            tempY = self.topCustomView != nil ? self.activeStyle.barEdgeInsets.top : tempY;
        }
            break;
        case JWStatusBarAnimationTypeFade:
        {
            
        }
            break;
        case JWStatusBarAnimationTypeBounce:
        {
            tempX = self.topCustomView != nil ? tempX : 0;
            tempY = -tempHeight;
        }
            break;
        default:
            break;
    }
    
    return CGRectMake(tempX, tempY, tempWidth, tempHeight);
}

- (CGRect)afterRectWithStyle:(JWStatusBarStyle *)style
{
    CGFloat tempWidth = (self.topCustomView != nil) ? CGRectGetWidth(self.topCustomView.frame) : JW_STSTUS_SCREEN_WIDTH;
    CGFloat tempHeight = (self.topCustomView != nil) ? CGRectGetHeight(self.topCustomView.frame) : (JW_STATUS_SCREEN_IS_IPHONE_X_PRODUCTS ? 44 : 20);
    CGFloat tempX = (self.topCustomView != nil) ? (JW_STSTUS_SCREEN_WIDTH - CGRectGetWidth(self.topCustomView.frame))/2.0 : 0;
    CGFloat tempY = 0;
    switch (style.barPositionType) {
        case JWStatusBarPositionTypeCoverStatusBar:
        {
            tempHeight = tempHeight == 44 ? tempHeight + 8 : 0;
        }
            break;
        case JWStatusBarPositionTypeCoverNavigation:
        {
            tempY = tempHeight;
            tempHeight = 44;
        }
            break;
        case JWStatusBarPositionTypeCoverStatusBarAndNavigation:
        {
            tempHeight += 44;
        }
            break;
        case JWStatusBarPositionTypeCustom:
        {
            tempY = self.topCustomView != nil ? self.activeStyle.barEdgeInsets.top : 0;
        }
            break;
            
        default:
            break;
    }
    
    return CGRectMake(tempX, tempY, tempWidth, tempHeight);
}

- (void)dismissTimerRun
{
    [self.dismissTimer invalidate];
    self.dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.activeStyle.barDismissTimeInterval] interval:0 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

- (void)dismissTimeStop
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
}

- (void)topBarViewDidSelected:(UITapGestureRecognizer *)gesture
{
    CGPoint tempPoint = [gesture locationInView:self.overlayWindow.rootViewController.view];
    if (CGRectContainsPoint((self.topCustomView != nil ? self.topCustomView.frame : self.topBarView.frame), tempPoint))
    {
        !self.statusBarDidSelected?:self.statusBarDidSelected();
    }
}

@end



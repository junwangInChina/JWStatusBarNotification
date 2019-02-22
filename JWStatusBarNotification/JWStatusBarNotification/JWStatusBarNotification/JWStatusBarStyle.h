//
//  JWStatusBarStyle.h
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/20.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define JW_STSTUS_SCREEN_WIDTH             ([UIScreen mainScreen].bounds.size.width)
#define JW_STSTUS_SCREEN_HEIGHT            ([UIScreen mainScreen].bounds.size.height)
#define JW_STSTUS_SCREEN_SCALE             ([UIScreen mainScreen].scale)
#define JW_STSTUS_SEPARATOR_LINE_WIDTH      (1.0 / JW_STSTUS_SCREEN_SCALE) // 1像素的线

#define JW_STSTUS_DEVICE_IS_IPAD      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define JW_STSTUS_DEVICE_IS_IPHONE    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define JW_STATUS_SCREEN_IS_IPHONE_X \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && DEVICE_IS_IPHONE : NO)

#define JW_STATUS_SCREEN_IS_IPHONE_XR \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && DEVICE_IS_IPHONE : NO)

#define JW_STATUS_SCREEN_IS_IPHONE_XS \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && DEVICE_IS_IPHONE : NO)

#define JW_STATUS_SCREEN_IS_IPHONE_XS_MAX \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && DEVICE_IS_IPHONE : NO)

#define JW_STATUS_SCREEN_IS_IPHONE_X_PRODUCTS \
([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define JW_STATUS_SCREEN_IS_IPHONE_P_PRODUCTS \
([UIScreen mainScreen].bounds.size.height == 736)

extern NSString *const JWStatusBarStyleError;
extern NSString *const JWStatusBarStyleWarning;
extern NSString *const JWStatusBarStyleSuccess;
extern NSString *const JWStatusBarStyleDark;
extern NSString *const JWStatusBarStyleDefault;

typedef NS_ENUM(NSInteger, JWStatusBarAnimationType) {
    JWStatusBarAnimationTypeNone,
    JWStatusBarAnimationTypeDrop,
    JWStatusBarAnimationTypeLeftToRight,
    JWStatusBarAnimationTypeRightToLeft,
    JWStatusBarAnimationTypeBounce,
    JWStatusBarAnimationTypeFade
};

typedef NS_ENUM(NSInteger, JWStatusBarPositionType) {
    JWStatusBarPositionTypeCoverStatusBar,
    JWStatusBarPositionTypeCoverNavigation,
    JWStatusBarPositionTypeCoverStatusBarAndNavigation,
    JWStatusBarPositionTypeCustom,
};

@interface JWStatusBarStyle : NSObject

@property (nonatomic, strong) UIColor *barBackgroundColor;
@property (nonatomic, strong) UIColor *barTextColor;
@property (nonatomic, strong) UIFont *barTextFont;
@property (nonatomic, assign) NSTimeInterval barDismissTimeInterval;

@property (nonatomic, assign) JWStatusBarAnimationType barAnimationType;
@property (nonatomic, assign) JWStatusBarPositionType barPositionType;

@property (nonatomic, assign) UIEdgeInsets barEdgeInsets;

@end

NS_ASSUME_NONNULL_END

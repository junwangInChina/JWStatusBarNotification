//
//  JWStatusBarStyle.m
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/20.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import "JWStatusBarStyle.h"

NSString *const JWStatusBarStyleError = @"JWStatusBarStyleError";
NSString *const JWStatusBarStyleWarning = @"JWStatusBarStyleWarning";
NSString *const JWStatusBarStyleSuccess = @"JWStatusBarStyleSuccess";
NSString *const JWStatusBarStyleDark = @"JWStatusBarStyleDark";
NSString *const JWStatusBarStyleDefault = @"JWStatusBarStyleDefault";

@implementation JWStatusBarStyle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)])
        {
            self.barBackgroundColor = [UIApplication sharedApplication].delegate.window.tintColor;
        }
        else
        {
            self.barBackgroundColor = [UIColor whiteColor];
        }
        self.barTextColor = [UIColor grayColor];
        self.barTextFont = [UIFont systemFontOfSize:12];
        
        self.barAnimationType = JWStatusBarAnimationTypeDrop;
        self.barPositionType = JWStatusBarPositionTypeCoverStatusBar;
        
        self.barEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    JWStatusBarStyle *tempStyle = [[[self class] allocWithZone:zone] init];
    tempStyle.barBackgroundColor = self.barBackgroundColor;
    tempStyle.barTextColor = self.barTextColor;
    tempStyle.barTextFont = self.barTextFont;
    tempStyle.barAnimationType = self.barAnimationType;
    tempStyle.barPositionType = self.barPositionType;
    tempStyle.barEdgeInsets = self.barEdgeInsets;
    tempStyle.barDismissTimeInterval = self.barDismissTimeInterval;
    
    return tempStyle;
}

+ (NSArray *)allDefaultIdentifier
{
    return @[JWStatusBarStyleDefault,
             JWStatusBarStyleError,
             JWStatusBarStyleSuccess,
             JWStatusBarStyleWarning,
             JWStatusBarStyleDark];
}

+ (JWStatusBarStyle *)defaultStyleWithIdentifier:(NSString *)identifier
{
    JWStatusBarStyle *tempStyle = [[JWStatusBarStyle alloc] init];
    tempStyle.barTextFont = [UIFont systemFontOfSize:12.0];
    tempStyle.barTextColor = [UIColor whiteColor];
    tempStyle.barAnimationType = JWStatusBarAnimationTypeDrop;
    tempStyle.barPositionType = JWStatusBarPositionTypeCoverStatusBar;
    tempStyle.barDismissTimeInterval = 3.0;
    tempStyle.barEdgeInsets = UIEdgeInsetsZero;
    
    if ([identifier isEqualToString:JWStatusBarStyleDefault])
    {
        tempStyle.barBackgroundColor = [UIColor whiteColor];
        tempStyle.barTextColor = [UIColor grayColor];
    }
    else if ([identifier isEqualToString:JWStatusBarStyleError])
    {
        tempStyle.barBackgroundColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
    }
    else if ([identifier isEqualToString:JWStatusBarStyleWarning])
    {
        tempStyle.barBackgroundColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
        tempStyle.barTextColor = [UIColor darkGrayColor];
    }
    else if ([identifier isEqualToString:JWStatusBarStyleSuccess])
    {
        tempStyle.barBackgroundColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
    }
    else if ([identifier isEqualToString:JWStatusBarStyleDark])
    {
        tempStyle.barBackgroundColor = [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
        tempStyle.barTextColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
    else
    {
        tempStyle = nil;
    }
    
    return tempStyle;
    
}

@end

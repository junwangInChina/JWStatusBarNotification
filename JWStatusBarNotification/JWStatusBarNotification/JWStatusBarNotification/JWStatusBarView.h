//
//  JWStatusBarView.h
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/20.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWStatusBarView : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, assign) CGFloat textVerticalPositionAdjustment;

@end

NS_ASSUME_NONNULL_END

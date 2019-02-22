//
//  JWStatusBarNotification.h
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/20.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JWStatusBarStyle.h"

#define INSTANCE     [JWStatusBarNotification shareInstance]

NS_ASSUME_NONNULL_BEGIN

typedef JWStatusBarStyle *(^JWPrepareStyleBlock)(JWStatusBarStyle *style);
typedef void(^JWStatusBarDidSelected)(void);

@interface JWStatusBarNotification : NSObject


+ (JWStatusBarNotification *)shareInstance;

- (void)configStyle:(NSString *)identifier
            prepare:(JWPrepareStyleBlock)prepareBlock;

- (void)show:(NSString *)message;

- (void)show:(NSString *)message complete:(JWStatusBarDidSelected)complete;;

- (void)show:(NSString *)message identifier:(NSString *)identifier;

- (void)show:(NSString *)message identifier:(NSString *)identifier complete:(JWStatusBarDidSelected)complete;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END

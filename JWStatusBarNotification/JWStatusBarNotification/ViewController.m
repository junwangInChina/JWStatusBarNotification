//
//  ViewController.m
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/19.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import "ViewController.h"

#import "JWStatusBarNotification/JWStatusBarNotification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"JWStatusBarNotification";
    
    [[JWStatusBarNotification shareInstance] configStyle:@"style1" prepare:^JWStatusBarStyle *(JWStatusBarStyle * _Nonnull style) {
        style.barPositionType = JWStatusBarPositionTypeCoverStatusBar;
        style.barAnimationType = JWStatusBarAnimationTypeDrop;
        
        return style;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showMessage];
}

- (void)showMessage
{
    [[JWStatusBarNotification shareInstance] show:@"测试展示" identifier:@"style1" complete:^{
        NSLog(@"点击了一下");
    }];
}

@end

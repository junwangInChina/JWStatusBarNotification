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
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (assign, nonatomic) JWStatusBarPositionType positionType;
@property (assign, nonatomic) JWStatusBarAnimationType animationType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"JWStatusBarNotification";
    self.animationType = JWStatusBarAnimationTypeNone;
    self.positionType = JWStatusBarPositionTypeCoverStatusBar;
    
}

- (IBAction)positionChanged:(id)sender {
    
    JWStatusBarPositionType tempPositonType = JWStatusBarPositionTypeCoverStatusBar;
    UISegmentedControl *tempSegment = (UISegmentedControl *)sender;
    switch (tempSegment.selectedSegmentIndex)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            tempPositonType = JWStatusBarPositionTypeCoverNavigation;
        }
            break;
        case 2:
        {
            tempPositonType = JWStatusBarPositionTypeCoverStatusBarAndNavigation;
        }
            break;
        case 3:
        {
            tempPositonType = JWStatusBarPositionTypeCustom;
        }
            break;
            
        default:
            break;
    }
    self.positionType = tempPositonType;
}

- (IBAction)animationChanged:(id)sender {
    
    JWStatusBarAnimationType tempAnimationType = JWStatusBarAnimationTypeNone;
    UISegmentedControl *tempSegment = (UISegmentedControl *)sender;
    switch (tempSegment.selectedSegmentIndex)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            tempAnimationType = JWStatusBarAnimationTypeDrop;
        }
            break;
        case 2:
        {
            tempAnimationType = JWStatusBarAnimationTypeLeftToRight;
        }
            break;
        case 3:
        {
            tempAnimationType = JWStatusBarAnimationTypeRightToLeft;
        }
            break;
        case 4:
        {
            tempAnimationType = JWStatusBarAnimationTypeBounce;
        }
            break;
        case 5:
        {
            tempAnimationType = JWStatusBarAnimationTypeFade;
        }
            break;
            
        default:
            break;
    }
    self.animationType = tempAnimationType;
}

- (IBAction)showMsg:(id)sender {
    
    __block typeof(self)weakSelf = self;
    [[JWStatusBarNotification shareInstance] configStyle:@"style1" prepare:^JWStatusBarStyle *(JWStatusBarStyle * _Nonnull style) {
        style.barPositionType = weakSelf.positionType;
        style.barAnimationType = weakSelf.animationType;
        style.barEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
        
        return style;
    }];
    
    
    if (self.positionType == JWStatusBarPositionTypeCustom)
    {
        UIView *tempView = [UIView new];
        tempView.backgroundColor = [UIColor greenColor];
        tempView.frame = CGRectMake(0, 0, 200, 100);
        
        [[JWStatusBarNotification shareInstance] showView:tempView identifier:@"style1" complete:^{
            NSLog(@"点击了一下");
        }];
    }
    else
    {
        NSString *tempStr = self.msgTextField.text.length > 0 ? self.msgTextField.text : @"测试展示";
        [[JWStatusBarNotification shareInstance] show:tempStr identifier:@"style1" complete:^{
            NSLog(@"点击了一下");
        }];
    }
}

@end

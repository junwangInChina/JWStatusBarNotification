//
//  JWStatusBarView.m
//  JWStatusBarNotification
//
//  Created by wangjun on 2019/2/20.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import "JWStatusBarView.h"

@interface JWStatusBarView()

@property (nonatomic, strong, readwrite) UILabel *textLabel;

@end

@implementation JWStatusBarView

#pragma mark dynamic getter

- (UILabel *)textLabel;
{
    if (!_textLabel)
    {
        self.textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.clipsToBounds = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)setTextVerticalPositionAdjustment:(CGFloat)textVerticalPositionAdjustment
{
    _textVerticalPositionAdjustment = textVerticalPositionAdjustment;
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(0,
                                      self.textVerticalPositionAdjustment,
                                      CGRectGetWidth(self.bounds),
                                      CGRectGetHeight(self.bounds) - self.textVerticalPositionAdjustment);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

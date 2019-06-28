//
//  SBSProgressView.m
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "SBSProgressView.h"

static const CGFloat progressHeight = 50;

@interface SBSProgressView ()

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *progressView;


@end


@implementation SBSProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _progressLabel = [UILabel new];
        _progressLabel.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 40);
        [self addSubview:_progressLabel];

        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progressLabel.frame), CGRectGetWidth(frame), progressHeight)];
        _progressView.backgroundColor = [UIColor blueColor];
        [self addSubview:_progressView];
    }
    return self;
}

- (CGFloat)getWidthDependOnProgress
{
    return CGRectGetWidth(self.frame) * _progress;
}


#pragma mark - Setters

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%f%%", progress];
    self.progressView.frame = CGRectMake(CGRectGetMinX(self.progressView.frame), CGRectGetMinY(self.progressView.frame), [self getWidthDependOnProgress], progressHeight);
    if (progress >= 1)
    {
        [self.progressView removeFromSuperview];
        [self.progressLabel removeFromSuperview];
    }
}

@end

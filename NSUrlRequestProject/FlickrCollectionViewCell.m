//
//  FlickrCollectionViewCell.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 27/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "FlickrCollectionViewCell.h"

@interface FlickrCollectionViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation FlickrCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _backView = [UIView new];
        
        _coverImageView = [UIImageView new];
        [self.backView addSubview:_coverImageView];
        
        _titleLabel = [UILabel new];
//        _titleLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.numberOfLines = 2;
        [self.backView addSubview:_titleLabel];
        
        _subtitleLabel = [UILabel new];
//        _subtitleLabel.backgroundColor = [UIColor greenColor];
        [_backView addSubview:_subtitleLabel];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicator setHidesWhenStopped:YES];
        [_coverImageView addSubview:_activityIndicator];
        
        [self.contentView addSubview:_backView];
    }
    return self;
}

- (void)roundView:(UIView *)view onCorner:(UIRectCorner)rectCorner radius:(float)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    [view.layer setMask:maskLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.frame = self.contentView.frame;
    self.backView.layer.cornerRadius = 8.f;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = [UIColor grayColor];
    
    self.coverImageView.frame = CGRectMake(6.f, 6.f, CGRectGetWidth(self.contentView.bounds) - 12.f, CGRectGetWidth(self.contentView.bounds) - 12.f);
    self.coverImageView.layer.cornerRadius = 8.f;
    self.coverImageView.layer.masksToBounds = YES;
    
    self.titleLabel.frame = CGRectMake(6.f, CGRectGetMaxY(self.coverImageView.frame) + 2.f, CGRectGetWidth(self.contentView.bounds) - 12.f, (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(self.coverImageView.frame)) / 2 - 8.f);
    
    self.subtitleLabel.frame = CGRectMake(6.f, CGRectGetMaxY(self.titleLabel.frame) + 2.f, CGRectGetWidth(self.contentView.bounds) - 12.f, (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(self.coverImageView.frame)) / 2 - 8.f);
    
    self.activityIndicator.center = self.coverImageView.center;
    
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.titleLabel.text = nil;
    self.subtitleLabel.text = nil;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

-(void)setCoverImage:(UIImage *)coverImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.coverImageView.image = coverImage;
    });
}

- (void)setIsActivity:(Boolean *)isActivity
{
    if (isActivity)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator startAnimating];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
    }
}


@end

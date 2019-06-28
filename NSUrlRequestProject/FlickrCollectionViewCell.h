//
//  FlickrCollectionViewCell.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 27/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) Boolean isActivity;

@end

NS_ASSUME_NONNULL_END

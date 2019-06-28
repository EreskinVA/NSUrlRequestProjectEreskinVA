//
//  CustomLayout.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 28/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGSize sectionSpacing;

@end

NS_ASSUME_NONNULL_END

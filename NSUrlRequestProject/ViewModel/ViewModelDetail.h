//
//  ViewModelDetail.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewDetail.h"
#import "ModelDetail.h"

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;

@interface ViewModelDetail : NSObject

+ (id)sharedInstanceWithViewController:(ViewDetail *)viewDetail;
@property (strong, nonatomic) ViewDetail *viewDetail;
@property (strong, nonatomic) ModelDetail *model;

@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END

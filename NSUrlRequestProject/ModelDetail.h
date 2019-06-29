//
//  ModelDetail.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelDetail : NSObject

+ (id)sharedInstance;
- (void)setData:(NSDictionary *)data;
- (void)setImage:(NSData *)image;

@property (strong, nonatomic) NSDictionary *dataDetailDictionary;

@end

NS_ASSUME_NONNULL_END

//
//  ModelMain.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelMain : NSObject

+ (id)sharedInstance;
- (void)loadData:(NSString *)searchString pagesLoading:(NSString *)pagesLoading;

@property (strong, nonatomic) NSDictionary *dataMainDictionary;

@end

NS_ASSUME_NONNULL_END

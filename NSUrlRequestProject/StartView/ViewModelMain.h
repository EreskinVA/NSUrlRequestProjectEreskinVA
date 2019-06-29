//
//  ViewModelMain.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewMain.h"
#import "ModelMain.h"

@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@interface ViewModelMain : NSObject

+ (id)sharedInstanceWithViewController:(ViewMain *)viewMain;
@property (strong, nonatomic) ViewMain *viewMain;
@property (strong, nonatomic) ModelMain *model;
- (void)getData:(NSString *)searchString pagesLoading:(NSString *)pagesLoading;

@end

NS_ASSUME_NONNULL_END

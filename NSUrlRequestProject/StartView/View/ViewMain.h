//
//  ViewMain.h
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewMain : UIViewController

@property (strong, nonatomic) NSArray<NSString *> *dataMain;
@property (nonatomic, strong) NSString* pushSearchText;
- (void)sheduleLocalNotification;

@end

NS_ASSUME_NONNULL_END

//
//  SBSProgressView.h
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBSProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isAnimationRunning;

@end

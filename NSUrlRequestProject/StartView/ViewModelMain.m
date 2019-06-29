//
//  ViewModelMain.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ViewModelMain.h"
#import "ModelMain.h"

@interface ViewModelMain ()

@end

@implementation ViewModelMain

+ (id)sharedInstanceWithViewController:(ViewMain *)viewMain
{
    
    static ViewModelMain *viewModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        viewModel = [[self alloc] initWithViewController:(ViewMain *)viewMain];
    });
    
    return viewModel;
}

- (id) initWithViewController:(ViewMain *)viewMain
{
    self = [super init];
    
    if (self)
    {
        self.viewMain = viewMain;
        self.model = [ModelMain sharedInstance];
    }
    
    return self;
}

- (void)getData:(NSString *)searchString pagesLoading:(NSString *)pagesLoading
{
    [self.model loadData:searchString pagesLoading:pagesLoading];
}

@end

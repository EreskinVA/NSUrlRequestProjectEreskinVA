//
//  ModelMain.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ModelMain.h"
#import "NetworkService.h"
#import "NetworkHelper.h"

@interface ModelMain () <NetworkServiceOutputProtocol>

@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation ModelMain

+ (id)sharedInstance
{
    
    // создание одного общего экземпляра данной модели
    static ModelMain *data = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        data = [[self alloc] init];
    });
    
    return data;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.networkService = [NetworkService new];
        self.networkService.output = self;
    }
    
    return self;
}

- (void)loadData:(NSString *)searchString pagesLoading:(NSString *)pagesLoading
{
    [self.networkService findFlickrPhotoWithSearchString:searchString page:pagesLoading];
}

- (void)loadingIsDonePhoto:(NSDictionary *)data
{
    [self setValue:data[@"photo"] forKey:@"dataMainDictionary"];
}

@end

//
//  ViewModelDetail.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ViewModelDetail.h"
#import "ModelDetail.h"
#import "NetworkService.h"
#import "NetworkHelper.h"

@interface ViewModelDetail ()

@property (nonatomic, strong) NSMutableDictionary *detailData;

@end

@implementation ViewModelDetail

+ (id)sharedInstanceWithViewController:(ViewDetail *)viewDetail
{
    
    static ViewModelDetail *viewModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        viewModel = [[self alloc] initWithViewController:(ViewDetail *)viewDetail];
    });
    
    return viewModel;
}

- (id) initWithViewController:(ViewDetail *)viewDetail
{
    self = [super init];
    
    if (self)
    {
        self.viewDetail = viewDetail;
        self.model = [ModelDetail sharedInstance];
    }
    
    return self;
}

- (void)setData:(NSDictionary *)data
{
    self.detailData = data.mutableCopy;
    
    if (data[@"selectedImage"] == nil)
    {
        [self loadImage];
    }
    
    [self.model setData:self.detailData];
}

// загрузка картинки из сети
- (void)loadImage
{
    NetworkService *networkService = [NetworkService new];
    [networkService configureUrlSessionWithParams:nil];
    NSString *urlString = [NetworkHelper URLForGetPhoto:self.detailData[@"id"]
                                                 farmId:self.detailData[@"farm"]
                                               serverId:self.detailData[@"server"]
                                               secretId:self.detailData[@"secret"]];
    
    [networkService startImageLoading:urlString success:^(NSData *data) {
        if (data != nil)
        {
            [self.model setImage:data];
        }
    }];
}

@end

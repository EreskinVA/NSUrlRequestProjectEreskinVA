//
//  ModelDetail.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ModelDetail.h"

@implementation ModelDetail

+ (id)sharedInstance
{
    
    // создание одного общего экземпляра данной модели
    static ModelDetail *data = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        data = [[self alloc] init];
    });
    
    return data;
}

- (id)init
{
    self = [super init];
    
    if (self) {
//      [self loadData];
    }
    
    return self;
}

//- (void)loadData
//{
//}

- (void)setData:(NSDictionary *)data
{
    [self setValue:data forKey:@"dataDetailDictionary"];
}

- (void)setImage:(NSData *)image
{
    NSMutableDictionary *curentData = [self valueForKey:@"dataDetailDictionary"];
    [curentData setValue:image forKey:@"selectedImage"];
    [self setValue:curentData forKey:@"dataDetailDictionary"];
}

@end

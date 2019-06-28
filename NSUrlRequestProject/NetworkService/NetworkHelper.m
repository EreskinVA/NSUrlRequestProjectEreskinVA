//
//  NetworkHelper.m
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (NSString *)URLForSearchString:(NSString *)searchString
{
    NSString *APIKey = @"36afdf0b49408215a558fe193648faac";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=25&format=json&nojsoncallback=1", APIKey, searchString];
}

+ (NSString *)URLForGetPhoto:(NSString *)photoId farmId:(NSString *)farmId serverId:(NSString *)serverId secretId:(NSString *)secretId
{
    
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmId, serverId, photoId, secretId];
// Для получение деталей по фото
// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
// example https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
}
    
@end

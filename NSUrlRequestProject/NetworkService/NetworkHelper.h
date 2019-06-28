//
//  NetworkHelper.h
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

+ (NSString *)URLForSearchString:(NSString *)searchString;
+ (NSString *)URLForGetPhoto:(NSString *)photoId farmId:(NSString *)farmId serverId:(NSString *)serverId secretId:(NSString *)secretId;

@end

//
//  NetworkUtilities.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/7/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NetworkUtilities : NSObject
+ (RACSignal *)fetchJSONFromURL:(NSURL *)url;
+ (RACSignal *)downloadImage:(NSURL *)url;
+ (RACSignal *)postJsonToUrl:(NSDictionary *)dictionary url:(NSString *)url;
@end

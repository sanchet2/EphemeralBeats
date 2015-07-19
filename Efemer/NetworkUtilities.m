//
//  NetworkUtilities.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/7/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "NetworkUtilities.h"
#import <AFNetworking/AFNetworking.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Constants.h"

@interface NetworkUtilities()

@end

@implementation NetworkUtilities

#pragma mark - Post request AFNetworking
+(RACSignal *)postJsonToUrl:(NSDictionary *)dictionary url:(NSString *)url{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.requestSerializer = serializer;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        DDLogVerbose(@"%@ POST",url);
        [manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DDLogVerbose(@"Success");
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DDLogError(@"%@ Error POST",error);
            [subscriber sendError:error];
        }];
        return nil;
    }]subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}
#pragma mark - Fetch json from server GET request

+ (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    DDLogVerbose(@"Fetching: %@",url.absoluteString);
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    [subscriber sendNext:json];
                }
                else {
                    [subscriber sendError:jsonError];
                    DDLogError(@"%@ Error GET",error);
                }
            }
            else {
                [subscriber sendError:error];
                DDLogError(@"%@ Error GET",error);
            }
            
            [subscriber sendCompleted];
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        DDLogError(@"%@ Error GET",error);
    }]subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}

#pragma mark - Fetch Image from url

+ (RACSignal *)downloadImage:(NSURL *)url{
    DDLogVerbose(@"%@ IMAGE",url);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [NetworkUtilities downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
                DDLogVerbose(@"SUCCESS IMAGE");
            }
            else{
                NSError *error;
                [subscriber sendError:error];
                DDLogError(@"%@ Error IMAGE",error);
            }
        }];
        return nil;
    }]subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    DDLogVerbose(@"Success");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end

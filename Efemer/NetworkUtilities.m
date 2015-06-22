//
//  NetworkUtilities.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/7/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "NetworkUtilities.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkUtilities()
@property (nonatomic,strong)NSURLSession *session;
@end

@implementation NetworkUtilities

#pragma mark - Singleton Class
+ (id)sharedManager {
    static NetworkUtilities *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(id)init{
    if (self=[super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

#pragma mark - Post request AFNetworking
-(RACSignal *)postJsonToUrl:(NSDictionary *)dictionary url:(NSString *)url{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [subscriber sendNext:responseObject];
        [subscriber sendCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [subscriber sendError:error];
    }];
        return nil;
    }];
}
#pragma mark - Fetch json from server GET request

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@",url.absoluteString);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    [subscriber sendNext:json];
                }
                else {
                    [subscriber sendError:jsonError];
                }
            }
            else {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Fetch Image from url

-(RACSignal *)downloadImage:(NSURL *)url{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
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

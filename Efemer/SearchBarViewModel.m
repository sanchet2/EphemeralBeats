//
//  SearchBarViewModel.m
//  Efemer
//
//  Created by Nikhil Sancheti on 6/2/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchBarViewModel.h"


@interface SearchBarViewModel ()
@property (nonatomic,strong)NSURLSession *session;
@end

@implementation SearchBarViewModel
+ (id)sharedManager {
    static SearchBarViewModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(id)init
{
    if (self=[super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
        [self searchBar];
    }
    return self;
}
-(void)searchBar{
    [[[[RACObserve(self, textInput)
        filter:^BOOL(NSString *input){
            return [input length]>3;
        }]  map:^NSString*(NSString *input){
            //TODO: need to replace spaces with %20
            NSString *needed=[input stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            return [NSString stringWithFormat:@"http://api.soundcloud.com/tracks.json?client_id=4346c8125f4f5c40ad666bacd8e96498&q=%@&limit=20&streamable=yes",needed];
        }] throttle:0.5]
     subscribeNext:^(NSString *url){
         //hack
         [[self fetchJSONFromURL:[NSURL URLWithString:url]]subscribeNext:^(id x){
                                                                   NSLog(@"%@",x);
         }
                                                                   error:^(NSError *error){
                                                                       NSLog(@"%@",error);
                                                                   }];
     }];
    
}
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

@end

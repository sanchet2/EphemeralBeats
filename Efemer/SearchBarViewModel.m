//
//  SearchBarViewModel.m
//  Efemer
//
//  Created by Nikhil Sancheti on 6/2/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchBarViewModel.h"
#import "Song.h"

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
        [[self jsonData]subscribeNext:^(id x){
           
            NSArray* models = [Song arrayOfModelsFromDictionaries:x];
            NSLog(@"%@",models);
        }];
    }
    return self;
}

-(RACSignal *)jsonData{
    return [[[[[RACObserve(self, textInput)
            filter:^BOOL(NSString *input){
             return [input length]>3;
     }]     map:^NSString*(NSString *input){
             NSString *needed=[input stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
             return [NSString stringWithFormat:@"http://api.soundcloud.com/tracks.json?client_id=4346c8125f4f5c40ad666bacd8e96498&q=%@&limit=15&streamable=yes",needed];
     }]     throttle:0.5]
            map:^NSURL *(NSString *url){
             return [NSURL URLWithString:url];
     }]     flattenMap:^(NSURL *url){
             return [self fetchJSONFromURL:url];
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

-(RACSignal *)downloadImage:(NSURL *)url{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
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

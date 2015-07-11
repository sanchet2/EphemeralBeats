//
//  SearchBarViewModel.m
//  Efemer
//
//  Created by Nikhil Sancheti on 6/2/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchBarViewModel.h"
#import "Song.h"
#import "NetworkUtilities.h"

@interface SearchBarViewModel ()
@property (strong,nonatomic) NetworkUtilities *util;
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
        RAC(self,songs)=[self addJsonToModel];
        
    }
    return self;
}
-(RACSignal *)addJsonToModel
{
    return [[self jsonData] map:^NSArray *(id x){
    NSArray* models = [Song arrayOfModelsFromDictionaries:x];
        return models;
    }];
    
}
-(RACSignal *)jsonData{
    return [[[[[RACObserve(self, textInput)
            filter:^BOOL(NSString *input){
             return [input length]>0;
     }]     map:^NSString*(NSString *input){
             NSString *needed=[input stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
             return [NSString stringWithFormat:@"http://api.soundcloud.com/tracks.json?client_id=4346c8125f4f5c40ad666bacd8e96498&q=%@&streamable=true&limit=25&state=finished&downloadable=true",needed];
     }]     throttle:0.5]
            map:^NSURL *(NSString *url){
             return [NSURL URLWithString:url];
     }]     flattenMap:^(NSURL *url){
             return [NetworkUtilities fetchJSONFromURL:url];
     }];
}




@end

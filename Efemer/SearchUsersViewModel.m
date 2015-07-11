//
//  SearchUsersViewModel.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/8/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchUsersViewModel.h"
#import "NetworkUtilities.h"
#import "UserSearch.h"

NSString *const urlsearch = @"http://104.236.188.213:3000/user/query/";


@implementation SearchUsersViewModel
+ (id)sharedManager {
    static SearchUsersViewModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    if (self=[super init]) {
        [self getUserList];
        
    }
    return self;
}
-(RACSignal *)getUserList{
    return [[[[[RACObserve(self,textInput) throttle:0.5]
      filter:^BOOL(NSString *input){
        return [input length]>1;
    }]
      map:^NSURL*(NSString *input){
          return [NSURL URLWithString:[urlsearch stringByAppendingString:input]];
      }]
     flattenMap:^(NSURL *url){
          return [NetworkUtilities fetchJSONFromURL:url];
     }]map:^NSArray *(id x){
         return [UserSearch arrayOfModelsFromDictionaries:x];
     }];
}
@end

//
//  FollowersFirebase.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/9/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "FollowersFirebase.h"
#import <Firebase/Firebase.h>
@interface FollowersFirebase()
@property (strong,nonatomic) NSMutableDictionary *fFollowees;
@property (strong,nonatomic) Firebase *ref;
@end
@implementation FollowersFirebase

+(id) sharedManager{
    static FollowersFirebase *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    if(self=[super init])
    {
        self.ref = [[Firebase alloc] initWithUrl: @"https://torid-fire-8399.firebaseio.com/"];
        self.fFollowees=[[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)addFollowees:(NSString *)user timestamp:(NSString *)timestamp{
    FirebaseHandle handle = [self.ref observeEventType:FEventTypeValue withBlock:^(FDatasnapshot* snapshot) {
    }];
    
    [self.ref removeObserverWithHandle:handle];
}
@end

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
@property (strong,nonatomic) NSArray *references;
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
     
    }
    return self;
}
-(void)addFollowees:(NSString *)user{
    
}
@end

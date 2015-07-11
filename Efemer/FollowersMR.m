//
//  FollowersMR.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/11/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "FollowersMR.h"

@implementation FollowersMR
+(id) sharedManager{
    static FollowersMR *sharedMyManager = nil;
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
@end

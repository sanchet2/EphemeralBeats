//
//  SongQueueViewModel.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/11/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SongQueueViewModel.h"

@implementation SongQueueViewModel

+ (id)sharedManager {
    static SongQueueViewModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init{
    return self;
}


@end

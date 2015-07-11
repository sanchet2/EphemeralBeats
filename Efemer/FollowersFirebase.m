//
//  FollowersFirebase.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/9/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "FollowersFirebase.h"
#import "PlayerQueue.h"
#import "Song.h"
#import "FirebaseHelper.h"

@interface FollowersFirebase()
@property (strong,nonatomic) NSMutableDictionary *fFollowees;
@property (strong,nonatomic) PlayerQueue *playerQueue;
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
        self.fFollowees=[[NSMutableDictionary alloc]init];
        self.playerQueue=[PlayerQueue sharedManager];
    }
    return self;
}
-(void)addReference:(UserSearch *)user{
    FirebaseHelper *helper=[[FirebaseHelper alloc]initWithUser:user];
    [self.fFollowees setObject:helper forKey:user];
    
}

@end

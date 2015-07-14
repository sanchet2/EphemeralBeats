//
//  FirebaseHelper.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/11/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "FirebaseHelper.h"
#import <Firebase/Firebase.h>
#import "UserSearch.h"
#import "PlayerQueue.h"

@interface FirebaseHelper()
@property (strong,nonatomic) Firebase *ref;
@end
@implementation FirebaseHelper

-(id)initWithUser:(UserSearch *)user{
    self=[super init];
    if(self){
        self.ref=[[Firebase alloc] initWithUrl: @"https://torid-fire-8399.firebaseio.com/"];
        Firebase *posts=[self.ref childByAppendingPath:@"posts"];
        Firebase *userFbase=[posts childByAppendingPath:user.username];
        Firebase *tstamp=[userFbase childByAppendingPath:@"timestamp"];
        Firebase *stamp=[tstamp childByAppendingPath:user.timestamp];
        Firebase *song=[stamp childByAppendingPath:@"song"];
        [song observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot* snapshot) {
            NSLog(@"%@",snapshot.value);
            Song *song=[[Song alloc]initWithDictionary:snapshot.value error:nil];
            [[PlayerQueue sharedManager]addSongToQueue:song];
            //TODO: need to set this in the player queue and a
        }];
        
    }
    return self;
}
@end

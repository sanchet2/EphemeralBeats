//
//  FollowersMR.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/11/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "FollowersMR.h"
#import <MagicalRecord/MagicalRecord.h>
#import "UserSearch.h"
#import "Followee.h"
#import "User.h"
#import "Constants.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface FollowersMR ()
@property (strong,nonatomic) User *currentUser;
@end

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
        self.currentUser=[User MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
    }
    return self;
}
-(void)addFolloweeToDisk:(UserSearch *)user
{
    //Store to disk
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_defaultContext];
    Followee *queue    = [Followee MR_createEntityInContext:localContext];
    queue.username=[user username];
    queue.timestamp=[user timestamp];
    queue.relationship=self.currentUser;
    [self.currentUser addFoloweesObject:queue];
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave){
            DDLogVerbose(@"Successfully Followed Followee");
        }
    }];
}

@end

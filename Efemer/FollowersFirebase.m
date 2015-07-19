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
#import "User.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Followee.h"
#import "Constants.h"
#import <MagicalRecord/MagicalRecord.h>

@interface FollowersFirebase()
@property (strong,nonatomic) NSMutableDictionary *fFollowees;
@property (strong,nonatomic) PlayerQueue *playerQueue;
@property (strong,nonatomic) User *currentUser;
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
        //Add All Current references
        self.currentUser=[User MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
        for (Followee* followee in self.currentUser.folowees) {
            [self addReferenceFromCoreData:followee];
        }
        
    }
    return self;
}
-(void)addReference:(UserSearch *)user{
    FirebaseHelper *helper=[[FirebaseHelper alloc]initWithUser:user];
    [self.fFollowees setObject:helper forKey:user];
    
}
-(void)addReferenceFromCoreData:(Followee *)folowee{
    UserSearch *user=[[UserSearch alloc]init];
    user.timestamp=folowee.timestamp;
    user.username=folowee.username;
    [self addReference:user];
}
-(void)addFolloweeToDisk:(UserSearch *)user
{
    //Store to disk
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_defaultContext];
    Followee *queue    = [Followee MR_createEntityInContext:localContext];
    queue.username=[user username];
    queue.timestamp=[user timestamp];
    
    //Add CoreData Reference
    [self addReferenceFromCoreData:queue];
    
    queue.relationship=self.currentUser;
    [self.currentUser addFoloweesObject:queue];
    

            DDLogVerbose(@"Successfully Followed Followee");
}


@end

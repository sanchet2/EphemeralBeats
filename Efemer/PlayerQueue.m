//
//  PlayerQueue.m
//  Beatport
//
//  Created by Nikhil Sancheti on 7/1/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "PlayerQueue.h"
#import <Firebase/Firebase.h>
#import <MagicalRecord/MagicalRecord.h>
#import "SongsQueue.h"
#import "Constants.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "UserSearch.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PlayerQueue()
@property (strong,nonatomic) NSManagedObjectContext *localContext;
@end
@implementation PlayerQueue

+(id) sharedManager{
    static PlayerQueue *sharedMyManager = nil;
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
        self.player=[StreamingPlayer sharedManager];
        self.localContext = [NSManagedObjectContext MR_defaultContext];
        self.songs=[[NSMutableArray alloc]init];
        [self.songs addObjectsFromArray:[SongsQueue MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"ANY relationship == %@",self.currentUser]]];
        self.songs=[NSMutableArray arrayWithArray:[[NSSet setWithArray:self.songs]allObjects] ];
        
        @weakify(self);
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"BeatportAddSongToQueue" object:nil]subscribeNext:^(NSDictionary *dict){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                NSError *err;
                [self.songs addObject:[[Song alloc]initWithDictionary:[dict valueForKey:@"userInfo"] error:&err]];
                
                //            [self.collectionView reloadItemsAtIndexPaths:indexPathsToLoad];
            });
            
        }];
        
    }
    return self;
}

-(void) addSongToShareQueue: (Song *)song{
    //Add Song To Song Queue
    [self.player addSongToQueue:song];
    [self postToFirebase:song];
    [self addSongToDisk:song];
    
}
-(void)playSongWithoutExtras:(Song *)song{
    [self.player playSong:song];
}
-(void)playSong:(Song *)song{
    [self.player playSong:song];
    [self postToFirebase:song];
    [self addSongToDisk:song];
}
-(void)postToFirebase:(Song *)song{
    //Firebase POST
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://torid-fire-8399.firebaseio.com/"];
    Firebase *postRef = [ref childByAppendingPath: @"posts"];
    Firebase *userRef = [postRef childByAppendingPath:self.currentUser.username];
    Firebase *timestampRef=[userRef childByAppendingPath:@"timestamp"];
    NSNumber *num=[NSNumber numberWithDouble:[self.currentUser.timestamp timeIntervalSince1970] ];
    Firebase *tref=[timestampRef childByAppendingPath:[num stringValue]];
    Firebase *songRef=[tref childByAppendingPath:@"song"];
    
    NSDictionary *post1 = [song toDictionary];
    Firebase *post1Ref = [songRef childByAutoId];
    [post1Ref setValue: post1];
}
-(void) addSongToIncognitoQueue: (Song *)song{
    //Add Song To Song Queue
    [self.player addSongToQueue:song];
    
    //Store to disk
    [self addSongToDisk:song];
    
}
-(void) addSongtoQueueFromOthers:(Song *)song followee:(UserSearch *)user{
    [self.player addSongToQueue:song];
    [self addSongToDisk:song];
}

-(void)addSongToDisk:(Song *)song
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BeatportAddSongToQueue" object:nil userInfo:[song toDictionary]];
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_defaultContext];
    SongsQueue *queue    = [SongsQueue MR_createEntityInContext:localContext];
    queue.title=[song title];
    queue.stream_url=[song stream_url];
    queue.artwork_url=[song artwork_url];
    queue.relationship=self.currentUser;
    [self.currentUser addPlaylistSongsObject:queue];
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave){
            DDLogVerbose(@"Successfully Saved song");
        }
    }];
}
-(void) removeSongFromShareQueue: (Song *)song{
    
}
-(void) clearQueue{
    
}
@end

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


@interface PlayerQueue()

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
    }
    return self;
}

-(void) addSongToShareQueue: (Song *)song{
    //Add Song To Song Queue
    [self.player playSong:[NSString stringWithFormat:@"%@?client_id=4346c8125f4f5c40ad666bacd8e96498",song.stream_url]];
    [self.songQueue addObject:song];
    
    //Firebase POST
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://torid-fire-8399.firebaseio.com/"];
    Firebase *postRef = [ref childByAppendingPath: @"posts"];
    Firebase *userRef = [postRef childByAppendingPath:self.currentUser.username];
    NSDictionary *post1 = [song toDictionary];
    Firebase *post1Ref = [userRef childByAutoId];
    [post1Ref setValue: post1];
    
    //Store to disk
    SongsQueue *queue=[SongsQueue MR_createEntity];
    queue.title=[song title];
    queue.stream_url=[song stream_url];
    queue.artwork_url=[[song artwork_url]absoluteString];
    [self.currentUser addPlaylistSongsObject:queue];
    
}
-(void) addSongToIncognitoQueue: (Song *)song{
    //Add Song To Song Queue
    [self.player playSong:[NSString stringWithFormat:@"%@?client_id=4346c8125f4f5c40ad666bacd8e96498",song.stream_url]];
    [self.songQueue addObject:song];
    
    //Store to disk
    SongsQueue *queue=[SongsQueue MR_createEntity];
    queue.title=[song title];
    queue.stream_url=[song stream_url];
    queue.artwork_url=[[song artwork_url]absoluteString];
    [self.currentUser addPlaylistSongsObject:queue];
    
}
-(void) removeSongFromShareQueue: (Song *)song{
    
}
-(void) clearQueue{
    
}
@end

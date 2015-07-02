//
//  PlayerQueue.h
//  Beatport
//
//  Created by Nikhil Sancheti on 7/1/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@interface PlayerQueue : NSObject
+(id) sharedManager;
@property (strong,nonatomic) NSNumber *currentSong;
@property (strong,nonatomic) NSMutableArray *songQueue;
-(void) addSongToShareQueue: (Song *)song;
-(void) addSongToIncognitoQueue: (Song *)song;
-(void) removeSongFromShareQueue: (Song *)song;
-(void) clearQueue;
@end

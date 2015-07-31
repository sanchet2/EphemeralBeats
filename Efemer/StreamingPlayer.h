//
//  StreamingPlayer.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StreamingKit/STKAudioPlayer.h>
#import "Song.h"

@interface StreamingPlayer : NSObject <STKAudioPlayerDelegate>
//Singleton
+ (id)sharedManager;

//Player functions;
-(void)playSong:(Song *)song;
-(void)pause;
-(void)stop;
-(void)resume;
-(void)dragToPosition:(double)position;
-(void)addSongToQueue:(Song *)song;
-(BOOL)isPlaying;
@end

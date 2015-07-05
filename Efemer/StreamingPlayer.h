//
//  StreamingPlayer.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StreamingKit/STKAudioPlayer.h>

@interface StreamingPlayer : NSObject <STKAudioPlayerDelegate>
//Singleton
+ (id)sharedManager;

//Player functions;
-(void)playSong:(NSString *)url;
-(void)pause;
-(void)stop;
-(void)dragToPosition:(double)position;
@end

//
//  StreamingPlayer.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "StreamingPlayer.h"

@interface StreamingPlayer ()
@property (strong,nonatomic) STKAudioPlayer *audioPlayer;
@end

@implementation StreamingPlayer

+ (id)sharedManager {
    static StreamingPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init{
    if (self=[super init]) {
        self.audioPlayer=[[STKAudioPlayer alloc]init];
        self.audioPlayer.delegate=self;
    }
    return self;
}

#pragma mark - player functions

-(void)playSong:(Song *)song{
    [self.audioPlayer play:[NSString stringWithFormat:@"%@?client_id=a9010b5801cb1b535f9783959e8a5bbb",song.stream_url]];
}
-(void)pause{
    [self.audioPlayer pause];
}
-(void)stop{
    [self.audioPlayer stop];
}
-(void)dragToPosition:(double)position{
    [self.audioPlayer seekToTime:position];
}
-(void)addSongToQueue:(Song *)song{
    [self.audioPlayer queue:[NSString stringWithFormat:@"%@?client_id=a9010b5801cb1b535f9783959e8a5bbb",song.stream_url]];
}

#pragma mark - Audio player delegates

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    NSLog(@"%u",errorCode);
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId{
    
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId{
    
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    
}

@end

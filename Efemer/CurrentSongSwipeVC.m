//
//  SongQueueCollectionVC.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/11/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "CurrentSongSwipeVC.h"
#import <SwipeView/SwipeView.h>
#import "StreamingPlayer.h"

@interface CurrentSongSwipeVC ()
@property (strong,nonatomic) SwipeView *swipeView;
@property (strong,nonatomic) UIButton *play;
@property (strong,nonatomic) UIButton *pause;
@property (strong,nonatomic) UIButton *fastfoward;
@property (strong,nonatomic) UIButton *back;
@property (strong,nonatomic) StreamingPlayer *player;
@end

@implementation CurrentSongSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player=[StreamingPlayer sharedManager];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    self.play = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.play.frame = CGRectMake(self.view.frame.size.width/2-30, 10, 25, 25);
    [self.play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    self.play.tintColor=[UIColor whiteColor];
    [self.play addTarget:self
                  action:@selector(pausePlayer)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.play];
    
    self.fastfoward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.fastfoward.frame = CGRectMake(self.view.frame.size.width/2+60, 10, 25, 25);
    [self.fastfoward setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    self.fastfoward.tintColor=[UIColor whiteColor];
    [self.fastfoward addTarget:self
                  action:@selector(forward)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fastfoward];
    
    self.back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.back.frame = CGRectMake(self.view.frame.size.width/2-120, 10, 25, 25);
    [self.back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.back.tintColor=[UIColor whiteColor];
    [self.back addTarget:self
                        action:@selector(back)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.back];
    
}

-(void)forward{
    [self.player forward];
}

-(void)pausePlayer{
    if (self.player.isPlaying) {
        [self.player pause];
        [self.play setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
       
    }
    else{
        [[StreamingPlayer sharedManager]resume];
        [self.play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}


@end

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
@end

@implementation CurrentSongSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.9];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 70, 70);
    [btn setTitle:@"Pause" forState:UIControlStateNormal];\
    [btn addTarget:self
            action:@selector(pause)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)pause{
    if ([[StreamingPlayer sharedManager]isPlaying]) {
    [[StreamingPlayer sharedManager]pause];
    }
    else{
        [[StreamingPlayer sharedManager]resume];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}


@end

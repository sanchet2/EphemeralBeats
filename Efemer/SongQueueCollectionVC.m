//
//  DiscoverPlaylistVC.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SongQueueCollectionVC.h"
#import "User.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NetworkUtilities.h"
#import "SongsQueue.h"
#import "Song.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlayerQueue.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "FollowersFirebase.h"

@interface SongQueueCollectionVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) User *currentUser;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) PlayerQueue *queue;
@property (strong,nonatomic) NSMutableArray *songs;
@end

@implementation SongQueueCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.queue=[PlayerQueue sharedManager];
    [FollowersFirebase sharedManager];
    self.view.backgroundColor=[UIColor whiteColor];
    CGRect size=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-70);
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=0.5f;
    layout.minimumLineSpacing=0.8f;
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.collectionView=[[UICollectionView alloc]initWithFrame:size collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundView.backgroundColor=[UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.collectionView];
    self.currentUser=[User MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
    self.songs=[[NSMutableArray alloc]init];
    [self.songs addObjectsFromArray:[SongsQueue MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"ANY relationship == %@",self.currentUser]]];
    self.songs=[NSMutableArray arrayWithArray:[[NSSet setWithArray:self.songs]allObjects] ];
    
    [RACObserve(self.queue, addedSong) subscribeNext:^(Song *song){
        if (song!=nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.songs addObject:song];
                NSMutableArray *indexPathsToLoad = [NSMutableArray new];
                [indexPathsToLoad addObject:[NSIndexPath indexPathForItem:self.songs.count-1 inSection:0]];
                [self.collectionView insertItemsAtIndexPaths:indexPathsToLoad];
            });
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.songs.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.7];
    SongsQueue *song=[self.songs objectAtIndex:indexPath.row];
    NSString *url=[song.artwork_url stringByReplacingOccurrencesOfString:@"large" withString:@"t300x300"];
    NSURL *neededurl=[NSURL URLWithString:url];
    ASImageNode *imgView=[[ASImageNode alloc]init];
    imgView.frame=CGRectMake(0, 0, self.view.frame.size.width/2-1, self.view.frame.size.width/2-1);
    RAC(imgView,image)=[NetworkUtilities downloadImage:neededurl];
    
    cell.backgroundView=imgView.view;
    cell.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^() {
        cell.alpha = 1.0f;
    }];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2-1, self.view.frame.size.width/2-1);
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
    
    return attr;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.queue playSongWithoutExtras:[self.songs objectAtIndex:indexPath.row]];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//-(void)viewWillAppear:(BOOL)animated {
//    self.songs=[self.currentUser.playlistSongs allObjects];
//    [self.collectionView reloadData];
//}

@end

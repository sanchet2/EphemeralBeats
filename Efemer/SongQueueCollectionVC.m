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


@interface SongQueueCollectionVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) User *currentUser;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *songs;
@end

@implementation SongQueueCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser=[User MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
    self.view.backgroundColor=[UIColor whiteColor];
    CGRect size=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=0.5f;
    layout.minimumLineSpacing=0.8f;
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
     self.collectionView=[[UICollectionView alloc]initWithFrame:size collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundView.backgroundColor=[UIColor whiteColor];
    self.songs=[SongsQueue MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"ANY relationship == %@",self.currentUser]];
    
    
    [self.view addSubview:self.collectionView];
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
    SongsQueue *song=[self.songs objectAtIndex:indexPath.row];
    if (song.artwork_url) {
        NSString *url=song.artwork_url;
        NSURL *neededurl=[NSURL URLWithString:url];
        @weakify(self);
        [[[[NetworkUtilities downloadImage:neededurl] deliverOn:RACScheduler.mainThreadScheduler] takeUntil:[cell rac_signalForSelector:@selector(prepareForReuse)]]subscribeNext:^(UIImage *img){
            @strongify(self);
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-3, 120)];
            imgView.image=img;
            cell.backgroundView=imgView;
        }];;
    }
    cell.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^() {
        cell.alpha = 1.0f;
    }];

    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/3-3, 120);
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

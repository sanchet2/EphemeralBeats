//
//  SearchBarVC.m
//  Efemer
//
//  Created by Nikhil Sancheti on 6/2/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchBarVC.h"
#import "SearchBarViewModel.h"
#import "SearchCell.h"
#import "Song.h"
#import "SearchUsersVC.h"
#import "NetworkUtilities.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Constants.h"
#import "PlayerQueue.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchBarVC ()
@property (nonatomic,strong) UITextField *searchQuery;
@property (nonatomic,strong) SearchBarViewModel *viewModel;
@property (nonatomic,strong) UITableView *searchTable;
@property (nonatomic,strong) PlayerQueue *player;
@end

@implementation SearchBarVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        self.viewModel=[SearchBarViewModel sharedManager];
        self.player=[PlayerQueue sharedManager];
        [[SDImageCache sharedImageCache]setMaxMemoryCountLimit:30];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:true];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.searchQuery= [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 40)];
    self.searchQuery.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.searchQuery.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.searchQuery.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
    self.searchQuery.text=@"beatles";
    self.searchQuery.delegate=self;
    [self.view addSubview:self.searchQuery];
    
    self.searchTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-90) style:UITableViewStyleGrouped];
    self.searchTable.delegate=self;
    self.searchTable.dataSource=self;
    self.searchTable.backgroundColor=[UIColor clearColor];
    self.searchTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:self.searchTable];
    //KVO on the array in view model that is updated
    
    @weakify(self);
    [RACObserve(self.viewModel, songs) subscribeNext:^(NSArray *songs){
        DDLogInfo(@"New Song List");
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 [self.searchTable reloadData];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        });
        for(Song *song in songs)
        {
            NSString *finalurl=[song.artwork_url stringByReplacingOccurrencesOfString:@"large" withString:@"t300x300"];
            NSURL *neededurl=[NSURL URLWithString:finalurl];
            [[NetworkUtilities downloadImage:neededurl]subscribeCompleted:^{DDLogVerbose(@"more cells");}];
        }
        
    }];
    [self.searchQuery.rac_textSignal subscribeNext:^(NSString *input){
        @strongify(self);
        if ([input length]==0) {
            [self.searchTable setHidden:YES];
        }
        else {
            [self.searchTable setHidden:NO];
        }
    }];
    
    
    [self bindToModelView];
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.searchTable addGestureRecognizer:tapBackground];
    
}
-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Table View Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.songs.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;//can add categories here later
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
//- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
//    Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
//    [self.player playSong:song];
//}
//-(void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{
//    Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
//    [self.player playSong:song];
// }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"beatport cell";
    SearchCell *cell = (SearchCell *)[self.searchTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        @weakify(self);
        [[cell.share rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *sender){
            @strongify(self);
            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.searchTable];
            NSIndexPath *indexPath = [self.searchTable indexPathForRowAtPoint:buttonPosition];
            DDLogVerbose(@"SHARE %ld",(long)indexPath.row);
            Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
            [self.player addSongToShareQueue:song];
            
        }];
        [[cell.incognito rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *sender){
            @strongify(self);
            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.searchTable];
            NSIndexPath *indexPath = [self.searchTable indexPathForRowAtPoint:buttonPosition];
            DDLogVerbose(@"INCOGNITO %ld",(long)indexPath.row);
            Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
            [self.player addSongToIncognitoQueue:song];
        }];
        
        [[cell.play rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *sender){
            @strongify(self);
            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.searchTable];
            NSIndexPath *indexPath = [self.searchTable indexPathForRowAtPoint:buttonPosition];
            DDLogVerbose(@"PLAY %ld",(long)indexPath.row);
            Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
            [self.player playSong:song];
        }];
        
    }
    if (indexPath.row<[[self.viewModel songs]count]) {
        Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
        NSString *url=song.artwork_url;
        NSString *finalurl=[url stringByReplacingOccurrencesOfString:@"large" withString:@"t300x300"];
        NSURL *neededurl=[NSURL URLWithString:finalurl];
        RAC(cell.bgImage,image)=[[NetworkUtilities downloadImage:neededurl] takeUntil:[cell rac_signalForSelector:@selector(prepareForReuse)]];
        NSArray *titles=[song.title componentsSeparatedByString:@"-"];
        if (titles.count>=2) {
            cell.song.text=[titles objectAtIndex:0];
            cell.artist.text=[titles objectAtIndex:1];
        }
        else{
          cell.artist.text=song.title;
        }
        
        
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - add bindings to viewModel

-(void)bindToModelView
{
    RAC(self.viewModel,textInput)=self.searchQuery.rac_textSignal;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

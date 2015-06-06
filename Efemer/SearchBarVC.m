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

@interface SearchBarVC ()
@property (nonatomic,strong) UITextField *searchQuery;
@property (nonatomic,strong) SearchBarViewModel *viewModel;
@property (nonatomic,strong) UITableView *searchTable;
@end

@implementation SearchBarVC
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        self.viewModel=[SearchBarViewModel sharedManager];
        
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
    self.searchQuery.backgroundColor=[UIColor whiteColor];
    self.searchQuery.text=@"c";
    [self.view addSubview:self.searchQuery];
    
    self.searchTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.searchTable.delegate=self;
    self.searchTable.dataSource=self;
    self.searchTable.backgroundColor=[UIColor clearColor];
    self.searchTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:self.searchTable];
    @weakify(self);
    [RACObserve(self.viewModel, songs) subscribeNext:^(NSArray *songs){
        NSLog(@"%@",songs);
        dispatch_async(dispatch_get_main_queue(), ^{
         @strongify(self);
        [self.searchTable reloadData];
        });
    }];
    [self bindToModelView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.songs.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;//can add categories here later
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"beatport cell";
    SearchCell *cell = (SearchCell *)[self.searchTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Song *song=[[self.viewModel songs]objectAtIndex:indexPath.row];
    if (song.artwork_url) {
        //TODO: clean this shitty code here
        NSString *url=[song.artwork_url absoluteString];
        NSString *finalurl=[url stringByReplacingOccurrencesOfString:@"large" withString:@"crop"];
        NSURL *neededurl=[NSURL URLWithString:finalurl];
        [[self.viewModel downloadImage:neededurl]subscribeNext:^(UIImage *image){
            dispatch_async(dispatch_get_main_queue(), ^{
            cell.bgImage.image=image;
            });
        }];
    }
    cell.artist.text=song.title;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)bindToModelView
{
    RAC(self.viewModel,textInput)=self.searchQuery.rac_textSignal;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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

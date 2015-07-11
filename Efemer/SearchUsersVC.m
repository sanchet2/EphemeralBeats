//
//  simplyVC.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchUsersVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SearchUsersViewModel.h"
#import "UserSearch.h"

@interface SearchUsersVC ()
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UITextField *searchQuery;
@property (strong,nonatomic) SearchUsersViewModel *viewModel;
@property (strong,nonatomic) NSArray *userSearch;
@property (strong,nonatomic) UIButton *share;
@end

@implementation SearchUsersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel=[SearchUsersViewModel sharedManager];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.searchQuery= [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 40)];
    self.searchQuery.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.searchQuery.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.searchQuery.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
    self.searchQuery.text=@"c";
    [self.view addSubview:self.searchQuery];
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 400) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    RAC(self,userSearch)=[self.viewModel getUserList];
    [RACObserve(self, userSearch) subscribeNext:^(NSArray *x){
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
    }];
    [self bindToModelView];
}

-(void)bindToModelView{
    RAC(self.viewModel,textInput)=self.searchQuery.rac_textSignal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userSearch.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"userSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSearchCell"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        self.share = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.share setTitle:@"Add" forState:UIControlStateNormal];
        self.share.frame = CGRectMake(cell.frame.size.width-40, cell.frame.size.height/2, 40.0, 40.0);
        [self.share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:self.share];
        [[self.share rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *sender){
            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
            
        }];
        
    }
    UserSearch *userObject=[self.userSearch objectAtIndex:indexPath.row];
    cell.textLabel.text=userObject.username;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[userObject.timestamp integerValue]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    cell.detailTextLabel.text=dateString;
    return cell;
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

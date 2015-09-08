//
//  LoginViewController.m
//  Efemer
//
//  Created by Nikhil Sancheti on 5/31/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"
#import "SearchBarVC.h"
#import <RNSwipeViewController/RNSwipeViewController.h>
#import "SearchUsersVC.h"
#import "SongQueueCollectionVC.h"
#import "CurrentSongSwipeVC.h"
#import "NetworkUtilities.h"
#import "User.h"
#import <MagicalRecord/MagicalRecord.h>
#import "LoginSuccess.h"
#import "Constants.h"
#import "SongsQueue.h"


@interface LoginViewController ()
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) LoginViewModel *viewModel;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) NSString *text;
@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.viewModel=[LoginViewModel sharedManager];
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self checkUserState];
    self.userName= [[UITextField alloc] initWithFrame:CGRectMake(80, 200, 200, 40)];
    self.userName.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.userName.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.userName.text=@"username";
    [self.view addSubview:self.userName];
    
    self.button= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:@"Login" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(80.0, 300.0, 160.0, 40.0);
    [self.view addSubview:self.button];
    self.navigationController.navigationBar.hidden = YES;
    [self bindToModelView];
    @weakify(self);
    [RACObserve(self.viewModel, loggedIn) subscribeNext:^(id value) {
        if ([value boolValue]) {
            @strongify(self);
            [self goToNewViewController];
        };
    }];
}
-(void)checkUserState{
    User *user=[User MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
    
    if(user)
    {
        NSString *string=[NSString stringWithFormat:@"http://104.236.188.213:3000/user/%@",[user username]];
        string=[string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSDictionary *session=@{@"session":[user session]};
        @weakify(self)
        [[NetworkUtilities postJsonToUrl:session url:string]subscribeNext:^(id value){
            @strongify(self);
            NSError* err = nil;
            LoginSuccess *success=[[LoginSuccess alloc] initWithData:value error:&err];
            if ([success.status isEqualToString:@"continue"])
            {
                DDLogVerbose(@"Successful Login");
                dispatch_async(dispatch_get_main_queue(), ^{
                    DDLogVerbose(@"Loading Search View Nav Controller");
                    [self goToNewViewController];
                });
            }
            else{
                [User MR_truncateAll];
                [SongsQueue MR_truncateAll];
            }
        }];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RAC bindings
-(void)bindToModelView
{
    RAC(self.viewModel,textInput)=self.userName.rac_textSignal;
    self.button.rac_command=self.viewModel.command;
    RAC(self, text) = RACObserve(self.viewModel, statusMessage);
    
}


#pragma mark - Swipe View Controller after login

-(void)goToNewViewController{
    
    RNSwipeViewController *swipeVC=[[RNSwipeViewController alloc]init];
    swipeVC.view.backgroundColor=[UIColor clearColor];
    swipeVC.leftVisibleWidth=self.view.frame.size.width;
    swipeVC.rightVisibleWidth=self.view.frame.size.width;
    
    SearchBarVC *searchBar=[[SearchBarVC alloc]init];
    swipeVC.centerViewController=searchBar;
    
    SearchUsersVC *searchUsersVC=[[SearchUsersVC alloc]init];
    swipeVC.leftViewController=searchUsersVC;
    
    SongQueueCollectionVC *songCollectionView=[[SongQueueCollectionVC alloc]init];
    songCollectionView.title=@"CollectionView";
    
    swipeVC.rightViewController=songCollectionView;
    
    [self.navigationController presentViewController:swipeVC animated:YES completion:nil];
    
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

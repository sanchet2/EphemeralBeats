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
#import "DiscoverPlaylistVC.h"

@interface LoginViewController ()
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) LoginViewModel *viewModel;
@property (nonatomic,strong) UIButton *button;
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
    
    self.userName= [[UITextField alloc] initWithFrame:CGRectMake(80, 200, 200, 40)];
    self.userName.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.userName.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.userName.backgroundColor=[UIColor greenColor];
    self.userName.text=@"Hello World";
    [self.view addSubview:self.userName];
    
    
    self.button= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button addTarget:self
               action:@selector(goToNewViewController)
     forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Show View" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(80.0, 300.0, 160.0, 40.0);
    [self.view addSubview:self.button];
    
    [self bindToModelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindToModelView
{
    RAC(self.viewModel,textInput)=self.userName.rac_textSignal;
    self.button.rac_command=self.viewModel.command;
    
}
-(void)goToNewViewController{
    //add to navigation bar
    
    RNSwipeViewController *swipeVC=[[RNSwipeViewController alloc]init];
    swipeVC.view.backgroundColor=[UIColor clearColor];
    swipeVC.leftVisibleWidth=self.view.frame.size.width;
    swipeVC.rightVisibleWidth=self.view.frame.size.width;
    
    SearchBarVC *searchBar=[[SearchBarVC alloc]init];
    swipeVC.centerViewController=searchBar;
    
    SearchUsersVC *simply=[[SearchUsersVC alloc]init];
    swipeVC.leftViewController=simply;
    
    DiscoverPlaylistVC *playlistVC=[[DiscoverPlaylistVC alloc]init];
    swipeVC.rightViewController=playlistVC;
    
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

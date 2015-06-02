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

@interface LoginViewController ()
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //initialize view model
    
    self.userName= [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 200, 40)];
    self.userName.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.userName.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.userName.backgroundColor=[UIColor whiteColor];
    self.userName.text=@"Hello World";
    
    [self.view addSubview:self.userName];
    RAC(self.viem)[self.userName.rac_textSignal];
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

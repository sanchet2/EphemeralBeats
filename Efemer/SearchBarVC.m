//
//  SearchBarVC.m
//  Efemer
//
//  Created by Nikhil Sancheti on 6/2/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchBarVC.h"
#import "SearchBarViewModel.h"

@interface SearchBarVC ()
@property (nonatomic,strong) UITextField *searchQuery;
@property (nonatomic,strong) SearchBarViewModel *viewModel;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor yellowColor];
    self.searchQuery= [[UITextField alloc] initWithFrame:CGRectMake(80, 200, 200, 40)];
    self.searchQuery.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.searchQuery.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.searchQuery.backgroundColor=[UIColor greenColor];
    self.searchQuery.text=@"c";
    [self.view addSubview:self.searchQuery];
    [self bindToModelView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)bindToModelView
{
    RAC(self.viewModel,textInput)=self.searchQuery.rac_textSignal;
    
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

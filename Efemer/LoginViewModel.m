//
//  LoginViewModel.m
//  Efemer
//
//  Created by Nikhil Sancheti on 5/31/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "LoginViewModel.h"
#import "User.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NetworkUtilities.h"
@interface LoginViewModel()
@property (strong,nonatomic) NSString *username;
@end
@implementation LoginViewModel

+ (id)sharedManager {
    static LoginViewModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(id)init
{
    if (self=[super init]) {
        RAC(self,username)=RACObserve(self, textInput);
//        self.command=[[RACCommand alloc] initWithSignalBlock:^(id _){
//            @strongify(self);
//            return ;
//        }];
        
        self.command = [[RACCommand alloc] initWithSignalBlock:^(id sender) {
            // The hypothetical -logIn method returns a signal that sends a value when
            // the network request finishes.
            return [[NetworkUtilities sharedManager]postJsonToUrl:@{@"username":self.username} url:@"http://104.236.188.213:3000/user"];
        }];
        
        // -executionSignals returns a signal that includes the signals returned from
        // the above block, one for each time the command is executed.
       
        
        RACSignal *sig=[self.command.executionSignals flatten];
            [sig subscribeNext:^(id val){
                NSLog(@"%@",val);
            } error:^(NSError *error){
                NSLog(@"%@",error);
            }];
        
        
    
    }
    return self;
}
-(RACCommand *)subscribeCommand{
    
    
    return self.command;
}

- (void)persistNewUser:(NSString *)username session:(NSString *)session age:(NSDate *)age
{
    // Get the local context
    
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_defaultContext];
    User *user    = [User MR_createEntityInContext:localContext];
    user.username = username;
    user.session  = session;
    user.timestamp= age;
    [localContext MR_saveToPersistentStoreAndWait];
}

@end

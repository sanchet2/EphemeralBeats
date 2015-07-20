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
#import "FirstLoginUser.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Constants.h"

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
        self.loggedIn=[NSNumber numberWithInt:false];
        _command = [[RACCommand alloc] initWithSignalBlock:^(id sender) {
            self.username=[self.username stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            return [NetworkUtilities postJsonToUrl:@{@"username":self.username} url:@"http://104.236.188.213:3000/user"];
        }];
        @weakify(self);
        [[[_command executionSignals] flatten]subscribeNext:^(id x){
            @strongify(self);
            NSError *err=nil;
            FirstLoginUser *user=[[FirstLoginUser alloc]initWithData:x error:&err];
            [self persistNewUser:user.username session:user.session age:[NSDate dateWithTimeIntervalSince1970:[user.timestamp doubleValue]]];
            DDLogVerbose(@"%@",user);
            self.loggedIn=[NSNumber numberWithInt:true];
        }];
        
    }
    return self;
}

- (void)persistNewUser:(NSString *)username session:(NSString *)session age:(NSDate *)age
{
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_defaultContext];
    User *user    = [User MR_createEntityInContext:localContext];
    user.username = username;
    user.session  = session;
    user.timestamp= age;
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave){
            DDLogVerbose(@"Successfully Persisted User");
        }
    }];

    }

@end

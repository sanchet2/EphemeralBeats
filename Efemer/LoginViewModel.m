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
        RACCommand *sig=[self subscribeCommand];
        [sig.executionSignals subscribeNext:^(id val){
           NSLog(@"%@",val);
        }];
        RACSignal *completedMessageSource = [self.command.executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
            return [[[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
                return event.eventType == RACEventTypeCompleted;
            }] map:^id(id value) {
                NSLog(@"%@",value);
                return NSLocalizedString(@"Thanks", nil);
            }];
        }];
        [completedMessageSource subscribeNext:^(id value){
            NSLog(@"%@",value);
        }];
    }
    return self;
}
-(RACCommand *)subscribeCommand{
    @weakify(self);
     return [self.command initWithSignalBlock:^RACSignal *(id input){
        @strongify(self);
        return [[NetworkUtilities sharedManager]postJsonToUrl:@{@"username":self.username} url:@"http://104.236.188.213:3000/user"];
     }];
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

//
//  LoginViewModel.h
//  Efemer
//
//  Created by Nikhil Sancheti on 5/31/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewModel : NSObject
+ (id)sharedManager;
@property (strong,nonatomic) RACSignal *textInput;
@property (strong,nonatomic) RACCommand *command;
@end

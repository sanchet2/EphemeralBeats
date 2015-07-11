//
//  SearchUsersViewModel.h
//  Beatport
//
//  Created by Nikhil Sancheti on 7/8/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SearchUsersViewModel : NSObject
@property (strong,nonatomic) NSString *textInput;
-(RACSignal *)getUserList;
+ (id)sharedManager;
@end

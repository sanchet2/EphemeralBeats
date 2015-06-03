//
//  SearchBarViewModel.h
//  Efemer
//
//  Created by Nikhil Sancheti on 6/2/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SearchBarViewModel : NSObject
@property (strong,nonatomic) NSString *textInput;
+ (id)sharedManager;
@end

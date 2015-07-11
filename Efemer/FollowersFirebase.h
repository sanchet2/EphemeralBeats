//
//  FollowersFirebase.h
//  Beatport
//
//  Created by Nikhil Sancheti on 7/9/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSearch.h"

@interface FollowersFirebase : NSObject
+(id) sharedManager;
-(void)addReference:(UserSearch *)user;

@end

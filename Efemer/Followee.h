//
//  Followee.h
//  Beatport
//
//  Created by Nikhil Sancheti on 7/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Followee : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) User *relationship;

@end

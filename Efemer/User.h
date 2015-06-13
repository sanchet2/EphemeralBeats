//
//  User.h
//  
//
//  Created by Nikhil Sancheti on 6/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * session;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * username;

@end

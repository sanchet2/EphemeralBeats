//
//  SongsQueue.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/30/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SongsQueue : NSManagedObject

@property (nonatomic, retain) NSString * stream_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * artwork_url;

@end

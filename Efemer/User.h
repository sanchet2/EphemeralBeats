//
//  User.h
//  Beatport
//
//  Created by Nikhil Sancheti on 7/6/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, SongsQueue;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * session;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *playlistSongs;
@property (nonatomic, retain) NSSet *folowees;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPlaylistSongsObject:(SongsQueue *)value;
- (void)removePlaylistSongsObject:(SongsQueue *)value;
- (void)addPlaylistSongs:(NSSet *)values;
- (void)removePlaylistSongs:(NSSet *)values;

- (void)addFoloweesObject:(NSManagedObject *)value;
- (void)removeFoloweesObject:(NSManagedObject *)value;
- (void)addFolowees:(NSSet *)values;
- (void)removeFolowees:(NSSet *)values;

@end

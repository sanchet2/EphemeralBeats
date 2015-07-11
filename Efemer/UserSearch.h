//
//  UserSearch.h
//  Beatport
//
//  Created by Nikhil Sancheti on 7/11/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "JSONModel.h"

@interface UserSearch : JSONModel
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *timestamp;
@end

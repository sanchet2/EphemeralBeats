//
//  FirstLoginUser.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/24/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "JSONModel.h"

@interface FirstLoginUser : JSONModel
@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSNumber* timestamp;
@property (strong,nonatomic) NSString* username;
@property (strong,nonatomic) NSString* session;
@end

//
//  Song.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/5/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "JSONModel.h"

@protocol Song
@end

@interface Song : JSONModel
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *stream_url;
@property (strong,nonatomic) NSURL<Optional>* artwork_url;
@end

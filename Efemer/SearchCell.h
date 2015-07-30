//
//  SearchCell.h
//  Beatport
//
//  Created by Nikhil Sancheti on 6/4/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (strong,nonatomic) UIImageView *bgImage;
@property (strong,nonatomic) UILabel *artist;
@property (strong,nonatomic) UILabel *song;
@property (strong,nonatomic) UIButton *incognito;
@property (strong,nonatomic) UIButton *share;
@property (strong,nonatomic) UIButton *play;

@end

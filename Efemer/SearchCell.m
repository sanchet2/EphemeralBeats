//
//  SearchCell.m
//  Beatport
//
//  Created by Nikhil Sancheti on 6/4/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=CGRectMake(0, 0, self.frame.size.width, 150);
        self.backgroundColor=[UIColor whiteColor];
        // Background image for search
        self.bgImage= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-30)];
         self.bgImage.autoresizingMask = UIViewContentModeScaleAspectFill;
        self.bgImage.backgroundColor = [UIColor blackColor];
        self.bgImage.opaque = NO;
        self.layer.cornerRadius=10;
        [self.bgImage setClipsToBounds:true];
        self.bgImage.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.bgImage];
        
        self.backgroundColor=[UIColor blackColor];
        // Artist Name Label
        self.artist = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height-30, self.frame.size.width-5, 30)];
        self.artist.textColor = [UIColor whiteColor];
        [self.artist setFont:[UIFont boldSystemFontOfSize:16]];
        [self.contentView addSubview:self.artist];
//
////        // Song Name Label
////        self.song = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 200, 30)];
////        self.song.textColor = [UIColor whiteColor];
//        
//        [self addSubview:self.artist];
////        [self addSubview:self.song];
        
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 1;
    frame.size.height -= 2 * 1;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

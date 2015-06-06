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
        self.backgroundColor=[UIColor blackColor];
         self.bgImage= [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width-20, self.frame.size.height-20)];
        self.bgImage.backgroundColor = [UIColor clearColor];
        self.bgImage.opaque = NO;
        self.bgImage.image = [UIImage imageNamed:@"placeholder"];
        [self.bgImage setClipsToBounds:true];
        self.backgroundView = self.bgImage;
        self.bgImage.contentMode=UIViewContentModeScaleAspectFill;
        self.bgImage.layer.cornerRadius=1;
        
        self.artist = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
        self.artist.textColor = [UIColor whiteColor];
        [self.artist setFont:[UIFont boldSystemFontOfSize:16]];
        self.song = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 200, 30)];
        self.song.textColor = [UIColor whiteColor];
        
        [self addSubview:self.artist];
        [self addSubview:self.song];
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

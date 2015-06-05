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
        
        UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width-20, self.frame.size.height-20)];
        av.backgroundColor = [UIColor clearColor];
        av.opaque = NO;
        av.image = [UIImage imageNamed:@"nirvana.jpg"];
        [av setClipsToBounds:true];
        self.backgroundView = av;
        av.contentMode=UIViewContentModeScaleAspectFill;
        av.layer.cornerRadius=5;
        av.layer.opacity=0.5;
        
        self.artist = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
        self.artist.textColor = [UIColor whiteColor];
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

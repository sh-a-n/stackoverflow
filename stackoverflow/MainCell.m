//
//  MainCell.m
//  stackoverflow
//
//  Created by Admin on 06.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell
@synthesize labeltext;
@synthesize autor;
@synthesize modDate;
@synthesize ansCount;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTime:(NSInteger)seconds
{
    if (seconds<60)
    {
        self.modDate.text = [NSString stringWithFormat:@"Modified %ld sec. ago",(long)seconds];
    }
    else
    {
        if (seconds<3600)
        {
            self.modDate.text = [NSString stringWithFormat:@"Modified %ld min. ago",(long)seconds/60];
        }
        else
            if (seconds<3600*24) {
                self.modDate.text = [NSString stringWithFormat:@"Midified %ld h. ago",(long)seconds/3600];
            }
            else if (seconds<3600*24*30)
            {
                self.modDate.text = [NSString stringWithFormat:@"Modified %ld d. ago",(long)seconds/3600/24];
            }
            else if (seconds<3600*24*365)
            {
                self.modDate.text = [NSString stringWithFormat:@"Modified %ld mes. ago",(long)seconds/3600/24/30];
            }
            else if (seconds>=3600*24*365)
            {
                self.modDate.text = [NSString stringWithFormat:@"Modified %ld y. ago",(long)seconds/3600/24/365];
            }
    }
}

@end

//
//  AnswerCell.m
//  stackoverflow
//
//  Created by Admin on 06.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell
@synthesize autor;
@synthesize ansCount;
@synthesize labeltext;
@synthesize modDate;
@synthesize image;

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

@end

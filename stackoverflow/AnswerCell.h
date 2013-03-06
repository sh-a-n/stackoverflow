//
//  AnswerCell.h
//  stackoverflow
//
//  Created by Admin on 06.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel * labeltext;
@property (nonatomic, retain) IBOutlet UILabel * autor;
@property (nonatomic, retain) IBOutlet UILabel * modDate;
@property (nonatomic, retain) IBOutlet UILabel * ansCount;
@property (nonatomic, retain) IBOutlet UIImageView * image;

@end

//
//  DetailViewController.m
//  stackoverflow
//
//  Created by Admin on 05.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "DetailViewController.h"
#import "CJSONDeserializer.h"
#import "APIDownload.h"
#import "AnswerCell.h"
#import "MainCell.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailTableView;
@synthesize questionCell;
@synthesize answers;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return answers.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row == 0)
    {
        MainCell * cell = (MainCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell"owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        cell.autor.text = questionCell.autor.text;
        cell.ansCount.text = questionCell.ansCount.text;
        cell.modDate.text = questionCell.modDate.text;
        cell.labeltext.text = questionCell.labeltext.text;
        //NSString * t = questionCell.labeltext.text;
        
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:1.0f blue:1.0f alpha:1.0f];
        
        
        NSString *cellText;
        
            cellText = cell.labeltext.text;
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0f];
        
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:CGSizeMake(283.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        cell.labeltext.frame = CGRectMake(20.0f, 36.0f, 283.0f, labelSize.height);
        
        cell.labeltext.numberOfLines = 0;
        cell.labeltext.lineBreakMode = NSLineBreakByWordWrapping;
        
        return cell;
    }
    else
    {
        AnswerCell * cell = (AnswerCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnswerCell"owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.labeltext.lineBreakMode = NSLineBreakByWordWrapping;
        cell.labeltext.numberOfLines = 0;
        cell.autor.text = [[answers[indexPath.row-1] objectForKey:@"owner"]objectForKey:@"display_name"];
        
        NSInteger lastmod_date = [[answers[indexPath.row-1] objectForKey:@"last_edit_date"] integerValue];
        if (lastmod_date == 0)
        {
            lastmod_date = [[answers[indexPath.row-1] objectForKey:@"creation_date"] integerValue];
        }
        NSInteger seconds = [[NSDate date] timeIntervalSince1970] - lastmod_date;
        
        [cell setTime:seconds];
        cell.ansCount.text = [NSString stringWithFormat:@"%@",[answers[indexPath.row-1] objectForKey:@"score"]];
        cell.labeltext.text = [self deleteTegs:[answers[indexPath.row-1] objectForKey:@"body"]];
        if ([[answers[indexPath.row-1] objectForKey:@"is_accepted"] integerValue] ==1)
        {
            cell.image.image = [UIImage imageNamed:@"galochka128x128.png"];
        }
        NSString *cellText;
        
            cellText = [self deleteTegs:[(NSDictionary*)answers[indexPath.row-1] objectForKey:@"body"]];
        
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0f];
        
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:CGSizeMake(260.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        cell.labeltext.frame = CGRectMake(cell.labeltext.frame.origin.x, cell.labeltext.frame.origin.y, cell.labeltext.frame.size.width, labelSize.height);
        return cell;
    }
    
    
    
   
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row > 0)
    {
        NSString *cellText = [self deleteTegs:[(NSDictionary*)answers[indexPath.row-1] objectForKey:@"body"]];
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0f];
        
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:CGSizeMake(260.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        return labelSize.height + 80.0f;
    }
    else
    {
        NSString *cellText = questionCell.labeltext.text;
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0f];
        
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:CGSizeMake(283.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        return labelSize.height + 80.0f;
    }
    
}

- (NSString *)deleteTegs:(NSString *) oldstring
{
    for (int i=0; i<oldstring.length; i++) {
        if ([oldstring characterAtIndex:i]=='<')
        {
            int j=i;
            while ([oldstring characterAtIndex:j]!='>') {
                j++;
            }
            
        oldstring = [[oldstring substringToIndex:i] stringByAppendingString:[oldstring substringFromIndex:j+1]];
            i--;
        }
    }
    return oldstring;
}

- (void)tselect
{
    NSArray *contrs = self.navigationController.viewControllers;
    [[contrs objectAtIndex:0]performSelector:@selector(tselector)];
    [self.navigationController popViewControllerAnimated:YES];
    [[contrs objectAtIndex:0]performSelector:@selector(tselector) withObject:nil afterDelay:0.1f];
    
}



@end

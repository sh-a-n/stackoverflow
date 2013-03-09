//
//  ViewController.m
//  stackoverflow
//
//  Created by Admin on 05.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "MainCell.h"
#import "CJSONDeserializer.h"
#import "APIDownload.h"

@interface ViewController ()

@end

@implementation ViewController
//@synthesize detailViewController;
@synthesize dataSource;
@synthesize mainTableView;
@synthesize questData;
@synthesize questDataArray;
@synthesize errorLabel;
@synthesize tryButton;
@synthesize timer;
@synthesize tagButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tagPicker.hidden = true;
    
    tagButton = [[UIBarButtonItem alloc]initWithTitle:@"Tag" style:UIBarButtonItemStyleBordered target:self action:@selector(tagSelector:)];
    self.navigationItem.leftBarButtonItem = tagButton;
    
    self.dataSource = [NSArray arrayWithObjects:@"Objective-c",@"ios",@"xcode",@"cocoa-touch",@"iphone", nil];
    self.navigationItem.title = dataSource[0];
    
    [APIDownload downloadWithURL:[NSString stringWithFormat:@"http://api.stackexchange.com/2.1/questions?order=desc&page=1&pagesize=50&sort=creation&site=stackoverflow&filter=!-.mgWKou0vDR&tagged=%@&todate=%ld",@"Objective-c",(long)[[NSDate date] timeIntervalSince1970]] delegate:self];
    
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
    tableView.rowHeight = 100;
    if (questDataArray)
    {
        return [(NSDictionary*)[questDataArray objectForKey:@"items"] count];
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    MainCell *cell = (MainCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.ansCount.text = [NSString stringWithFormat:@"%@",[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"answer_count"]];
    cell.autor.text = [(NSDictionary*)[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"owner"] objectForKey:@"display_name"];
    NSInteger lastmod_date = [[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"last_edit_date"] integerValue];
    if (lastmod_date == 0)
    {
        lastmod_date = [[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"creation_date"] integerValue];
    }
    NSInteger seconds = [[NSDate date] timeIntervalSince1970] - lastmod_date;
    
    [cell setTime:seconds];
    
    cell.labeltext.text = [(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"title"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0f];
    
    CGSize labelSize = [cell.labeltext.text sizeWithFont:cellFont constrainedToSize:CGSizeMake(283.0f, 42.0f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    cell.labeltext.frame = CGRectMake(20.0f, 36.0f, 283.0f, labelSize.height);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
   
    detailViewController.questionCell = (MainCell*)[tableView cellForRowAtIndexPath:indexPath];
    detailViewController.answers = [(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"answers"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}





- (IBAction)tagSelector:(id)sender {
    if (self.navigationItem.leftBarButtonItem.style == UIBarButtonItemStyleBordered)
    {
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
        
        self.tagPicker.hidden = NO;
        self.pickerBackView.hidden = NO;
        
    }
    else
    {
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
        self.tagPicker.hidden = YES;
        if (self.navigationItem.title != [dataSource objectAtIndex:[self.tagPicker selectedRowInComponent:0]])
        {
            self.navigationItem.title = [dataSource objectAtIndex:[self.tagPicker selectedRowInComponent:0]];
            [APIDownload downloadWithURL:[NSString stringWithFormat:@"http://api.stackexchange.com/2.1/questions?order=desc&page=1&pagesize=50&sort=creation&site=stackoverflow&filter=!-.mgWKou0vDR&tagged=%@&todate=%ld",[dataSource objectAtIndex:[self.tagPicker selectedRowInComponent:0]],(long)[[NSDate date] timeIntervalSince1970]] delegate:self];
            self.activityIndicator.hidden = NO;
            self.errorLabel.hidden = YES;
            self.tryButton.hidden = YES;
            
        }
        else
        {
            if ([(NSDictionary*)[questDataArray objectForKey:@"items"] count]>0)
                self.pickerBackView.hidden = YES;
        }
    }
        
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataSource.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return dataSource[row];
}



- (void)APIDownload:(APIDownload*)request {
    CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
    
    NSDictionary *info = [deserializer deserializeAsDictionary:request.downloadData error:nil];
    questDataArray = info;
    if (info) {
               
        //NSLog(@"%@", questDataArray);
        [mainTableView reloadData];
        self.pickerBackView.hidden = TRUE;
        self.activityIndicator.hidden = true;
        
    } else {
        NSLog(@"Error: %@",[info objectForKey:@"error"]);
    }
    
}





- (void)viewDidUnload {
    [self setErrorLabel:nil];
    [self setTryButton:nil];
    [super viewDidUnload];
}

- (IBAction)tryButtonTouch:(id)sender {
    self.tryButton.hidden = YES;
    self.errorLabel.hidden = YES;
    [APIDownload downloadWithURL:[NSString stringWithFormat:@"http://api.stackexchange.com/2.1/questions?order=desc&page=1&pagesize=50&sort=creation&site=stackoverflow&filter=!-.mgWKou0vDR&tagged=%@&todate=%ld",self.navigationItem.title,(long)[[NSDate date] timeIntervalSince1970]] delegate:self];
    self.activityIndicator.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [mainTableView reloadData];
    [super viewWillAppear:animated];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activityIndicator.hidden = YES;
    self.errorLabel.hidden = NO;
    self.tryButton.hidden = NO;
    
}


@end

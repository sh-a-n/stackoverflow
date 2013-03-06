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
@synthesize detailViewController;
@synthesize dataSource;
@synthesize mainTableView;
@synthesize questData;
@synthesize questDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tagPicker.hidden = true;
    
    UIBarButtonItem *tagButton = [[UIBarButtonItem alloc]initWithTitle:@"Tag" style:UIBarButtonItemStyleBordered target:self action:@selector(tagSelector:)];
    self.navigationItem.leftBarButtonItem = tagButton;
    
    self.dataSource = [NSArray arrayWithObjects:@"Objective-c",@"ios",@"xcode",@"cocoa-touch",@"iphone", nil];
    self.navigationItem.title = dataSource[0];
    
    [APIDownload downloadWithURL:[NSString stringWithFormat:@"http://api.stackexchange.com/2.1/questions?order=desc&max=50&sort=votes&site=stackoverflow&filter=!-.mgWKou0vDR&tagged=%@",@"Objective-c"] delegate:self];
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
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.ansCount.text = [NSString stringWithFormat:@"%@",[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"answer_count"]];
    cell.autor.text = [(NSDictionary*)[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"owner"] objectForKey:@"display_name"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[(NSString*)[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"last_edit_date"] integerValue]];
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    [format setDateStyle:NSDateFormatterShortStyle];
    //NSLog(@"%@",[format stringFromDate:date]);
    cell.modDate.text = [format stringFromDate:date];
    
    cell.labeltext.text = [(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"title"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailViewController = [[DetailViewController alloc]
                                  initWithNibName:@"DetailViewController" bundle:nil];
    static NSString *CellIdentifier = @"Cell";
    
    MainCell *cell = (MainCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.autor.text = [[(MainCell*)[tableView cellForRowAtIndexPath:indexPath] autor] text];
    cell.ansCount.text = [NSString stringWithFormat:@"%@",[(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"score"]];
    cell.modDate.text = [[(MainCell*)[tableView cellForRowAtIndexPath:indexPath] modDate] text];
    cell.labeltext.text = [[(MainCell*)[tableView cellForRowAtIndexPath:indexPath] labeltext] text];
    detailViewController.questionCell = cell;
    detailViewController.answers = [(NSDictionary*)[questDataArray objectForKey:@"items"][indexPath.row] objectForKey:@"answers"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    

}




- (IBAction)tagSelector:(id)sender {
    
    if (self.navigationItem.leftBarButtonItem.style == UIBarButtonItemStyleBordered)
    {
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
        [self.mainTableView setFrame:CGRectMake(mainTableView.frame.origin.x, mainTableView.frame.origin.y, mainTableView.frame.size.width, mainTableView.frame.size.height - self.tagPicker.frame.size.height)];
        self.tagPicker.hidden = false;
        self.pickerBackView.hidden = false;
    }
    else
    {
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
        [self.mainTableView setFrame:CGRectMake(mainTableView.frame.origin.x, mainTableView.frame.origin.y, mainTableView.frame.size.width, mainTableView.frame.size.height + self.tagPicker.frame.size.height)];
        self.tagPicker.hidden = true;
        if (self.navigationItem.title != [dataSource objectAtIndex:[self.tagPicker selectedRowInComponent:0]])
        {
            self.navigationItem.title = [dataSource objectAtIndex:[self.tagPicker selectedRowInComponent:0]];
            [APIDownload downloadWithURL:[NSString stringWithFormat:@"http://api.stackexchange.com/2.1/questions?order=desc&max=50&sort=votes&site=stackoverflow&filter=!-.mgWKou0vDR&tagged=%@",[dataSource objectAtIndex:[self.tagPicker selectedRowInComponent:0]]] delegate:self];
            self.activityIndicator.hidden = false;
        }
        else
        {
            self.pickerBackView.hidden = true;
        }
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return dataSource.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
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




@end

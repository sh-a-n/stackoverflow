//
//  ViewController.h
//  stackoverflow
//
//  Created by Admin on 05.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DetailViewController;

@interface ViewController : UIViewController
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@property (strong, nonatomic) DetailViewController * detailViewController;
@property (nonatomic, retain) NSMutableData *questData;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic,strong) UIBarButtonItem *tagButton;

- (IBAction)tryButtonTouch:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *tryButton;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)tagSelector:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *tagPicker;
@property (strong, nonatomic) NSArray *dataSource;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSDictionary *questDataArray;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * activityIndicator;

@end

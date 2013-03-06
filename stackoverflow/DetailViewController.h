//
//  DetailViewController.h
//  stackoverflow
//
//  Created by Admin on 05.03.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCell.h"



@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) MainCell * questionCell;
@property (strong, nonatomic) NSArray * answers;



@end

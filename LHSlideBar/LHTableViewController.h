//
//  LHTableViewController.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHSlideBarController;

@interface LHTableViewController : UITableViewController

@property (weak, nonatomic) NSArray *slideBarViewControllers;
@property (weak, nonatomic) LHSlideBarController *slideBarController;

- (id)initWithStyle:(UITableViewStyle)style withController:(LHSlideBarController *)controller;

@end

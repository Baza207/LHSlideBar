//
//  LHSlideBar.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHSlideBarController;

@interface LHSlideBar : UITableViewController

@property (weak, readonly, nonatomic) NSArray *slideBarViewControllers;
@property (weak, nonatomic) LHSlideBarController *slideBarController;
@property (assign, nonatomic) UITableViewCellSelectionStyle currentVCSelectedStyle;

- (id)initWithStyle:(UITableViewStyle)style withController:(LHSlideBarController *)controller;
- (void)setSlideBarViewControllers:(NSArray *)slideBarViewControllers;

@end

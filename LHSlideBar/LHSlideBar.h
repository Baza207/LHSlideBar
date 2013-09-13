//
//  LHSlideBar.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHSlideBarController;

@interface LHSlideBar : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) UITableViewCellSelectionStyle currentVCSelectedStyle;
@property (strong, nonatomic) UINavigationBar *navigationBar;
@property (assign, readonly, nonatomic) BOOL navigationBarHidden;
@property (weak, readonly, nonatomic) NSArray *slideBarViewControllers;
@property (weak, nonatomic) LHSlideBarController *slideBarController;

- (id)initWithController:(LHSlideBarController *)controller;
- (void)setSlideBarViewControllers:(NSArray *)slideBarViewControllers;
- (void)setNavBarTitle:(NSString *)title;

- (void)setNavigationBarHidden:(BOOL)hidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

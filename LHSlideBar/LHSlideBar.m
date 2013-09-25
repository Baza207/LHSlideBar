//
//  LHSlideBar.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import "LHSlideBar.h"
#import "LHSlideBarController.h"

@implementation LHSlideBar

- (id)initWithController:(LHSlideBarController *)controller
{
    self = [super init];
    if (self)
    {
        _slideBarController = controller;
        _currentVCSelectedStyle = UITableViewCellSelectionStyleBlue;
        
        _navigationBar = [[UINavigationBar alloc] init];
        _tableView = [[UITableView alloc] init];
        
#ifdef __IPHONE_7_0
        if ([LHSlideBarController deviceSystemMajorVersion] < 7)
        {
            [_navigationBar setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, 44)];
            [_tableView setFrame:CGRectMake(0, [_navigationBar bounds].size.height,
                                            [[self view] bounds].size.width,
                                            [[self view] bounds].size.height - [_navigationBar bounds].size.height)];
        }
        else
        {
            [_navigationBar setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, 44)];
            [_tableView setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, [[self view] bounds].size.height)];
            [_tableView setContentInset:UIEdgeInsetsMake([_navigationBar bounds].size.height, 0.0, 0.0, 0.0)];
        }
#else
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [[self view] bounds].size.width, 44)];
        [_navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [[self view] bounds].size.width, [[self view] bounds].size.height - [_navigationBar bounds].size.height)];
#endif
        
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [[self view] addSubview:_tableView];
        
        [_navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [_navigationBar setItems:@[navigationItem]];
        [[self view] addSubview:_navigationBar];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Getter and Setter Methods

- (void)setSlideBarViewControllers:(NSArray *)slideBarViewControllers
{
    _slideBarViewControllers = slideBarViewControllers;
    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setNavBarTitle:(NSString *)title
{
    [[_navigationBar topItem] setTitle:title];
}

- (void)setNavBarView:(UIView *)view
{
    [[_navigationBar topItem] setTitleView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_slideBarViewControllers == nil || [_slideBarViewControllers count] <= 0)
        return 0;
    
    return [_slideBarViewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_slideBarViewControllers == nil || [_slideBarViewControllers count] <= 0)
        return nil;
    
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [[cell imageView] setImage:nil];
    [[cell textLabel] setText:nil];
    [[cell detailTextLabel] setText:nil];
    
    switch ([indexPath section])
    {
        case 0:
        {
            __weak UIViewController *viewController = [_slideBarViewControllers objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[viewController title]];
            [[cell imageView] setImage:[[viewController tabBarItem] image]];
            [cell setSelectionStyle:_currentVCSelectedStyle];
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_slideBarViewControllers == nil || [_slideBarViewControllers count] <= 0)
        return;
    
    switch ([indexPath section])
    {
        case 0:
        {
            [_slideBarController dismissSlideBar:self swapToIndex:[indexPath row] animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Navigation Bar Methods

- (void)setNavigationBarHidden:(BOOL)hidden
{
    [self setNavigationBarHidden:hidden animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if ((_navigationBarHidden && hidden) || (!_navigationBarHidden && !hidden))
        return;
    
    CGRect navBarRect, tableViewRect = CGRectNull;
    if (hidden)
    {
        int8_t statusBarOffset = 0;
        if (![[UIApplication sharedApplication] isStatusBarHidden])
            statusBarOffset = -20;
        
        navBarRect = CGRectMake(0.0, statusBarOffset-[_navigationBar bounds].size.height, [_navigationBar bounds].size.width, [_navigationBar bounds].size.height);
        tableViewRect = CGRectMake(0.0, 0.0, [[self view] bounds].size.width, [[self view] bounds].size.height);
    }
    else
    {
        navBarRect = CGRectMake(0.0, 0.0, [_navigationBar bounds].size.width, [_navigationBar bounds].size.height);
        tableViewRect = CGRectMake(0.0, 0.0, [[self view] bounds].size.width, [[self view] bounds].size.height - [_navigationBar bounds].size.height);
    }
    
    if (CGRectIsNull(navBarRect) || CGRectIsNull(tableViewRect))
        return;
    
    if (animated)
    {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [_navigationBar setFrame:navBarRect];
                             [_tableView setFrame:tableViewRect];
                         }
                         completion:^(BOOL finished) {
                             _navigationBarHidden = hidden;
                         }];
    }
    else
    {
        [_navigationBar setFrame:navBarRect];
        [_tableView setFrame:tableViewRect];
        
        _navigationBarHidden = hidden;
    }
}

#pragma mark - Is Showing Methods

- (BOOL)isSlideBarShowing
{
    if (self == [_slideBarController leftSlideBarVC])
        return [_slideBarController isLeftSlideBarShowing];
    else if (self == [_slideBarController rightSlideBarVC])
        return [_slideBarController isRightSlideBarShowing];
    else
        return NO;
}

@end

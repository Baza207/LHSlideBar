//
//  ViewControllerTwo.m
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import "ViewControllerTwo.h"
#import "LHSlideBarController.h"

@implementation ViewControllerTwo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setTitle:@"View Controller 2"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize viewSize = [LHSlideBarController viewSizeForViewController:self];
    [[self view] setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showLeftSlideBar:(id)sender
{
    [[self slideBarController] showLeftSlideBarAnimated:YES];
}

- (IBAction)showRightSlideBar:(id)sender
{
    [[self slideBarController] showRightSlideBarAnimated:YES];
}

@end

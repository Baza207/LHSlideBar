//
//  TestViewController.m
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import "TestViewController.h"
#import "LHSlideBarController.h"

@implementation TestViewController

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

- (void)setTestNumber:(NSUInteger)number andColour:(UIColor *)colour
{
    [[self view] setBackgroundColor:colour];
    [_numLabel setText:[NSString stringWithFormat:@"%d", number]];
    [self setTitle:[NSString stringWithFormat:@"View Controller %d", number]];
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

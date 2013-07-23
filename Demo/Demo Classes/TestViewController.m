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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_transformSegControl setSelectedSegmentIndex:[[self slideBarController] transformType]-1];
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

- (IBAction)transformSegControlChanged:(UISegmentedControl *)sender
{
    [[self slideBarController] setTransformType:[sender selectedSegmentIndex]+1];
}

@end

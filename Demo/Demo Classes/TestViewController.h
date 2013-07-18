//
//  TestViewController.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transformSegControl;

- (void)setTestNumber:(NSUInteger)number andColour:(UIColor *)colour;

@end

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

- (void)setTestNumber:(NSUInteger)number andColour:(UIColor *)colour;

@end

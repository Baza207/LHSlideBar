//
//  LHAppDelegate.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHSlideBarController;

@interface LHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LHSlideBarController *slideBarController;

@end

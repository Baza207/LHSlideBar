//
//  LHAppDelegate.m
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import "LHAppDelegate.h"
#import "LHSlideBarController.h"
#import "TestViewController.h"

@implementation LHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TestViewController *vcOne = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    TestViewController *vcTwo = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    TestViewController *vcThree = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    TestViewController *vcFour = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    TestViewController *vcFive = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    TestViewController *vcSix = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    
    [vcOne setTestNumber:1 andColour:[UIColor orangeColor]];
    [vcTwo setTestNumber:2 andColour:[UIColor yellowColor]];
    [vcThree setTestNumber:3 andColour:[UIColor greenColor]];
    [vcFour setTestNumber:4 andColour:[UIColor blueColor]];
    [vcFive setTestNumber:5 andColour:[UIColor purpleColor]];
    [vcSix setTestNumber:6 andColour:[UIColor redColor]];
    
    NSArray *viewControllersL = @[vcOne, vcTwo, vcThree];
    NSArray *viewControllersR = @[vcFour, vcFive, vcSix];
    _slideBarController = [[LHSlideBarController alloc] initWithLeftViewControllers:viewControllersL andRightViewControllers:viewControllersR];
    [_slideBarController setHideStatusBarOnShow:NO];
    [_slideBarController setupSlideBarAtPosition:LHSlideBarSideLeft pushFirstVC:YES];
    [_slideBarController setupSlideBarAtPosition:LHSlideBarSideRight pushFirstVC:NO];
    
    [[_slideBarController leftSlideBarVC] setNavBarTitle:@"Left SlideBar"];
    [[_slideBarController rightSlideBarVC] setNavBarTitle:@"Right SlideBar"];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"LSB" style:UIBarButtonItemStylePlain target:_slideBarController action:@selector(showLeftSlideBarAnimated:)];
    [_slideBarController setLeftBarButtonItem:leftBarButton];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"RSB" style:UIBarButtonItemStylePlain target:_slideBarController action:@selector(showRightSlideBarAnimated:)];
    [_slideBarController setRightBarButtonItem:rightBarButton];
    
    [_window setRootViewController:_slideBarController];
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

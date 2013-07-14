//
//  LHSlideBarController.m
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LHSlideBarController.h"
#import "LHTableViewController.h"

#define SLIDE_BAR_OFFSET    40
#define SLIDE_BAR_SCALE     0.9
#define SLIDE_BAR_ALPHA     0.8
#define SLIDE_BAR_ANIM_TIME 0.25
#define SHADOW_WIDTH        40

@implementation LHSlideBarController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self)
    {
        _leftViewControllers = viewControllers;
    }
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize viewSize = [LHSlideBarController viewSizeForViewController:self];
    
    leftSlideBarHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosOffLeft animated:NO];
    [leftSlideBarHolder setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:leftSlideBarHolder];
    
    _slideBarTableVC = [[LHTableViewController alloc] initWithStyle:UITableViewStylePlain withController:self];
    [[_slideBarTableVC view] setFrame:CGRectMake(0, 0, viewSize.width-SLIDE_BAR_OFFSET, viewSize.height)];
    [_slideBarTableVC setSlideBarViewControllers:_leftViewControllers];
    [leftSlideBarHolder addSubview:[_slideBarTableVC view]];
    
    leftSlideBarShadow = [[UIView alloc] initWithFrame:CGRectMake([[_slideBarTableVC view] bounds].size.width, 0, SHADOW_WIDTH, viewSize.height)];
    [leftSlideBarShadow setBackgroundColor:[UIColor clearColor]];
    [leftSlideBarShadow addLinearGradientInDirection:directionRight];
    [leftSlideBarHolder addSubview:leftSlideBarShadow];
    
    if (_leftViewControllers && [_leftViewControllers count] > 0)
        [self pushViewControllerAtIndex:0 inSlideBarHolder:leftSlideBarHolder animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Pressed Methods

- (void)showLeftSlideBar:(id)sender
{
    [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosCenterLeft animated:YES];
}

#pragma mark - Custom Setter and Getter Methods

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_slideBarTableVC)
        [_slideBarTableVC setSlideBarViewControllers:_leftViewControllers];
}

#pragma mark - Push, Pop and Swap Methods

- (void)pushViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    __weak UIViewController *newViewController = [_leftViewControllers objectAtIndex:index];
    [self swapViewController:_currentViewController forNewViewController:newViewController inSlideBarHolder:slideBarHolder animated:animated];
    [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosOffLeft animated:YES];
    _currentViewController = newViewController;
    _currentIndex = index;
    
}

- (void)swapViewController:(UIViewController *)viewController forNewViewController:(UIViewController *)newViewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    if (viewController == newViewController)
        return;
    
    [self willMoveToParentViewController:newViewController];
    [self scaleViewController:newViewController byPercent:SLIDE_BAR_SCALE animated:NO];
    
    if (viewController)
    {
        [[self view] insertSubview:[newViewController view] belowSubview:[viewController view]];
        [[viewController view] removeFromSuperview];
        [viewController removeFromParentViewController];
    }
    else
        [[self view] insertSubview:[newViewController view] belowSubview:leftSlideBarHolder];
    
    [self addChildViewController:newViewController];
    [self didMoveToParentViewController:newViewController];
    
    [self scaleViewController:newViewController byPercent:1.0 animated:animated];
}

- (void)setSlideBarHolder:(UIView *)slideBarHolder toPosition:(LHSlideBarPos)position animated:(BOOL)animated
{
    CGRect rect = CGRectNull;
    CGRect curRect = [slideBarHolder frame];
    CGSize size = curRect.size;
    
    CGFloat scalePercent = 1.0;
    CGFloat blackoutAlpha = 0.0;
    
    switch (position)
    {
        case LHSlideBarPosCenter:
        {
            rect = CGRectMake(0, 0, size.width, size.height);
            scalePercent = SLIDE_BAR_SCALE;
            blackoutAlpha = SLIDE_BAR_ALPHA;
            break;
        }
        
        case LHSlideBarPosCenterLeft:
        {
            rect = CGRectMake(0, 0, size.width, size.height);
            scalePercent = SLIDE_BAR_SCALE;
            blackoutAlpha = SLIDE_BAR_ALPHA;
            break;
        }
            
        case LHSlideBarPosCenterRight:
        {
            rect = CGRectMake(SLIDE_BAR_OFFSET, 0, size.width, size.height);
            scalePercent = SLIDE_BAR_SCALE;
            blackoutAlpha = SLIDE_BAR_ALPHA;
            break;
        }
            
        case LHSlideBarPosOffLeft:
        {
            rect = CGRectMake(-size.width, 0, size.width, size.height);
            scalePercent = 1.0;
            blackoutAlpha = 0.0;
            break;
        }
            
        case LHSlideBarPosOffRight:
        {
            rect = CGRectMake(size.width, 0, size.width, size.height);
            scalePercent = 1.0;
            blackoutAlpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:SLIDE_BAR_ANIM_TIME
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [slideBarHolder setFrame:rect];
                             [self scaleView:[_currentViewController view] byPercent:scalePercent];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        [slideBarHolder setFrame:rect];
        [self scaleView:[_currentViewController view] byPercent:scalePercent];
    }
}

#pragma mark - Animation and Transformation Methods

- (void)scaleView:(UIView *)view byPercent:(double)percent
{
    if (view == nil)
        return;
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D = CATransform3DScale(transform3D, percent, percent, 1);
    
    [[view layer] setTransform:transform3D];
}

- (void)scaleViewController:(UIViewController *)viewController byPercent:(double)percent animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:SLIDE_BAR_ANIM_TIME
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self scaleView:[viewController view] byPercent:percent];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        [self scaleView:[viewController view] byPercent:percent];
    }
}

#pragma mark - Size Methods

+ (CGSize)viewSizeForViewController:(UIViewController *)viewController
{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    if (![[UIApplication sharedApplication] isStatusBarHidden])
        viewSize.height -= 20;
    
    if ([viewController navigationController])
    {
        if ([[viewController navigationController] isNavigationBarHidden])
            viewSize.height -= 44;
    }
    
    if ([viewController tabBarController])
        viewSize.height -= 49;
    
    return viewSize;
}

#pragma mark - Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[self view]];
    if (CGRectContainsPoint([leftSlideBarShadow frame], touchPoint))
        [self pushViewControllerAtIndex:_currentIndex inSlideBarHolder:leftSlideBarHolder animated:YES];
}

@end


#pragma mark - UIViewController Category

@implementation UIViewController (LHSlideBarController)
@dynamic slideBarController;

- (LHSlideBarController *)slideBarController
{
    if([self.parentViewController isKindOfClass:[LHSlideBarController class]])
    {
        return (LHSlideBarController *)self.parentViewController;
    }
    else if([[self parentViewController ] isKindOfClass:[UINavigationController class]] &&
            [[[self parentViewController ] parentViewController] isKindOfClass:[LHSlideBarController class]])
    {
        return (LHSlideBarController *)[self.parentViewController parentViewController];
    }
    else
    {
        return nil;
    }
}

@end

#pragma mark - UIView Category

@implementation UIView (LinearGradient)

- (void)addLinearGradientInDirection:(Direction)direction
{
    UIColor * firstColour = nil;
    UIColor * secondColour = nil;
    
    switch (direction)
    {
        case directionLeft:
        {
            firstColour = [UIColor colorWithWhite:0.0 alpha:0.0];
            secondColour = [UIColor colorWithWhite:0.0 alpha:SLIDE_BAR_ALPHA];
            break;
        }
            
        case directionRight:
        {
            firstColour = [UIColor colorWithWhite:0.0 alpha:SLIDE_BAR_ALPHA];
            secondColour = [UIColor colorWithWhite:0.0 alpha:0.0];
            break;
        }
            
        default:
            break;
    }
    
    CAGradientLayer * gradient = [CAGradientLayer layer];
    [gradient setFrame:[self bounds]];
    [gradient setColors:@[(id)[firstColour CGColor], (id)[secondColour CGColor]]];
    [gradient setLocations:@[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1]]];
    [gradient setStartPoint:CGPointMake(0.0, 0.5)];
    [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    [[self layer] addSublayer:gradient];
}

@end

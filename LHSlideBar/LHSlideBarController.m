//
//  LHSlideBarController.m
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LHSlideBarController.h"

#define DEGREES_TO_RADIANS(angle)   ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#define SLIDE_BAR_OFFSET        40
#define SLIDE_BAR_SCALE         0.9
#define SLIDE_BAR_ALPHA         0.75
#define SLIDE_BAR_ANIM_TIME     0.25
#define SLIDE_BAR_MIN_ANIM_TIME 0.1
#define IPHONE_CORNER_RADIUS    2.0

@implementation LHSlideBarController

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        [[self view] setFrame:frame];
    }
    return [self init];
}

- (id)initWithLeftViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self)
    {
        _leftViewControllers = viewControllers;
    }
    return [self init];
}

- (id)initWithRightViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self)
    {
        _rightViewControllers = viewControllers;
    }
    return [self init];
}

- (id)initWithLeftViewControllers:(NSArray *)leftViewControllers andRightViewControllers:(NSArray *)rightViewControllers
{
    self = [super init];
    if (self)
    {
        _leftViewControllers = leftViewControllers;
        _rightViewControllers = rightViewControllers;
    }
    return [self init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        mainContainerView = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [mainContainerView setBackgroundColor:[UIColor clearColor]];
        [mainContainerView setClipsToBounds:YES];
        [[self view] addSubview:mainContainerView];
        
        _backgroundView = [[UIView alloc] initWithFrame:[mainContainerView bounds]];
        [_backgroundView setBackgroundColor:[UIColor clearColor]];
        [_backgroundView setClipsToBounds:YES];
        [mainContainerView addSubview:_backgroundView];
        
        navController = [[UINavigationController alloc] init];
        [[navController view] setFrame:[mainContainerView bounds]];
        [[navController view] setClipsToBounds:YES];
        [mainContainerView addSubview:[navController view]];
        [self addChildViewController:navController];
        
        [self setSlideBarOffset:SLIDE_BAR_OFFSET];
        [self setScaleAmount:SLIDE_BAR_SCALE];
        [self setFadeOutAlpha:SLIDE_BAR_ALPHA];
        [self setAnimTime:SLIDE_BAR_ANIM_TIME];
        
        [self setTransformType:LHTransformRotate];
        [self setAnimatesOnSlide:YES];
        [self setAnimateSwappingNavController:NO];
        [self setKeepRoundedCornersWhenAnim:YES];
        [self setRoundCornersOnLeftSlideBar:YES];
        [self setRoundCornersOnRightSlideBar:YES];
        
        _leftSlideBarShowing = NO;
        _rightSlideBarShowing = NO;
        _leftSlideBarDragging = NO;
        _rightSlideBarDragging = NO;
        
//        [self setCustomSlideTransformValue:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureChanged:)];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [[self view] addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UINavigationController *)navigationController
{
    return navController;
}

- (UINavigationItem *)navigationItem
{
    return [navController navigationItem];
}

#pragma mark - Status Bar Methods

- (BOOL)prefersStatusBarHidden
{
    NSLog(@"Is Dragging: %@ Is Showing: %@", [self isSlideBarDragging]? @"Yes":@"No", [self isSlideBarShowing]? @"Yes":@"No");
    
    if ([self isSlideBarDragging])
        return YES;
    
    if ([self isSlideBarShowing] == NO && [self isSlideBarDragging] == NO)
        return NO;
    else
        return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

#pragma mark - Setup SlideBar Methods

- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push
{
    LHSlideBar *slideBar = [[LHSlideBar alloc] initWithController:self];
    [self setupSlideBarAtPosition:pos pushFirstVC:push withSlideBar:slideBar];
}

- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push withSlideBar:(LHSlideBar *)slideBar
{
    CGSize viewSize = [[self view] bounds].size;
    
    UIView *slideBarHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [slideBarHolder setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self setSlideBarHolder:slideBarHolder toPosition:LHSlideBarPosOffLeft animated:NO animTime:0];
    [slideBarHolder setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:slideBarHolder];
    
    [[slideBar view] setClipsToBounds:YES];
    [slideBarHolder addSubview:[slideBar view]];
    
    UIView *slideBarShadow = [[UIView alloc] init];
    [slideBarShadow setBackgroundColor:[UIColor clearColor]];
    [slideBarShadow setAlpha:_fadeOutAlpha];
    [slideBarHolder addSubview:slideBarShadow];
    
    switch (pos)
    {
        case LHSlideBarSideLeft:
        {
            [[slideBar view] setFrame:CGRectMake(0, 0, viewSize.width - _slideBarOffset, viewSize.height)];
            [slideBar setSlideBarViewControllers:_leftViewControllers];
            
            [slideBarShadow setFrame:CGRectMake([[slideBar view] bounds].size.width, 0, _slideBarOffset, viewSize.height)];
            [slideBarShadow setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [slideBarShadow addLinearGradientInDirection:DirectionRight];
            
            leftSlideBarHolder = slideBarHolder;
            leftSlideBarShadow = slideBarShadow;
            _leftSlideBarVC = slideBar;
            
            [self setRoundCornersOnLeftSlideBar:_roundCornersOnLeftSlideBar];
            [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosOffLeft animated:NO animTime:_animTime];
            
            if (push)
            {
                if (_leftViewControllers && [_leftViewControllers count] > 0)
                {
                    [[slideBar tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self swapViewControllerAtIndex:0 inSlideBarHolder:leftSlideBarHolder animated:NO];
                }
            }
            break;
        }
            
        case LHSlideBarSideRight:
        {
            [[slideBar view] setFrame:CGRectMake(_slideBarOffset, 0, viewSize.width - _slideBarOffset, viewSize.height)];
            [slideBar setSlideBarViewControllers:_rightViewControllers];
            
            [slideBarShadow setFrame:CGRectMake(0, 0, _slideBarOffset, viewSize.height)];
            [slideBarShadow setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
            [slideBarShadow addLinearGradientInDirection:DirectionLeft];
            
            rightSlideBarHolder = slideBarHolder;
            rightSlideBarShadow = slideBarShadow;
            _rightSlideBarVC = slideBar;
            
            [self setRoundCornersOnRightSlideBar:_roundCornersOnRightSlideBar];
            [self setSlideBarHolder:rightSlideBarHolder toPosition:LHSlideBarPosOffRight animated:NO animTime:_animTime];
            
            if (push)
            {
                if (_rightViewControllers && [_rightViewControllers count] > 0)
                {
                    [[slideBar tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self swapViewControllerAtIndex:0 inSlideBarHolder:rightSlideBarHolder animated:NO];
                }
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Custom Setter and Getter Methods

- (void)setLeftViewControllers:(NSArray *)viewControllers andPushFirstVC:(BOOL)push
{
    _leftViewControllers = viewControllers;
    
    if (_leftSlideBarVC)
    {
        [_leftSlideBarVC setSlideBarViewControllers:_leftViewControllers];
    
        if (_leftViewControllers && [_leftViewControllers count] > 0 && push)
        {
            [[_leftSlideBarVC tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self swapViewControllerAtIndex:0 inSlideBarHolder:leftSlideBarHolder animated:YES];
        }
    }
}

- (void)setRightViewControllers:(NSArray *)viewControllers andPushFirstVC:(BOOL)push
{
    _rightViewControllers = viewControllers;
    
    if (_rightSlideBarVC)
    {
        [_rightSlideBarVC setSlideBarViewControllers:_rightViewControllers];
    
        if (_rightViewControllers && [_rightViewControllers count] > 0 && push)
        {
            [[_rightSlideBarVC tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self swapViewControllerAtIndex:0 inSlideBarHolder:rightSlideBarHolder animated:YES];
        }
    }
}

- (void)setLeftViewControllers:(NSArray *)leftViewControllers rightViewControllers:(NSArray *)rightViewControllers andPushFirstVConSide:(LHSlideBarSide)side
{
    [self setLeftViewControllers:leftViewControllers andPushFirstVC:(side == LHSlideBarSideLeft)];
    [self setRightViewControllers:rightViewControllers andPushFirstVC:(side == LHSlideBarSideRight)];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [mainContainerView insertSubview:backgroundView belowSubview:_backgroundView];
    [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
}

- (void)setSlideBarOffset:(int)offset
{
    if (offset > [[self view] bounds].size.width/2)
        _slideBarOffset = [[self view] bounds].size.width/2;
    else
        _slideBarOffset = offset;
    
    if (_leftSlideBarVC)
    {
        [[_leftSlideBarVC view] setFrame:CGRectMake(0, 0, [[_leftSlideBarVC view] bounds].size.width - _slideBarOffset, [[_leftSlideBarVC view] bounds].size.height)];
        [leftSlideBarShadow setFrame:CGRectMake([[_leftSlideBarVC view] bounds].size.width, 0, _slideBarOffset, [[_leftSlideBarVC view] bounds].size.height)];
    }
    
    if (_rightSlideBarVC)
    {
        [[_rightSlideBarVC view] setFrame:CGRectMake(0, 0, [[_rightSlideBarVC view] bounds].size.width - _slideBarOffset, [[_rightSlideBarVC view] bounds].size.height)];
        [rightSlideBarShadow setFrame:CGRectMake([[_rightSlideBarVC view] bounds].size.width, 0, _slideBarOffset, [[_rightSlideBarVC view] bounds].size.height)];
    }
}

- (void)setScaleAmount:(float)scale
{
    if (scale > 1.0)
        _scaleAmount = 1.0;
    else if (scale < 0.0)
        _scaleAmount = 0.0;
    else
        _scaleAmount = scale;
}

- (void)setFadeOutAlpha:(float)alpha
{
    if (alpha > 1.0)
        _fadeOutAlpha = 1.0;
    else if (alpha < 0.0)
        _fadeOutAlpha = 0.0;
    else
        _fadeOutAlpha = alpha;
    
    if (leftSlideBarShadow)
        [leftSlideBarShadow setAlpha:_fadeOutAlpha];
    
    if (rightSlideBarShadow)
        [rightSlideBarShadow setAlpha:_fadeOutAlpha];
}

- (void)setAnimTime:(float)animTime
{
    if (animTime < SLIDE_BAR_MIN_ANIM_TIME)
        _animTime = SLIDE_BAR_MIN_ANIM_TIME;
    else
        _animTime = animTime;
}

//- (void)setCustomSlideTransformValue:(NSValue *)customSlideTransformValue
//{
//    customSlideTransform = [_customSlideTransformValue CATransform3DValue];
//}

- (void)setKeepRoundedCornersWhenAnim:(BOOL)keepRoundedCornersWhenAnim
{
    _keepRoundedCornersWhenAnim = keepRoundedCornersWhenAnim;
    
    if (_keepRoundedCornersWhenAnim)
    {
        if ([[UIApplication sharedApplication] statusBarStyle] == UIStatusBarStyleDefault)
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:[mainContainerView bounds]
                                                           byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(IPHONE_CORNER_RADIUS, IPHONE_CORNER_RADIUS)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            [maskLayer setFrame:[mainContainerView bounds]];
            [maskLayer setPath:[maskPath CGPath]];
            [[mainContainerView layer] setMask:maskLayer];
        }
        else
            [[mainContainerView layer] setCornerRadius:IPHONE_CORNER_RADIUS];
    }
    else
    {
        [[mainContainerView layer] setMask:nil];
        [[mainContainerView layer] setCornerRadius:0.0];
    }
}

- (void)setRoundCornersOnLeftSlideBar:(BOOL)roundCornersOnLeftSlideBar
{
    _roundCornersOnLeftSlideBar = roundCornersOnLeftSlideBar;
    
    if (_leftSlideBarVC)
    {
        if (_roundCornersOnLeftSlideBar)
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:[[_leftSlideBarVC view] bounds]
                                                           byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(IPHONE_CORNER_RADIUS, IPHONE_CORNER_RADIUS)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            [maskLayer setFrame:[[_leftSlideBarVC view] bounds]];
            [maskLayer setPath:[maskPath CGPath]];
            [[[_leftSlideBarVC view] layer] setMask:maskLayer];
        }
        else
        {
            [[[_leftSlideBarVC view] layer] setMask:nil];
            [[[_leftSlideBarVC view] layer] setCornerRadius:0.0];
        }
    }
}

- (void)setRoundCornersOnRightSlideBar:(BOOL)roundCornersOnRightSlideBar
{
    _roundCornersOnRightSlideBar = roundCornersOnRightSlideBar;
    
    if (_rightSlideBarVC)
    {
        if (_roundCornersOnRightSlideBar)
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:[[_rightSlideBarVC view] bounds]
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
                                                                 cornerRadii:CGSizeMake(IPHONE_CORNER_RADIUS, IPHONE_CORNER_RADIUS)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            [maskLayer setFrame:[[_rightSlideBarVC view] bounds]];
            [maskLayer setPath:[maskPath CGPath]];
            [[[_rightSlideBarVC view] layer] setMask:maskLayer];
        }
        else
        {
            [[[_rightSlideBarVC view] layer] setMask:nil];
            [[[_rightSlideBarVC view] layer] setCornerRadius:0.0];
        }
    }
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self setRightBarButtonItem:rightBarButtonItem animated:NO];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated
{
    _leftBarButtonItem = leftBarButtonItem;
    
    [[_currentViewController navigationItem] setLeftBarButtonItem:_leftBarButtonItem animated:animated];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated
{
    _rightBarButtonItem = rightBarButtonItem;
    
    [[_currentViewController navigationItem] setRightBarButtonItem:_rightBarButtonItem animated:animated];
}

- (void)updateBarButtonItems
{
    [self setLeftBarButtonItem:_leftBarButtonItem];
    [self setRightBarButtonItem:_rightBarButtonItem];
}

- (BOOL)isSlideBarDragging
{
    return (_leftSlideBarDragging || _rightSlideBarDragging);
}

- (BOOL)isSlideBarShowing
{
    return (_leftSlideBarShowing || _rightSlideBarShowing);
}

#pragma mark - Show SlideBar Methods

- (void)showLeftSlideBarAnimated:(BOOL)animated
{
    [self showLeftSlideBarAnimated:animated completed:nil];
}

- (void)showLeftSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosCenter animated:YES animTime:_animTime completed:completionBlock];
}

- (void)showRightSlideBarAnimated:(BOOL)animated
{
    [self showRightSlideBarAnimated:animated completed:nil];
}

- (void)showRightSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    [self setSlideBarHolder:rightSlideBarHolder toPosition:LHSlideBarPosCenter animated:YES animTime:_animTime completed:completionBlock];
}

- (void)showSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated
{
    [self showSlideBar:slideBar animated:animated completed:nil];
}

- (void)showSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    __weak UIView *slideBarHolder = nil;
    if (slideBar == _leftSlideBarVC)
        slideBarHolder = leftSlideBarHolder;
    else if (slideBar == _rightSlideBarVC)
        slideBarHolder = rightSlideBarHolder;
    
    if (slideBarHolder)
        [self setSlideBarHolder:rightSlideBarHolder toPosition:LHSlideBarPosCenter animated:animated animTime:_animTime completed:completionBlock];
}

#pragma mark - Dismiss SlideBar Methods

- (void)dismissSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated
{
    [self dismissSlideBar:slideBar swapToIndex:NSNotFound animated:animated completed:nil];
}

- (void)dismissSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    [self dismissSlideBar:slideBar swapToIndex:NSNotFound animated:animated completed:completionBlock];
}

- (void)dismissSlideBar:(LHSlideBar *)slideBar swapToIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self dismissSlideBar:slideBar swapToIndex:index animated:animated completed:nil];
}

- (void)dismissSlideBar:(LHSlideBar *)slideBar swapToIndex:(NSUInteger)index animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    NSIndexPath *selectedRowIndexPath = nil;
    __weak UITableView *tableView = nil;
    __weak UIView *slideBarHolder = nil;
    if (slideBar == _leftSlideBarVC)
    {
        tableView = [_rightSlideBarVC tableView];
        if (tableView != nil)
            selectedRowIndexPath = [tableView indexPathForSelectedRow];
        
        slideBarHolder = leftSlideBarHolder;
    }
    else if (slideBar == _rightSlideBarVC)
    {
        tableView = [_leftSlideBarVC tableView];
        if (tableView != nil)
            selectedRowIndexPath = [tableView indexPathForSelectedRow];
        
        slideBarHolder = rightSlideBarHolder;
    }
    
    if (slideBarHolder)
    {
        if (tableView != nil && selectedRowIndexPath != nil && index != _currentIndex && index != NSNotFound)
            [tableView deselectRowAtIndexPath:selectedRowIndexPath animated:YES];
        
        [self swapViewControllerAtIndex:index inSlideBarHolder:slideBarHolder animated:animated completed:completionBlock];
    }
}

#pragma mark - Swap SlideBar Methods

- (void)swapViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    [self swapViewControllerAtIndex:index inSlideBarHolder:slideBarHolder animated:animated completed:nil];
}

- (void)swapViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    __weak NSArray *viewControllers = nil;
    if (slideBarHolder == leftSlideBarHolder)
        viewControllers = _leftViewControllers;
    else if (slideBarHolder == rightSlideBarHolder)
        viewControllers = _rightViewControllers;
    
    __weak UIViewController *viewController = nil;
    if (index != NSNotFound)
        viewController = [viewControllers objectAtIndex:index];
    
    [self swapViewController:viewController inSlideBarHolder:slideBarHolder animated:animated completed:completionBlock];
}

- (void)swapViewController:(UIViewController *)viewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    [self swapViewController:viewController inSlideBarHolder:slideBarHolder animated:animated completed:nil];
}

- (void)swapViewController:(UIViewController *)viewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    __weak NSArray *viewControllers = nil;
    LHSlideBarPos pos = LHSlideBarPosNull;
    if (slideBarHolder == leftSlideBarHolder)
    {
        viewControllers = _leftViewControllers;
        pos = LHSlideBarPosOffLeft;
    }
    else if (slideBarHolder == rightSlideBarHolder)
    {
        viewControllers = _rightViewControllers;
        pos = LHSlideBarPosOffRight;
    }
    
    if (pos == LHSlideBarPosNull)
        return;
    
    [self swapViewController:_currentViewController forNewViewController:viewController inSlideBarHolder:slideBarHolder animated:animated];
    [self setSlideBarHolder:slideBarHolder toPosition:pos animated:animated animTime:_animTime completed:completionBlock];
    
    if (viewController != nil)
    {
        _currentViewController = viewController;
        _currentIndex = [viewControllers indexOfObject:viewController];
        [self updateBarButtonItems];
    }
}

- (void)swapViewController:(UIViewController *)viewController forNewViewController:(UIViewController *)newViewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    if (viewController != newViewController && newViewController != nil)
        [navController setViewControllers:@[newViewController] animated:_animateSwappingNavController];
    
    [self transformViewControllerInSlideBarHolder:slideBarHolder withProgress:1.0 animated:animated];
}

#pragma mark - Swap SlideBar Position Methods

- (void)setSlideBarHolder:(UIView *)slideBarHolder toPosition:(LHSlideBarPos)position animated:(BOOL)animated animTime:(NSTimeInterval)animTime
{
    [self setSlideBarHolder:slideBarHolder toPosition:position animated:animated animTime:animTime completed:nil];
}

- (void)setSlideBarHolder:(UIView *)slideBarHolder toPosition:(LHSlideBarPos)position animated:(BOOL)animated animTime:(NSTimeInterval)animTime completed:(SlideBarCompletionBlock)completionBlock
{
    __weak LHSlideBar *slideBar = nil;
    if (slideBarHolder == leftSlideBarHolder)
    {
        _leftSlideBarDragging = YES;
        slideBar = _leftSlideBarVC;
    }
    else if (slideBarHolder == rightSlideBarHolder)
    {
        _rightSlideBarDragging = YES;
        slideBar = _rightSlideBarVC;
    }
    
    CGPoint center = [slideBarHolder center];
    CGPoint selfCenter = [[self view] center];
    
    int8_t offset = 0;
    if ([LHSlideBarController deviceSystemMajorVersion] < 7)
        offset = 20;
    
    float progress = 1.0;
    switch (position)
    {
        case LHSlideBarPosCenter:
        {
            [slideBar beginAppearanceTransition:YES animated:animated];
            center = CGPointMake(selfCenter.x, selfCenter.y - offset);
            progress = 0.0;
            break;
        }
            
        case LHSlideBarPosOffLeft:
        {
            [slideBar beginAppearanceTransition:NO animated:animated];
            center = CGPointMake(-selfCenter.x, selfCenter.y - offset);
            progress = 1.0;
            break;
        }
            
        case LHSlideBarPosOffRight:
        {
            [slideBar beginAppearanceTransition:NO animated:animated];
            center = CGPointMake([[self view] bounds].size.width + selfCenter.x, selfCenter.y - offset);
            progress = 1.0;
            break;
        }
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                             [self setNeedsStatusBarAppearanceUpdate];
                     } completion:nil];
    
    if (animated)
    {
        [UIView animateWithDuration:animTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [slideBarHolder setCenter:center];
                             [self transformViewInSlideBarHolder:slideBarHolder withProgress:progress];
                         }
                         completion:^(BOOL finished) {
                             [self setSlideBar:slideBar isShowingWithPos:position];
                             if (completionBlock)
                                 completionBlock();
                         }];
    }
    else
    {
        [slideBarHolder setCenter:center];
        [self transformViewInSlideBarHolder:slideBarHolder withProgress:progress];
        
        [self setSlideBar:slideBar isShowingWithPos:position];
        if (completionBlock)
            completionBlock();
    }
}

- (void)setSlideBar:(LHSlideBar *)slideBar isShowingWithPos:(LHSlideBarPos)position
{
    BOOL isShowing = NO;
    switch (position)
    {
        case LHSlideBarPosCenter:
        {
            isShowing = YES;
            break;
        }
            
        case LHSlideBarPosOffLeft:
        {
            isShowing = NO;
            break;
        }
            
        case LHSlideBarPosOffRight:
        {
            isShowing = NO;
            break;
        }
            
        default:
            break;
    }
    
    if (slideBar == _leftSlideBarVC)
    {
        _leftSlideBarDragging = NO;
        _leftSlideBarShowing = isShowing;
    }
    else if (slideBar == _rightSlideBarVC)
    {
        _rightSlideBarDragging = NO;
        _rightSlideBarShowing = isShowing;
    }
    
    [slideBar endAppearanceTransition];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                             [self setNeedsStatusBarAppearanceUpdate];
                     } completion:nil];
}

#pragma mark - Animation and Transformation Methods

- (CATransform3D)scaleTransform3DWithProgress:(float)progress
{
    float scale = [self scaleFromProgress:progress];
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D = CATransform3DScale(transform3D, scale, scale, 1);
    return transform3D;
}

- (CATransform3D)rotateTransform3DWithProgress:(float)progress fromSide:(LHSlideBarSide)side
{
    float progressRev = 1.0 - progress;
    float translate = (progressRev * 60) * -1;
    float degree = ceil(progressRev * -20);
    
    int8_t reverse = 1;
    if (side == LHSlideBarSideRight)
        reverse = -1;
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1.0/-900;
    transform3D = CATransform3DRotate(transform3D, DEGREES_TO_RADIANS(degree*reverse), 0, 1, 0);
    transform3D = CATransform3DTranslate(transform3D, (translate/3)*reverse, 0, translate);
    return transform3D;
}

- (CATransform3D)slideTransform3DWithProgress:(float)progress fromSide:(LHSlideBarSide)side
{
    float progressRev = 1.0 - progress;
    float offset = [[navController view] bounds].size.width * progressRev;
    
    int8_t reverse = 1;
    if (side == LHSlideBarSideRight)
        reverse = -1;
    
    CATransform3D transform3D = CATransform3DIdentity;
    if (offset < _slideBarOffset)
        return transform3D;
    
    transform3D = CATransform3DTranslate(transform3D, (offset - _slideBarOffset) * reverse, 0, 0);
    return transform3D;
}

- (void)transformViewInSlideBarHolder:(UIView *)slideBarHolder withProgress:(float)progress
{
    LHSlideBarSide side = LHSlideBarSideNone;
    if (slideBarHolder == leftSlideBarHolder)
    {
        [leftSlideBarShadow setAlpha:[self alphaFromProgress:progress]];
        side = LHSlideBarSideLeft;
    }
    else if (slideBarHolder == rightSlideBarHolder)
    {
        [rightSlideBarShadow setAlpha:[self alphaFromProgress:progress]];
        side = LHSlideBarSideRight;
    }
    
    switch (_transformType)
    {
        case LHTransformCustom:
        {
//            if (_customSlideTransformValue != nil)
//                [self transformView:view withTransform:customSlideTransform];
            break;
        }
        
        case LHTransformScale:
        {
            [[mainContainerView layer] setTransform:[self scaleTransform3DWithProgress:progress]];
            break;
        }
        
        case LHTransformRotate:
        {
            [[mainContainerView layer] setTransform:[self rotateTransform3DWithProgress:progress fromSide:side]];
            break;
        }
            
        case LHTransformSlide:
        {
            [[mainContainerView layer] setTransform:[self slideTransform3DWithProgress:progress fromSide:side]];
            break;
        }
            
        default:
            break;
    }
}

- (void)transformViewControllerInSlideBarHolder:(UIView *)slideBarHolder withProgress:(float)progress animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:_animTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self transformViewInSlideBarHolder:slideBarHolder withProgress:progress];
                         }
                         completion:nil];
    }
    else
    {
        [self transformViewInSlideBarHolder:slideBarHolder withProgress:progress];
    }
}

- (float)progressPercentForHolderView:(UIView *)slideBarHolder
{
    float difference = (-[[self view] center].x) - [[self view] center].x;
    float progress = [slideBarHolder center].x / difference;
    return progress + 0.5;
}

- (float)scaleFromProgress:(float)progress
{
    float scale = 1.0 - _scaleAmount;
    scale *= progress;
    scale += _scaleAmount;
    return scale;
}

- (float)alphaFromProgress:(float)progress
{
    float alpha = 1.0 - progress;
    alpha *= _fadeOutAlpha;
    return alpha;
}

#pragma mark - General Methods

+ (NSUInteger) deviceSystemMajorVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

#pragma mark - Touch and Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_leftSlideBarDragging || _rightSlideBarDragging)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[self view]];
    
    if (_leftSlideBarShowing)
    {
        if (CGRectContainsPoint([leftSlideBarShadow frame], touchPoint))
            [self dismissSlideBar:_leftSlideBarVC animated:YES];
    }
    else if (_rightSlideBarShowing)
    {
        if (CGRectContainsPoint([rightSlideBarShadow frame], touchPoint))
            [self dismissSlideBar:_rightSlideBarVC animated:YES];
    }
}

- (void)panGestureChanged:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:[self view]];
    
    switch ([gesture state])
    {
        case UIGestureRecognizerStateBegan:
        {
            BOOL isSlideBarShowing = NO;
            __weak LHSlideBar *slideBar = nil;
            
            if (translation.x > 0)
            {
                // Dragging Left to Right
                if ((_leftSlideBarShowing == NO && _rightSlideBarShowing == NO) || _leftSlideBarShowing == YES)
                {
                    if (_leftSlideBarVC == nil)
                        return;
                    
                    isSlideBarShowing = _leftSlideBarShowing;
                    slideBar = _leftSlideBarVC;
                    
                    _leftSlideBarDragging = YES;
                }
                else if (_rightSlideBarShowing)
                {
                    if (_rightSlideBarVC == nil)
                        return;
                    
                    isSlideBarShowing = _rightSlideBarShowing;
                    slideBar = _rightSlideBarVC;
                    
                    _rightSlideBarDragging = YES;
                }
            }
            else if (translation.x < 0)
            {
                // Dragging Right to Left
                if ((_leftSlideBarShowing == NO && _rightSlideBarShowing == NO) || _rightSlideBarShowing == YES)
                {
                    if (_rightSlideBarVC == nil)
                        return;
                    
                    isSlideBarShowing = _rightSlideBarShowing;
                    slideBar = _rightSlideBarVC;
                    
                    _rightSlideBarDragging = YES;
                }
                else if (_leftSlideBarShowing)
                {
                    if (_leftSlideBarVC == nil)
                        return;
                    
                    isSlideBarShowing = _leftSlideBarShowing;
                    slideBar = _leftSlideBarVC;
                    
                    _leftSlideBarDragging = YES;
                }
            }
            else
                return;
            
            [slideBar beginAppearanceTransition:(isSlideBarShowing == NO) animated:YES];
            
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                                     [self setNeedsStatusBarAppearanceUpdate];
                             } completion:nil];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            __weak UIView *slideBarHolder = nil;
            
            if (_leftSlideBarDragging)
            {
                if (_leftSlideBarVC == nil)
                    return;
                
                slideBarHolder = leftSlideBarHolder;
            }
            else if (_rightSlideBarDragging)
            {
                if (_rightSlideBarVC == nil)
                    return;
                
                slideBarHolder = rightSlideBarHolder;
            }
            else
                return;
            
            BOOL moveHolder = NO;
            CGPoint newPoint = CGPointMake([slideBarHolder center].x + translation.x,
                                           [slideBarHolder center].y);
            
            if (translation.x > 0)
            {
                // Dragging Left to Right
                if (_leftSlideBarDragging)
                {
                    if (newPoint.x < [[self view] center].x)
                        moveHolder = YES;
                }
                else if (_rightSlideBarDragging)
                {
                    if (newPoint.x < [[self view] bounds].size.width + [[self view] center].x)
                        moveHolder = YES;
                }
            }
            else if (translation.x < 0)
            {
                // Dragging Right to Left
                if (_leftSlideBarDragging)
                {
                    if (newPoint.x >= -[[self view] center].x)
                        moveHolder = YES;
                }
                else if (_rightSlideBarDragging)
                {
                    if (newPoint.x > [[self view] center].x)
                        moveHolder = YES;
                }
            }
            
            float progress = [self progressPercentForHolderView:slideBarHolder];
            if (_rightSlideBarDragging)
                progress *= -1.0;
            
            if (moveHolder)
            {
                [slideBarHolder setCenter:newPoint];
                
                [self transformViewInSlideBarHolder:slideBarHolder withProgress:progress];
                [gesture setTranslation:CGPointMake(0, 0) inView:[self view]];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            __weak UIView *slideBarHolder = nil;
            
            if (_leftSlideBarDragging)
            {
                if (_leftSlideBarVC == nil)
                    return;
                
                slideBarHolder = leftSlideBarHolder;
            }
            else if (_rightSlideBarDragging)
            {
                if (_rightSlideBarVC == nil)
                    return;
                
                slideBarHolder = rightSlideBarHolder;
            }
            else
                return;
            
            CGPoint velocity = [gesture velocityInView:[self view]];
            LHSlideBarPos pos = LHSlideBarPosNull;
            
            float diff = 0.0;
            if ([slideBarHolder center].x < [[self view] center].x)
                diff = [[self view] center].x + [slideBarHolder center].x;
            else if ([slideBarHolder center].x > [[self view] center].x)
                diff = ([[self view] bounds].size.width + [[self view] center].x) - [slideBarHolder center].x;
            else
                diff = 160.0;
            
            NSTimeInterval animDuration = _animTime;
            float percent = diff / [self view].bounds.size.width;
            
            if (velocity.x > 0)
            {
                // Dragging Left to Right
                if (_leftSlideBarDragging)
                    pos = LHSlideBarPosCenter;
                else if (_rightSlideBarDragging)
                    pos = LHSlideBarPosOffRight;
                
                if ([slideBarHolder center].x < [[self view] center].x)
                    percent = 1.0 - percent;
                
                animDuration = _animTime * percent;
            }
            else if (velocity.x < 0)
            {
                // Dragging Right to Left
                if (_leftSlideBarDragging)
                    pos = LHSlideBarPosOffLeft;
                else if (_rightSlideBarDragging)
                    pos = LHSlideBarPosCenter;
                
               if ([slideBarHolder center].x > [[self view] center].x)
                    percent = 1.0 - percent;
                
                animDuration = _animTime * percent;
            }
            else
            {
                // Zero Velocity
                if (_leftSlideBarDragging)
                    pos = LHSlideBarPosOffLeft;
                else if (_rightSlideBarDragging)
                    pos = LHSlideBarPosOffRight;
                else
                    pos = LHSlideBarPosCenter;
            }
            
            if (animDuration > _animTime)
                animDuration = _animTime;
            if (animDuration < SLIDE_BAR_MIN_ANIM_TIME)
                animDuration = SLIDE_BAR_MIN_ANIM_TIME;
            
            __weak LHSlideBar *slideBar = nil;
            if (slideBarHolder == leftSlideBarHolder)
                slideBar = _leftSlideBarVC;
            else if (slideBarHolder == rightSlideBarHolder)
                slideBar = _rightSlideBarVC;
            
            [self setSlideBarHolder:slideBarHolder toPosition:pos animated:YES animTime:animDuration completed:^{
                [slideBar endAppearanceTransition];
            }];
            
            _leftSlideBarDragging = NO;
            _rightSlideBarDragging = NO;
            
            break;
        }
        
        default:
            break;
    }
}

@end


#pragma mark - UIViewController Category
@implementation UIViewController (LHSlideBarController)
@dynamic slideBarController;

- (LHSlideBarController *)slideBarController
{
    if ([[self parentViewController] isKindOfClass:[LHSlideBarController class]])
    {
        return (LHSlideBarController *)[self parentViewController];
    }
    else if ([[self parentViewController] isKindOfClass:[UINavigationController class]] &&
            [[[self parentViewController] parentViewController] isKindOfClass:[LHSlideBarController class]])
    {
        return (LHSlideBarController *)[[self parentViewController] parentViewController];
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
    UIColor * firstColour = [UIColor clearColor];
    UIColor * secondColour = [UIColor clearColor];
    
    switch (direction)
    {
        case DirectionLeft:
        {
            firstColour = [UIColor colorWithWhite:0.0 alpha:0.0];
            secondColour = [UIColor colorWithWhite:0.0 alpha:1.0];
            break;
        }
            
        case DirectionRight:
        {
            firstColour = [UIColor colorWithWhite:0.0 alpha:1.0];
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

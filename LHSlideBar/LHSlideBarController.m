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

- (id)initWithLeftViewControllers:(NSArray *)viewControllers
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
    
    _slideBarOffset = SLIDE_BAR_OFFSET;
    _scaleAmount = SLIDE_BAR_SCALE;
    _fadeOutAlpha = SLIDE_BAR_ALPHA;
    _animTime = SLIDE_BAR_ANIM_TIME;
    
    _transformType = LHTransformRotate;
    _animatesOnSlide = YES;
    _keepRoundedCornersWhenScaling = YES;
    
    _isLeftSlideBarShowing = NO;
    _slideBarIsDragging = NO;
    
//    [self setCustomSlideTransformValue:nil];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureChanged:)];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [[self view] addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup SlideBar Methods

- (void)setupSlideBarAtPosition:(LHSlideBarPos)pos pushFirstVC:(BOOL)push
{
    LHSlideBar *slideBar = [[LHSlideBar alloc] initWithStyle:UITableViewStylePlain withController:self];
    [self setupSlideBarAtPosition:pos pushFirstVC:push withSlideBar:slideBar];
}

- (LHSlideBar *)setupSlideBarAtPosition:(LHSlideBarPos)pos pushFirstVC:(BOOL)push withSlideBar:(LHSlideBar *)slideBar
{
    CGSize viewSize = [LHSlideBarController viewSizeForViewController:self];
    
    UIView *slideBarHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [slideBarHolder setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self setSlideBarHolder:slideBarHolder toPosition:LHSlideBarPosOffLeft animated:NO animTime:0];
    [slideBarHolder setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:slideBarHolder];
    
    [[slideBar view] setFrame:CGRectMake(0, 0, viewSize.width - _slideBarOffset, viewSize.height)];
    [slideBar setSlideBarViewControllers:_leftViewControllers];
    [slideBarHolder addSubview:[slideBar view]];
    
    UIView *slideBarShadow = [[UIView alloc] initWithFrame:CGRectMake([[slideBar view] bounds].size.width, 0, _slideBarOffset, viewSize.height)];
    [slideBarShadow setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [slideBarShadow setBackgroundColor:[UIColor clearColor]];
    [slideBarShadow addLinearGradientInDirection:DirectionRight];
    [slideBarShadow setAlpha:_fadeOutAlpha];
    [slideBarHolder addSubview:slideBarShadow];
    
    switch (pos)
    {
        case LHSlideBarPosLeft:
        {
            leftSlideBarHolder = slideBarHolder;
            leftSlideBarShadow = slideBarShadow;
            _leftSlideBarVC = slideBar;
            
            if (push)
            {
                if (_leftViewControllers && [_leftViewControllers count] > 0)
                    [self swapViewControllerAtIndex:0 inSlideBarHolder:leftSlideBarHolder animated:NO];
            }
            break;
        }
            
        case LHSlideBarPosRight:
        {
            rightSlideBarHolder = slideBarHolder;
            rightSlideBarShadow = slideBarShadow;
            _rightSlideBarVC = slideBar;
            
            if (push)
            {
                if (_rightViewControllers && [_rightViewControllers count] > 0)
                    [self swapViewControllerAtIndex:0 inSlideBarHolder:rightSlideBarHolder animated:NO];
            }
            break;
        }
            
        default:
            break;
    }
    
    return slideBar;
}

#pragma mark - SlideBar Show Methods

- (void)showLeftSlideBarAnimated:(BOOL)animated
{
    [self showLeftSlideBarAnimated:animated completed:nil];
}

- (void)showLeftSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosCenter animated:YES animTime:_animTime completed:completionBlock];
}

#pragma mark - Custom Setter and Getter Methods

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_leftSlideBarVC)
        [_leftSlideBarVC setSlideBarViewControllers:_leftViewControllers];
    
    if (_leftViewControllers && [_leftViewControllers count] > 0)
        [self swapViewControllerAtIndex:0 inSlideBarHolder:leftSlideBarHolder animated:NO];
}

- (void)setSlideBarOffset:(CGFloat)offset
{
    if (offset > [[self view] bounds].size.width/2)
        _slideBarOffset = [[self view] bounds].size.width/2;
    else
        _slideBarOffset = offset;
    
    [[_leftSlideBarVC view] setFrame:CGRectMake(0, 0, [[_leftSlideBarVC view] bounds].size.width - _slideBarOffset, [[_leftSlideBarVC view] bounds].size.height)];
    [leftSlideBarShadow setFrame:CGRectMake([[_leftSlideBarVC view] bounds].size.width, 0, _slideBarOffset, [[_leftSlideBarVC view] bounds].size.height)];
}

- (void)setScaleAmount:(CGFloat)scale
{
    if (scale > 1.0)
        _scaleAmount = 1.0;
    else if (scale < 0.0)
        _scaleAmount = 0.0;
    else
        _scaleAmount = scale;
}

- (void)setFadeOutAlpha:(CGFloat)alpha
{
    if (alpha > 1.0)
        _fadeOutAlpha = 1.0;
    else if (alpha < 0.0)
        _fadeOutAlpha = 0.0;
    else
        _fadeOutAlpha = alpha;
    
    if (leftSlideBarShadow)
        [leftSlideBarShadow setAlpha:_fadeOutAlpha];
}

- (void)setAnimTime:(CGFloat)animTime
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

#pragma mark - Push, Pop and Swap Methods

- (void)swapViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    [self swapViewControllerAtIndex:index inSlideBarHolder:slideBarHolder animated:animated completed:nil];
}

- (void)swapViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    __weak UIViewController *viewController = [_leftViewControllers objectAtIndex:index];
    [self swapViewController:viewController inSlideBarHolder:slideBarHolder animated:animated completed:completionBlock];
}

- (void)swapViewController:(UIViewController *)viewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    [self swapViewController:viewController inSlideBarHolder:slideBarHolder animated:animated completed:nil];
}

- (void)swapViewController:(UIViewController *)viewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock
{
    if (viewController == nil)
        NSLog(@"LHSlideBar Error: View Controller to swap to nil!");
    
    [self swapViewController:_currentViewController forNewViewController:viewController inSlideBarHolder:slideBarHolder animated:animated];
    [self setSlideBarHolder:leftSlideBarHolder toPosition:LHSlideBarPosOffLeft animated:animated animTime:_animTime completed:completionBlock];
    _currentViewController = viewController;
    _currentIndex = [_leftViewControllers indexOfObject:viewController];
}

- (void)swapViewController:(UIViewController *)viewController forNewViewController:(UIViewController *)newViewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated
{
    if (viewController == newViewController)
        return;
    
    [self willMoveToParentViewController:newViewController];
    [self transformViewController:newViewController withProgress:0.0 animated:NO];
    
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
    
    [self transformViewController:newViewController withProgress:1.0 animated:animated];
}

- (void)setSlideBarHolder:(UIView *)slideBarHolder toPosition:(LHSlideBarPos)position animated:(BOOL)animated animTime:(NSTimeInterval)animTime
{
    [self setSlideBarHolder:slideBarHolder toPosition:position animated:animated animTime:animTime completed:nil];
}

- (void)setSlideBarHolder:(UIView *)slideBarHolder toPosition:(LHSlideBarPos)position animated:(BOOL)animated animTime:(NSTimeInterval)animTime completed:(SlideBarCompletionBlock)completionBlock
{
    CGPoint center = [slideBarHolder center];
    CGPoint selfCenter = [[self view] center];
    
    CGFloat progress = 1.0;
    switch (position)
    {
        case LHSlideBarPosCenter:
        {
            [_leftSlideBarVC beginAppearanceTransition:YES animated:animated];
            center = CGPointMake(selfCenter.x, selfCenter.y - 20);
            progress = 0.0;
            break;
        }
            
        case LHSlideBarPosOffLeft:
        {
            [_leftSlideBarVC beginAppearanceTransition:NO animated:animated];
            center = CGPointMake(-selfCenter.x, selfCenter.y - 20);
            progress = 1.0;
            break;
        }
            
        case LHSlideBarPosOffRight:
        {
            [_leftSlideBarVC beginAppearanceTransition:NO animated:animated];
            center = CGPointMake([[self view] bounds].size.width + selfCenter.x, selfCenter.y - 20);
            progress = 1.0;
            break;
        }
            
        default:
            break;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:animTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [slideBarHolder setCenter:center];
                             [self transformView:[_currentViewController view] withProgress:progress];
                         }
                         completion:^(BOOL finished) {
                             [self setLeftSlideBarIsShowingWithPos:position];
                             [_leftSlideBarVC endAppearanceTransition];
                             
                             if (completionBlock)
                                 completionBlock();
                         }];
    }
    else
    {
        [slideBarHolder setCenter:center];
        [self transformView:[_currentViewController view] withProgress:progress];
        [self setLeftSlideBarIsShowingWithPos:position];
        [_leftSlideBarVC endAppearanceTransition];
        
        if (completionBlock)
            completionBlock();
    }
}

- (void)setLeftSlideBarIsShowingWithPos:(LHSlideBarPos)position
{
    switch (position)
    {
        case LHSlideBarPosCenter:
        {
            _isLeftSlideBarShowing = YES;
            break;
        }
            
        case LHSlideBarPosOffLeft:
        {
            _isLeftSlideBarShowing = NO;
            break;
        }
            
        case LHSlideBarPosOffRight:
        {
            _isLeftSlideBarShowing = NO;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Animation and Transformation Methods

- (CATransform3D)scaleTransform3DWithProgress:(CGFloat)progress
{
    CGFloat scale = [self scaleFromProgress:progress];
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D = CATransform3DScale(transform3D, scale, scale, 1);
    return transform3D;
}

- (CATransform3D)rotateTransform3DWithProgress:(CGFloat)progress
{
    CGFloat progressRev = 1.0 - progress;
    CGFloat translate = (progressRev * 60) * -1;
    CGFloat degree = ceil(progressRev * -20);
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1.0/-900;
    transform3D = CATransform3DRotate(transform3D, DEGREES_TO_RADIANS(degree), 0, 1, 0);
    transform3D = CATransform3DTranslate(transform3D, translate/3, 0, translate);
    return transform3D;
}

- (void)transformView:(UIView *)view withTransform:(CATransform3D)transform3D
{
    if (view == nil || _animatesOnSlide == NO)
        return;
    
    [[view layer] setTransform:transform3D];
    
    if (_keepRoundedCornersWhenScaling)
        [[view layer] setCornerRadius:IPHONE_CORNER_RADIUS];
}

- (void)transformView:(UIView *)view withProgress:(CGFloat)progress
{
    [leftSlideBarShadow setAlpha:[self alphaFromProgress:progress]];
    
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
            [self transformView:view withTransform:[self scaleTransform3DWithProgress:progress]];
            break;
        }
        
        case LHTransformRotate:
        {
            [self transformView:view withTransform:[self rotateTransform3DWithProgress:progress]];
            break;
        }
            
        default:
            break;
    }
}

- (void)transformViewController:(UIViewController *)viewController withProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:_animTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self transformView:[viewController view] withProgress:progress];
                         }
                         completion:nil];
    }
    else
    {
        [self transformView:[viewController view] withProgress:progress];
    }
}

- (CGFloat)progressPercentForLeftHolderView
{
    CGFloat difference = (-[[self view] center].x) - [[self view] center].x;
    CGFloat progress = [leftSlideBarHolder center].x / difference;
    return progress + 0.5;
}

- (CGFloat)scaleFromProgress:(CGFloat)progress
{
    CGFloat scale = 1.0 - _scaleAmount;
    scale *= progress;
    scale += _scaleAmount;
    return scale;
}

- (CGFloat)alphaFromProgress:(CGFloat)progress
{
    CGFloat alpha = 1.0 - progress;
    alpha *= _fadeOutAlpha;
    return alpha;
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

#pragma mark - Touch and Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_slideBarIsDragging)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[self view]];
    
    if (_isLeftSlideBarShowing)
    {
        if (CGRectContainsPoint([leftSlideBarShadow frame], touchPoint))
            [self swapViewControllerAtIndex:_currentIndex inSlideBarHolder:leftSlideBarHolder animated:YES];
    }
}

- (void)panGestureChanged:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:[self view]];
    
    switch ([gesture state])
    {
        case UIGestureRecognizerStateBegan:
        {
            _slideBarIsDragging = YES;
            [_leftSlideBarVC beginAppearanceTransition:(_isLeftSlideBarShowing == NO) animated:YES];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            BOOL moveHolder = NO;
            CGPoint newPoint = CGPointMake([leftSlideBarHolder center].x + translation.x,
                                           [leftSlideBarHolder center].y);
            
            CGFloat progress = [self progressPercentForLeftHolderView];
            
            if (translation.x > 0)
            {
                // Dragging Left to Right
                if (newPoint.x < [[self view] center].x)
                    moveHolder = YES;
            }
            else if (translation.x < 0)
            {
                // Dragging Right to Left
                if (newPoint.x >= -[[self view] center].x)
                    moveHolder = YES;
            }
            
            if (moveHolder)
            {
                [leftSlideBarHolder setCenter:newPoint];
                
                [self transformView:[_currentViewController view] withProgress:progress];
                [gesture setTranslation:CGPointMake(0, 0) inView:[self view]];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = [gesture velocityInView:[self view]];
            NSTimeInterval animDuration = _animTime;
            LHSlideBarPos pos = LHSlideBarPosNull;
            
            // Left SlideBar is Hidden
            
            if (velocity.x > 0)
            {
                // Dragging Left to Right
                pos = LHSlideBarPosCenter;
                
                CGFloat percent = translation.x / [self view].bounds.size.width;
                animDuration = _animTime * percent;
            }
            else if (velocity.x < 0)
            {
                // Dragging Right to Left
                pos = LHSlideBarPosOffLeft;
                
                CGFloat percent = 1 - (fabs(translation.x) / [self view].bounds.size.width);
                animDuration = _animTime * percent;
            }
            else
            {
                // Zero Velocity
                if (_isLeftSlideBarShowing)
                    pos = LHSlideBarPosOffLeft;
                else
                    pos = LHSlideBarPosCenter;
            }
            
            if (animDuration > _animTime)
                animDuration = _animTime;
            if (animDuration < SLIDE_BAR_MIN_ANIM_TIME)
                animDuration = SLIDE_BAR_MIN_ANIM_TIME;
            
            [self setSlideBarHolder:leftSlideBarHolder toPosition:pos animated:YES animTime:animDuration];
            
            _slideBarIsDragging = NO;
            
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

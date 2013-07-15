//
//  LHSlideBarController.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHTableViewController;

typedef void (^SlideBarCompletionBlock)(void);

typedef enum {
    LHBlackoutViewTag
} LHViewTag;

typedef enum {
    DirectionNone,
    DirectionLeft,
    DirectionRight,
    DirectionUp,
    DirectionDown
} Direction;

typedef enum {
    LHSlideBarPosNull = -1,
    LHSlideBarPosCenter,
    LHSlideBarPosOffLeft,
    LHSlideBarPosOffRight
} LHSlideBarPos;

typedef enum {
    LHTransformNone = 0,
    LHTransformCustom,
    LHTransformScale,
    LHTransformRotate,
} LHTransformType;

@interface LHSlideBarController : UIViewController
{
    UIView *leftSlideBarHolder, *leftSlideBarShadow;
    CATransform3D customSlideTransform;
}

@property (strong, readonly, nonatomic) NSArray *leftViewControllers;
@property (strong, readonly, nonatomic) LHTableViewController *slideBarTableVC;
@property (weak, readonly, nonatomic) UIViewController *currentViewController;
@property (assign, readonly, nonatomic) NSUInteger currentIndex;
@property (assign, readonly, nonatomic) BOOL isLeftSlideBarShowing;
@property (assign, readonly, nonatomic) BOOL slideBarIsDragging;

// User changable variables
@property (assign, readonly, nonatomic) CGFloat slideBarOffset;     // Size of the space on the side of the slide bar when it is open. It must be less than half the width of the slide bar controller.
@property (assign, readonly, nonatomic) CGFloat scaleAmount;        // Scale of the current view controller. 0.0 to 1.0 - 1.0 being 100%
@property (assign, readonly, nonatomic) CGFloat fadeOutAlpha;       // Alpha of the fade out gradient in the slideBarOffset space. 0.0 to 1.0
@property (assign, readonly, nonatomic) CGFloat animTime;           // Maximum time for the slide bar animation to slide in or out. Minimum of 0.1s

@property (assign, nonatomic) LHTransformType transformType;
@property (assign, nonatomic) BOOL scalesOnSlide;
@property (assign, nonatomic) BOOL keepRoundedCornersWhenScaling;

@property (strong, readonly, nonatomic) NSValue *customSlideTransformValue;   // Allows users to set there own custom slide transform.

+ (CGSize)viewSizeForViewController:(UIViewController *)viewController;

- (id)initWithViewControllers:(NSArray *)viewControllers;

- (void)setViewControllers:(NSArray *)viewControllers;
- (void)setSlideBarOffset:(CGFloat)offset;
- (void)setScaleAmount:(CGFloat)scale;
- (void)setFadeOutAlpha:(CGFloat)alpha;
- (void)setAnimTime:(CGFloat)animTime;

- (void)swapViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated;
- (void)swapViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;
- (void)swapViewController:(UIViewController *)viewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated;
- (void)swapViewController:(UIViewController *)viewController inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;
- (void)showLeftSlideBarAnimated:(BOOL)animated;
- (void)showLeftSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;

@end


// UIViewController+LHSlideBarController
@interface UIViewController (LHSlideBarController)
@property (strong, nonatomic) LHSlideBarController *slideBarController;
@end


// UIView+LinearGradient
@interface UIView (LinearGradient)
- (void)addLinearGradientInDirection:(Direction)direction;
@end

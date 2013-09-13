//
//  LHSlideBarController.h
//  LHSlideBar
//
//  Created by James Barrow on 12/07/2013.
//  Copyright (c) 2013 Pig on a Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHSlideBar.h"

typedef void (^SlideBarCompletionBlock)(void);

typedef enum {
    LHBlackoutViewTag
} LHViewTag;

typedef enum {
    DirectionNone = 0,
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
    LHSlideBarSideNone = -1,
    LHSlideBarSideLeft,
    LHSlideBarSideRight,
} LHSlideBarSide;

typedef enum {
    LHTransformNone = -1,
    LHTransformCustom,
    LHTransformScale,
    LHTransformRotate,
    LHTransformSlide
} LHTransformType;

@interface LHSlideBarController : UIViewController
{
    UIView *mainContainerView;
    UINavigationController *navController;
    UIView *leftSlideBarHolder, *leftSlideBarShadow;
    UIView *rightSlideBarHolder, *rightSlideBarShadow;
//    CATransform3D customSlideTransform;
}

@property (strong, readonly, nonatomic) NSArray *leftViewControllers;
@property (strong, readonly, nonatomic) NSArray *rightViewControllers;
@property (strong, readonly, nonatomic) LHSlideBar *leftSlideBarVC;
@property (strong, readonly, nonatomic) LHSlideBar *rightSlideBarVC;
@property (weak, readonly, nonatomic) UIViewController *currentViewController;
@property (assign, readonly, nonatomic) NSUInteger currentIndex;
@property (copy, readonly, nonatomic) UIView *backgroundView;
@property (assign, readonly, nonatomic, getter = isLeftSlideBarShowing) BOOL leftSlideBarShowing;
@property (assign, readonly, nonatomic, getter = isRightSlideBarShowing) BOOL rightSlideBarShowing;
@property (assign, readonly, nonatomic) BOOL leftSlideBarIsDragging;
@property (assign, readonly, nonatomic) BOOL rightSlideBarIsDragging;

// User changable variables
@property (assign, readonly, nonatomic) int slideBarOffset;     // Size of the space on the side of the slideBar when it is open. It must be less than half the width of the slideBar controller.
@property (assign, readonly, nonatomic) float scaleAmount;        // Scale of the current view controller. 0.0 to 1.0 - 1.0 being 100%
@property (assign, readonly, nonatomic) float fadeOutAlpha;       // Alpha of the fade out gradient in the slideBarOffset space. 0.0 to 1.0
@property (assign, readonly, nonatomic) float animTime;           // Maximum time for the slideBar animation to slide in or out. Minimum of 0.1s

@property (assign, nonatomic) BOOL animatesOnSlide;                 // If set to `NO` then the view controller does not animate when the slideBar in dragged, opened or dismissed. By default this property is set to `YES`.
@property (assign, nonatomic) BOOL animateSwappingNavController;    // If set to `YES` then slideBarController's UINavigationController will animate on swapping view controller stack.
@property (assign, readonly, nonatomic) BOOL keepRoundedCornersWhenAnim;      // If set to `NO` then the corners will not remain rounded when the drag animation occurs. By default this property is set to `YES`.
@property (assign, readonly, nonatomic) BOOL roundCornersOnLeftSlideBar;
@property (assign, readonly, nonatomic) BOOL roundCornersOnRightSlideBar;

// LHSlideBarController has a `transformType` variable. Set this to choose the type of transformation occours to the view controller when the user drags, opens or dismisses the slideBar.
@property (assign, nonatomic) LHTransformType transformType;

@property(strong, readonly, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property(strong, readonly, nonatomic) UIBarButtonItem *rightBarButtonItem;

//@property (strong, readonly, nonatomic) NSValue *customSlideTransformValue;   // Allows users to set there own custom slide transform.

+ (NSUInteger) deviceSystemMajorVersion;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithLeftViewControllers:(NSArray *)viewControllers;
- (id)initWithRightViewControllers:(NSArray *)viewControllers;
- (id)initWithLeftViewControllers:(NSArray *)leftViewControllers andRightViewControllers:(NSArray *)rightViewControllers;

- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push;
- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push withSlideBar:(LHSlideBar *)slideBar;

- (void)setLeftViewControllers:(NSArray *)viewControllers andPushFirstVC:(BOOL)push;
- (void)setRightViewControllers:(NSArray *)viewControllers andPushFirstVC:(BOOL)push;
- (void)setLeftViewControllers:(NSArray *)leftViewControllers rightViewControllers:(NSArray *)rightViewControllers andPushFirstVConSide:(LHSlideBarSide)side;

- (void)setBackgroundView:(UIView *)backgroundView;

- (void)setSlideBarOffset:(int)offset;
- (void)setScaleAmount:(float)scale;
- (void)setFadeOutAlpha:(float)alpha;
- (void)setAnimTime:(float)animTime;
//- (void)setCustomSlideTransformValue:(NSValue *)customSlideTransformValue;

- (void)setKeepRoundedCornersWhenAnim:(BOOL)keepRoundedCornersWhenAnim;
- (void)setRoundCornersOnLeftSlideBar:(BOOL)roundCornersOnLeftSlideBar;
- (void)setRoundCornersOnRightSlideBar:(BOOL)roundCornersOnRightSlideBar;

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated;
- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated;

- (void)showLeftSlideBarAnimated:(BOOL)animated;
- (void)showLeftSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;
- (void)showRightSlideBarAnimated:(BOOL)animated;
- (void)showRightSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;
- (void)showSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated;
- (void)showSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;

- (void)dismissSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated;
- (void)dismissSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;
- (void)dismissSlideBar:(LHSlideBar *)slideBar swapToIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)dismissSlideBar:(LHSlideBar *)slideBar swapToIndex:(NSUInteger)index animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock;

@end


// UIViewController+LHSlideBarController
@interface UIViewController (LHSlideBarController)
@property (strong, nonatomic) LHSlideBarController *slideBarController;
@end


// UIView+LinearGradient
@interface UIView (LinearGradient)
- (void)addLinearGradientInDirection:(Direction)direction;
@end

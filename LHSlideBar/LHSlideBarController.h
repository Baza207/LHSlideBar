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
    directionNone,
    directionLeft,
    directionRight,
    directionUp,
    directionDown
} Direction;

typedef enum {
    LHSlideBarPosNull = -1,
    LHSlideBarPosCenter,
    LHSlideBarPosOffLeft,
    LHSlideBarPosOffRight
} LHSlideBarPos;

@interface LHSlideBarController : UIViewController
{
    UIView *leftSlideBarHolder, *leftSlideBarShadow;
}

@property (strong, readonly, nonatomic) NSArray *leftViewControllers;
@property (strong, readonly, nonatomic) LHTableViewController *slideBarTableVC;
@property (weak, readonly, nonatomic) UIViewController *currentViewController;
@property (assign, readonly, nonatomic) NSUInteger currentIndex;
@property (assign, readonly, nonatomic) BOOL isLeftSlideBarShowing;
@property (assign, readonly, nonatomic) BOOL slideBarIsDragging;

+ (CGSize)viewSizeForViewController:(UIViewController *)viewController;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers;
- (void)pushViewControllerAtIndex:(NSUInteger)index inSlideBarHolder:(UIView *)slideBarHolder animated:(BOOL)animated;
- (void)showLeftSlideBar:(id)sender;

@end


// UIViewController+LHSlideBarController
@interface UIViewController (LHSlideBarController)
@property (strong, nonatomic) LHSlideBarController *slideBarController;
@end


// UIView+LinearGradient
@interface UIView (LinearGradient)
- (void)addLinearGradientInDirection:(Direction)direction;
@end

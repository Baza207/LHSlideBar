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
    LHSlideBarPosCenter = 0,
    LHSlideBarPosCenterLeft,
    LHSlideBarPosCenterRight,
    LHSlideBarPosOffLeft,
    LHSlideBarPosOffRight
} LHSlideBarPos;

@interface LHSlideBarController : UIViewController
{
    UIView *blackoutView;
}

@property (strong, readonly, nonatomic) NSArray *leftViewControllers;
@property (strong, readonly, nonatomic) LHTableViewController *slideBarTableVC;
@property (weak, readonly, nonatomic) UIViewController *currentViewController;
@property (assign, readonly, nonatomic) NSUInteger currentIndex;

+ (CGSize)viewSizeForViewController:(UIViewController *)viewController;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers;
- (void)pushViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)showSlideBar:(id)sender;

@end


// UIViewController+LHSlideBarController
@interface UIViewController (LHSlideBarController)

@property (strong, nonatomic) LHSlideBarController *slideBarController;

@end

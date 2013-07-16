LHSlideBar
==========

LHSlideBar is a side bar slide in navigation for iOS. Currently it works just for the iPhone in portrait but I am planning to adapt it to landscape and the iPad soon.

To use LHSlideBar add the following files into your project:
- LHSlideBarController.h
- LHSlideBarController.m
- LHTableViewController.h
- LHTableViewController.m

**Note:** You also must include the "QuartzCore" framework into your project.

LHSlideBar requires **iOS 6**+ to work and uses ARC.

### Demo

<table>
	<tr align="center">
		<td width="260">
			<img src="http://blog.pigonahill.com/wp-content/uploads/2013/07/LHSlideBar_1.png" width="240px">
		</td>
		<td width="260">
			<img src="http://blog.pigonahill.com/wp-content/uploads/2013/07/LHSlideBar_4.png" width="240px">
		</td>
		<td width="260">
			<img src="http://blog.pigonahill.com/wp-content/uploads/2013/07/LHSlideBar_5.png" width="240px">
		</td>
	</tr>
</table>

### Implementing LHSlideBar

After adding the relevent files into your project (listed above) you create a new instance of LHSlideBar using the `- (id)initWithViewControllers:(NSArray *)viewControllers` call. With this you need an array of view controllers you want to display with the controller to be passed as the `viewControllers` variable.

If you set this as `nil` or just use `- (id)init` you can use the `- (void)setViewControllers:(NSArray *)viewControllers` call to set or update you view controllers at a later date.  
**Note:** When you update the view controllers for a slide bar then the first view controller in the array will automatically be swapped to.

Below is some example code for setting up LHSlideBar:

```
ViewControllerOne *vcOne = [[ViewControllerOne alloc] initWithNibName:@"ViewControllerOne" bundle:nil];
ViewControllerTwo *vcTwo = [[ViewControllerTwo alloc] initWithNibName:@"ViewControllerTwo" bundle:nil];
ViewControllerThree *vcThree = [[ViewControllerThree alloc] initWithNibName:@"ViewControllerThree" bundle:nil];

NSArray *viewControllers = @[vcOne, vcTwo, vcThree];
_slideBarController = [[LHSlideBarController alloc] initWithViewControllers:viewControllers];
```
Then, just add _slideBarController to you view hierarchy. It can be treated like a `UINavigationController` or `UITabBarController` as it is a subclass of `UIViewController`.

### Swapping View Controllers

To swap a view controller in your defined viewControllers array ether call:
```
- (void)swapViewControllerAtIndex:(NSUInteger)index
                 inSlideBarHolder:(UIView *)slideBarHolder
                         animated:(BOOL)animated
```
-or-
```
- (void)swapViewController:(UIViewController *)viewController
          inSlideBarHolder:(UIView *)slideBarHolder
                  animated:(BOOL)animated
```

Make sure that the `viewController` is not nil along with the `viewController` that will be found by the index. If this happens then the method will not do anything, as it needs a view controller to swap to.

These methods are avaliable with compltion blocks that gets called when the slideBar has finised dismissing. If `animated` is set to `NO` then the completion block gets call instantly.

### Opening the SlideBar

To open the slide bar you need to call:
```
- (void)showLeftSlideBarAnimated:(BOOL)animated
```

This call can be made from any view controller that imports LHSlideBarController with `#import "LHSlideBarController.h"`. You can then call the previous method with the following code from a button press:

```
- (IBAction)slideBarButtonPressed:(id)sender
{
    [[self slideBarController] showLeftSlideBarAnimated:YES];
}
```

This method is avaliable with a compltion block that gets called when the slideBar has finised dismissing. If `animated` is set to `NO` then the completion block gets call instantly.

### LHSlideBar Variables

LHSlideBar has some pre-set variables for slide animation time, fade out alpha and scale down amount. These dont have to be changed, though if you want to you can.

**`@property (assign, nonatomic) CGFloat slideBarOffset`**  
Size of the space on the side of the slide bar when it is open. It must be less than half the width of the slide bar controller.

**`@property (assign, nonatomic) CGFloat scaleAmount`**  
Scale of the current view controller. 0.0 to 1.0 - 1.0 being 100%

**`@property (assign, nonatomic) CGFloat fadeOutAlpha`**  
Alpha of the fade out gradient in the slideBarOffset space. 0.0 to 1.0

**`@property (assign, readonly, nonatomic) CGFloat animTime`**  
Maximum time for the slide bar animation to slide in or out. Minimum of 0.1s

**`@property (assign, nonatomic) BOOL animatesOnSlide`**  
If set to `NO` then the view controller does not animate when the slide bar in drgged, opened or dismissed. By default this property is set to `YES`.

**`@property (assign, nonatomic) BOOL keepRoundedCornersWhenScaling`**  
If set to `NO` then the corners will not remain rouded when the drag animation occurs. By default this property is set to `YES`.

### Side Animations / Transformations

LHSlideBarController has a `transformType` variable. Set this to choose the type of transformation occours to the view controller when the user drags, opens or dismisses the slide bar.  

**`LHTransformScale`**  
Scales down the view controller behind the slide bar to the scale set in `scaleAmount`.  

**`LHTransformRotate`**  
Rotates the view controller in 3D space to look like it is being pushed back under the slide bar ([see demo above](#demo)).  

**Note:** There is a `LHTransformCustom` option that will allow the use of custom tranformation code. This feature is nto yet working and all relevent code is commented out. Therefore if you use this option, nothing will happen.

### LHTableViewController

LHTableViewController shows a table in the slide bar to allow selecting which vuew controller you want to use. All the control rows are displayed in section 0. (Future plans are to make this calss subclass-able to allow customisation and addition of information in the other sections of the table.)


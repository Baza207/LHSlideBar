LHSlideBar
==========

LHSlideBar is a side bar slide in navigation for iOS. Currently it works just for the iPhone in portrait but I am planning to adapt it to landscape and the iPad soon.

To use LHSlideBar add the following files into your project:
- LHSlideBarController.h
- LHSlideBarController.m
- LHSlideBar.h
- LHSlideBar.m

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

After adding the relevent files into your project (listed above) you create a new instance of LHSlideBar using one of the custom init methods. With this, you need an array of view controllers you want to display with the controller in that slideBar to be passed as the `viewControllers` variable. All the init calls are listed below and work in the same way:  
`- (id)initWithLeftViewControllers:(NSArray *)viewControllers`  
`- (id)initWithRightViewControllers:(NSArray *)viewControllers;`  
`- (id)initWithLeftViewControllers:(NSArray *)leftViewControllers andRightViewControllers:(NSArray *)rightViewControllers`  

If you  just use `- (id)init` you can use the following methods to set or update you view controllers at a later date.  
`- (void)setLeftViewControllers:(NSArray *)viewControllers andPushFirstVC:(BOOL)push`
`- (void)setRightViewControllers:(NSArray *)viewControllers andPushFirstVC:(BOOL)push`
`- (void)setLeftViewControllers:(NSArray *)leftViewControllers rightViewControllers:(NSArray *)rightViewControllers andPushFirstVConSide:(LHSlideBarSide)side`

**Note:** When you update the view controllers for a slide bar then the first view controller in the array will automatically be swapped to.

### Setting up a LHSlideBar in your LHSlideBarController

To include a sideBar in you slideBar controller us the following method:  
`- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push`  
There are two possitions you can set slideBars, left and right. You can not have more than these two slideBars in your controller. If you want to use a subclassed version of LHSlideBar then use the following method setting your subclassed slideBar as `slideBar`:  
`- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push withSlideBar:(LHSlideBar *)slideBar`


##### Example Code (code for setting up LHSlideBarController with 1 slideBar on the left)

```
TestViewController *vcOne = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
TestViewController *vcTwo = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
TestViewController *vcThree = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];

[vcOne setTestNumber:1 andColour:[UIColor orangeColor]];
[vcTwo setTestNumber:2 andColour:[UIColor yellowColor]];
[vcThree setTestNumber:3 andColour:[UIColor greenColor]];

NSArray *viewControllers = @[vcOne, vcTwo, vcThree];
_slideBarController = [[LHSlideBarController alloc] initWithLeftViewControllers:viewControllersL];
[_slideBarController setupSlideBarAtPosition:LHSlideBarSideLeft pushFirstVC:YES];
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

- `@property (assign, nonatomic) CGFloat slideBarOffset`  
Size of the space on the side of the slideBar when it is open. It must be less than half the width of the slideBar controller.

- `@property (assign, nonatomic) CGFloat scaleAmount`  
Scale of the current view controller. 0.0 to 1.0 - 1.0 being 100%

- `@property (assign, nonatomic) CGFloat fadeOutAlpha`  
Alpha of the fade out gradient in the slideBarOffset space. 0.0 to 1.0

- `@property (assign, readonly, nonatomic) CGFloat animTime`  
Maximum time for the slideBar animation to slide in or out. Minimum of 0.1s

- `@property (assign, nonatomic) BOOL animatesOnSlide`  
If set to `NO` then the view controller does not animate when the slideBar in drgged, opened or dismissed. By default this property is set to `YES`.

- `@property (assign, nonatomic) BOOL keepRoundedCornersWhenScaling`  
If set to `NO` then the corners will not remain rouded when the drag animation occurs. By default this property is set to `YES`.

### Side Animations / Transformations

LHSlideBarController has a `transformType` variable. Set this to choose the type of transformation occours to the view controller when the user drags, opens or dismisses the slideBar.  

- `LHTransformScale`  
Scales down the view controller behind the slideBar to the scale set in `scaleAmount`.  

- `LHTransformRotate`  
Rotates the view controller in 3D space to look like it is being pushed back under the slideBar ([see demo above](#demo)).  

**Note:** There is a `LHTransformCustom` option that will allow the use of custom tranformation code. This feature is nto yet working and all relevent code is commented out. Therefore if you use this option, nothing will happen.

### LHTableViewController

LHTableViewController shows a table in the slideBar to allow selecting which vuew controller you want to use. All the control rows are displayed in section 0. (Future plans are to make this calss subclass-able to allow customisation and addition of information in the other sections of the table.)


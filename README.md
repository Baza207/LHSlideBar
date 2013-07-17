LHSlideBar
==========

LHSlideBar is a side bar slide in navigation for iOS. Currently it works only for the iPhone in portrait but I am planning to adapt it to landscape and the iPad soon. If is a custom controller based on UIViewController for adding slideBar navigation into an app.

To use LHSlideBar add the following files into your project:  

LHSlideBar/

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

After adding the relevant files into your project (listed above) you create a new instance of LHSlideBar using one of the custom init methods. With this, you need an array of view controllers you want to display with the controller in that slideBar to be passed as the `viewControllers` variable. All the init calls are listed below and work in the same way:  
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
There are two positions you can set slideBars, left and right. You can not have more than these two slideBars in your controller. If you want to use a subclassed version of LHSlideBar then use the following method setting your sub-classed slideBar as `slideBar`:  
`- (void)setupSlideBarAtPosition:(LHSlideBarSide)pos pushFirstVC:(BOOL)push withSlideBar:(LHSlideBar *)slideBar`


##### Example Code (code for setting up LHSlideBarController with 1 slideBar on the left with 3 view controllers)

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

### Showing/Opening the SlideBar

To open the slide bar you need to call one of the following:

`- (void)showLeftSlideBarAnimated:(BOOL)animated`  
`- (void)showLeftSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock`  
`- (void)showRightSlideBarAnimated:(BOOL)animated`  
`- (void)showRightSlideBarAnimated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock`  
`- (void)showSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated`  
`- (void)showSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock`  

If you are calling these methods inside a subclassed version of `LHSlideBar` then it is recommended you use `showSlideBar:animated:` or `showSlideBar:animated:completed:` and pass `self` as the `slideBar` variable.

They can also be called from any view controller that imports LHSlideBarController with `#import "LHSlideBarController.h"`. With this header file imported a `UIViewController` will have a variable `slideBarController`. You can then call any of the previous methods with the following code. This example is from a button press:

```
- (IBAction)slideBarButtonPressed:(id)sender
{
    [[self slideBarController] showLeftSlideBarAnimated:YES];
}
```

The completion blocks for these methods will get called and run when the animation has finished. This means when the slide bar transition has finished, your code in this block will be run.

### Dismissing/Closing the SlideBar

To open the slide bar you need to call one of the following:

`- (void)dismissSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated`  
`- (void)dismissSlideBar:(LHSlideBar *)slideBar animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock`  
`- (void)dismissSlideBar:(LHSlideBar *)slideBar swappingVCIndex:(NSUInteger)index animated:(BOOL)animated`  
`- (void)dismissSlideBar:(LHSlideBar *)slideBar swappingVCIndex:(NSUInteger)index animated:(BOOL)animated completed:(SlideBarCompletionBlock)completionBlock`  

When dismissing a slideBar you must specify an index for the current view controller to swap to. If you just want to dismiss the slideBar without swapping the current view controller set `index` to `NSNotFound` or use ether the `dismissSlideBar:animated:` or `dismissSlideBar:animated:completed:` methods.

The completion blocks for these methods will get called and run when the animation has finished. This means when the slide bar transition has finished, your code in this block will be run.

### LHSlideBar Variables

LHSlideBar has some pre-set variables for slide animation time, fade out alpha and scale down amount. These don't have to be changed, though if you want to you can.

- `@property (assign, nonatomic) CGFloat slideBarOffset`  
Size of the space on the side of the slideBar when it is open. It must be less than half the width of the slideBar controller.

- `@property (assign, nonatomic) CGFloat scaleAmount`  
Scale of the current view controller. 0.0 to 1.0 - 1.0 being 100%

- `@property (assign, nonatomic) CGFloat fadeOutAlpha`  
Alpha of the fade out gradient in the slideBarOffset space. 0.0 to 1.0

- `@property (assign, readonly, nonatomic) CGFloat animTime`  
Maximum time for the slideBar animation to slide in or out. Minimum of 0.1s

- `@property (assign, nonatomic) BOOL animatesOnSlide`  
If set to `NO` then the view controller does not animate when the slideBar in dragged, opened or dismissed. By default this property is set to `YES`.

- `@property (assign, nonatomic) BOOL keepRoundedCornersWhenScaling`  
If set to `NO` then the corners will not remain rounded when the drag animation occurs. By default this property is set to `YES`.

### Side Animations / Transformations

`@property (assign, nonatomic) LHTransformType transformType`

LHSlideBarController has a `transformType` variable. Set this to choose the type of transformation occours to the view controller when the user drags, opens or dismisses the slideBar.  

- `LHTransformScale`  
Scales down the view controller behind the slideBar to the scale set in `scaleAmount`.  

- `LHTransformRotate`  
Rotates the view controller in 3D space to look like it is being pushed back under the slideBar ([see demo above](#demo)).  

**Note:** There is a `LHTransformCustom` option that will allow the use of custom transformation code. This feature is not yet working and all relevant code is commented out. Therefore if you use this option, nothing will happen.

### LHSlideBar

LHSlideBar shows a table in the slideBar to allows selecting which view controller to view. All the control rows are displayed in section 0. You can subclass LHSlideBar to be able to customise the table and add extra information in the other sections.

**WARNING** Always remember to leave the first section clear in a subclassed version of LHSlideBar. If you don't then you are likely to break its functionality.

### View Controllers in a LHSlideBarController

You can add any type of UIViewController or subclassed versions there of into a LHSLideBar's viewControllers array. To set the title of a set the view controllers `@property(nonatomic, copy) NSString *title` property. This is the string value that LHSlideBar will use to populate the table with so remember to set it when init you view controller or after it has loaded.

##### Example Code

```
- (void)viewDidLoad
{
  [self setTitle:@"My View Controllers Title"];
}
```

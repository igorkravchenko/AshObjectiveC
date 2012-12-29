
#import "AppDelegate.h"
#import "Trigger.h"
#import "Asteroids.h"

// UIView helpers
#define UIVIEW_MOVE(uiview, x, y) uiview.frame = CGRectMake(x, y, CGRectGetWidth(uiview.frame), CGRectGetHeight(uiview.frame))

#define UIVIEW_GET_SIZE(uiview) uiview.frame.size;
#define UIVIEW_GET_X(uiview) uiview.frame.origin.x
#define UIVIEW_GET_Y(uiview) uiview.frame.origin.y
#define UIVIEW_SET_X(uiview, x) UIVIEW_MOVE(uiview, x, UIVIEW_GET_Y(uiview))
#define UIVIEW_SET_Y(uiview, y) UIVIEW_MOVE(uiview, UIVIEW_GET_X(uiview), y)
#define UIVIEW_ADD_X(uiview, addX) UIVIEW_SET_X(uiview, UIVIEW_GET_X(uiview) + addX)
#define UIVIEW_ADD_Y(uiview, addY) UIVIEW_SET_Y(uiview, UIVIEW_GET_Y(uiview) + addY)

#define UIVIEW_RESIZE(uiview, w, h) uiview.frame = CGRectMake(uiview.frame.origin.x, uiview.frame.origin.y, w, h)
#define UIVIEW_GET_WIDTH(uiview) CGRectGetWidth(uiview.frame)
#define UIVIEW_GET_HEIGHT(uiview) CGRectGetHeight(uiview.frame)
#define UIVIEW_SET_WIDTH(uiview, w) UIVIEW_RESIZE(uiview, w, UIVIEW_GET_HEIGHT(uiview))
#define UIVIEW_SET_HEIGHT(uiview, h) UIVIEW_RESIZE(uiview, UIVIEW_GET_WIDTH(uiview), h)


@implementation AppDelegate
{
    Asteroids * asteroids;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    _window.backgroundColor = [UIColor grayColor];
    
    UIButton * leftButton = [self makeButton:@"Left"];
    leftButton.tag = TriggerLeft;
    [_window addSubview:leftButton];
    UIVIEW_MOVE(leftButton, 0, UIVIEW_GET_HEIGHT(_window) -
                               UIVIEW_GET_HEIGHT(leftButton));
    UIButton * rightButton = [self makeButton:@"Right"];
    rightButton.tag = TriggerRight;
    [_window addSubview:rightButton];
    UIVIEW_MOVE(rightButton, UIVIEW_GET_WIDTH(_window) -
                UIVIEW_GET_WIDTH(rightButton), UIVIEW_GET_HEIGHT(_window) -
                UIVIEW_GET_HEIGHT(rightButton));
    UIVIEW_SET_WIDTH(leftButton, UIVIEW_GET_WIDTH(rightButton));
    
    UIButton * accelerateButton = [self makeButton:@"Accelerate"];
    accelerateButton.tag = TriggerAccelerate;
    
    [_window addSubview:accelerateButton];
    UIVIEW_MOVE(accelerateButton, UIVIEW_GET_X(leftButton) + UIVIEW_GET_WIDTH(leftButton), UIVIEW_GET_HEIGHT(_window) -
                UIVIEW_GET_HEIGHT(accelerateButton));
    
    UIButton * gunButton = [self makeButton:@"Fire"];
    gunButton.tag = TriggerGun;
    
    [_window addSubview:gunButton];
    UIVIEW_MOVE(gunButton, UIVIEW_GET_X(accelerateButton) + UIVIEW_GET_WIDTH(accelerateButton), UIVIEW_GET_HEIGHT(_window) -
                UIVIEW_GET_HEIGHT(gunButton));
    UIVIEW_SET_WIDTH(gunButton, UIVIEW_GET_WIDTH(accelerateButton) - 6);
    
    asteroids = [[Asteroids alloc] initWithContainer:_window
                                               width:UIVIEW_GET_WIDTH(_window)
                                              height:UIVIEW_GET_HEIGHT(_window) - 90];
    [asteroids start];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIButton *)makeButton:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor]
                 forState:UIControlStateNormal];
    button.tintColor = [UIColor grayColor];
    [button sizeToFit];
    
    [button addTarget:self
               action:@selector(handleDown:)
     forControlEvents:UIControlEventTouchDown];
    
    [button addTarget:self
               action:@selector(handleUp:)
     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    return button;
}

- (void)handleDown:(UIButton *)sender
{
    [asteroids.triggerPoll addTrigger:(Trigger)sender.tag];
}

- (void)handleUp:(UIButton *)sender
{
    [asteroids.triggerPoll removeTrigger:(Trigger)sender.tag];
}

@end

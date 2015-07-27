
#import "AppDelegate.h"
#import "Trigger.h"
#import "Asteroids.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface RootViewController : UIViewController

@end

@implementation RootViewController

@end

@class TriggerControllerView;

typedef void (^TriggerControllerViewDidAddTrigger)(TriggerControllerView * controllerView, Trigger trigger);
typedef void (^TriggerControllerViewDidRemoveTrigger)(TriggerControllerView * controllerView, Trigger trigger);

@interface TriggerControllerView : UIView

@property (nonatomic, copy) TriggerControllerViewDidAddTrigger didAddTrigger;
@property (nonatomic, copy) TriggerControllerViewDidRemoveTrigger didRemoveTrigger;

@end

typedef void (^touchHandler)(NSSet * touches, UIEvent * event);

@interface TouchView : UIView

@property (nonatomic, copy) touchHandler touchesBegan;
@property (nonatomic, copy) touchHandler touchesMoved;
@property (nonatomic, copy) touchHandler touchesEnded;
@property (nonatomic, copy) touchHandler touchesCancelled;

@end

@implementation TouchView

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if(_touchesBegan)
    {
        _touchesBegan(touches, event);
    }
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if(_touchesMoved)
    {
        _touchesMoved(touches, event);
    }
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(_touchesEnded)
    {
        _touchesEnded(touches, event);
    }
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if(_touchesCancelled)
    {
        _touchesCancelled(touches, event);
    }
}

@end


@implementation TriggerControllerView
{

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat h = CGRectGetHeight(frame);
        TouchView * rotationContainer = [[TouchView alloc] initWithFrame:CGRectMake(h * .5f, 0, h * 2.5f, h)];
        rotationContainer.multipleTouchEnabled = NO;
        [super addSubview:rotationContainer];
        TouchView * shootAndAccelerateContainer = [[TouchView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - h * 2.5f - h * .5f, 0, h * 2.5f, h)];
        shootAndAccelerateContainer.multipleTouchEnabled = YES;
        [super addSubview:shootAndAccelerateContainer];
        UIButton * (^createButton)(NSString *imageName, Trigger trigger, UIView * container) = ^UIButton *(NSString *imageName, Trigger trigger, UIView * container)
        {
            UIButton * control = [[UIButton alloc] init];
            [control setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            control.tag = trigger;
            [control sizeToFit];
            [container addSubview:control];
            control.userInteractionEnabled = NO;
            return control;
        };

        UIButton * leftButton = createButton(@"left-button", TriggerLeft, rotationContainer);
        leftButton.center = CGPointMake(.5f * h , h / 2.f);
        UIButton * rightButton = createButton(@"right-button", TriggerRight, rotationContainer);
        rightButton.center = CGPointMake(h * 2.f, h / 2.f);
        UIButton * shootButton = createButton(@"shoot-button", TriggerGun, shootAndAccelerateContainer);
        shootButton.center = CGPointMake(.5f * h , h / 2.f);
        UIButton * accelerateButton = createButton(@"accelerate-button", TriggerAccelerate, shootAndAccelerateContainer);
        accelerateButton.center = CGPointMake(h * 2.f, h / 2.f);
        CGRect rotationRect = rotationContainer.frame;
        CGFloat w = CGRectGetWidth(rotationRect);
        __weak typeof(rotationContainer) weakRotationContainer = rotationContainer;
        __weak typeof(self) weakSelf = self;

        touchHandler rotationTouchHandler = ^(NSSet *touches, UIEvent *event)
        {
            for (UITouch * touch in touches)
            {
                CGPoint touchPoint = [touch locationInView:weakRotationContainer];
                float xRatio = touchPoint.x / w;
                rightButton.highlighted = xRatio > 0.5f;
                leftButton.highlighted = !rightButton.highlighted;

                if(weakSelf.didAddTrigger)
                {
                    if(leftButton.highlighted)
                    {
                        weakSelf.didAddTrigger(weakSelf, (Trigger) leftButton.tag);
                        weakSelf.didRemoveTrigger(weakSelf, (Trigger) rightButton.tag);
                    }
                    else if(rightButton.highlighted)
                    {
                        weakSelf.didAddTrigger(weakSelf, (Trigger) rightButton.tag);
                        weakSelf.didRemoveTrigger(weakSelf, (Trigger) leftButton.tag);
                    }
                }
            }
        };

        rotationContainer.touchesBegan = rotationContainer.touchesMoved = rotationTouchHandler;
        rotationContainer.touchesCancelled = rotationContainer.touchesEnded = ^(NSSet *touches, UIEvent *event)
        {
            leftButton.highlighted = rightButton.highlighted = NO;
            if(weakSelf.didRemoveTrigger)
            {
                weakSelf.didRemoveTrigger(weakSelf, (Trigger) leftButton.tag);
                weakSelf.didRemoveTrigger(weakSelf, (Trigger) rightButton.tag);
            }
        };

        __weak typeof(rotationContainer) weakShootAndAccelerateContainer = shootAndAccelerateContainer;
        NSArray * buttons = @[shootButton, accelerateButton];
        NSMapTable * touchToButtonMap = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                                              valueOptions:NSMapTableObjectPointerPersonality];
        shootAndAccelerateContainer.touchesBegan = shootAndAccelerateContainer.touchesMoved = ^(NSSet *touches, UIEvent *event)
        {
            for (UITouch * touch in touches)
            {
                CGPoint touchPoint = [touch locationInView:weakShootAndAccelerateContainer];

                for (UIButton * button in buttons)
                {
                    CGRect rect = button.frame;
                    if(CGRectContainsPoint(rect, touchPoint))
                    {
                        button.highlighted = YES;
                        NSMutableSet * mappedButtons = [touchToButtonMap objectForKey:touch];
                        if(!mappedButtons)
                        {
                            mappedButtons = [NSMutableSet set];
                            [touchToButtonMap setObject:mappedButtons
                                                 forKey:touch];

                        }

                        [mappedButtons addObject:button];
                    }
                    else
                    {
                        NSMutableSet * mappedButtons = [touchToButtonMap objectForKey:touch];

                        if(mappedButtons)
                        {
                            NSMutableArray * removeButtons = [NSMutableArray array];
                            for (UIButton * mappedButton in mappedButtons)
                            {
                                CGRect mappedRect = mappedButton.frame;

                                if(!CGRectContainsPoint(mappedRect, touchPoint))
                                {
                                    [removeButtons addObject:mappedButton];
                                }
                            }

                            while (removeButtons.count)
                            {
                                UIButton  * removeButton = removeButtons.lastObject;
                                removeButton.highlighted = NO;
                                [mappedButtons removeObject:removeButton];
                                [removeButtons removeLastObject];
                            }

                            if(mappedButtons.count == 0)
                            {
                                [touchToButtonMap removeObjectForKey:touch];
                            }
                        }
                    }
                }
            }

            if(weakSelf.didAddTrigger && weakSelf.didRemoveTrigger)
            {
                for (UIButton * button in buttons)
                {
                    if(button.highlighted)
                    {
                        weakSelf.didAddTrigger(weakSelf, (Trigger) button.tag);
                    }
                    else
                    {
                        weakSelf.didRemoveTrigger(weakSelf, (Trigger) button.tag);
                    }
                }
            }
        };

        shootAndAccelerateContainer.touchesCancelled = shootAndAccelerateContainer.touchesEnded = ^(NSSet *touches, UIEvent *event)
        {
            NSMutableSet * removeButtons = [NSMutableSet set];

            for (UITouch * touch in touches)
            {
                NSSet * touchedButtons = [touchToButtonMap objectForKey:touch];

                if(touchedButtons)
                {
                    for (UIButton * button in touchedButtons)
                    {
                        [removeButtons addObject:button];
                    }
                }

                [touchToButtonMap removeObjectForKey:touch];
            }

            for (UITouch * relevantTouch in touchToButtonMap)
            {
                NSSet * touchedButtons = [touchToButtonMap objectForKey:relevantTouch];

                if(touchedButtons)
                {
                    for (UIButton * button in touchedButtons)
                    {
                        [removeButtons removeObject:button];
                    }
                }
            }

            for (UIButton * removeButton in removeButtons)
            {
                removeButton.highlighted = NO;
                if(weakSelf.didRemoveTrigger)
                {
                    weakSelf.didRemoveTrigger(weakSelf, (Trigger) removeButton.tag);
                }
            }
        };
    }

    return self;
}

@end

@implementation AppDelegate
{
    Asteroids * asteroids;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarHidden = YES;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    _window = [[UIWindow alloc] initWithFrame:screenRect];
    [_window makeKeyAndVisible];
    _window.rootViewController = [[RootViewController alloc] init];
    UIView * view = _window.rootViewController.view;

    CGRect rect;

    if(SYSTEM_VERSION_LESS_THAN(@"8"))
    {
        rect = CGRectMake(0, 0, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
    }
    else
    {
        rect = CGRectMake(0, 0, CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
    }

    CGFloat w = fmaxf(CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat h = fminf(CGRectGetWidth(rect), CGRectGetHeight(rect));

    view.backgroundColor = [UIColor blackColor];

    TriggerControllerView * rotationControllerView = [[TriggerControllerView alloc] initWithFrame:CGRectMake(0, h - 90, w, 60)];

    asteroids = [[Asteroids alloc] initWithContainer:view
                                               width:w
                                              height:h];
    [asteroids start];
    [view addSubview:rotationControllerView];
    __weak typeof(asteroids) weakAsteroids = asteroids;
    rotationControllerView.didAddTrigger = ^(TriggerControllerView *controllerView, Trigger trigger)
    {
        [weakAsteroids.triggerPoll addTrigger:trigger];
    };

    rotationControllerView.didRemoveTrigger = ^(TriggerControllerView *controllerView, Trigger trigger)
    {
        [weakAsteroids.triggerPoll removeTrigger:trigger];
    };

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

@end

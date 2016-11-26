//
//  AppDelegate.m
//  EpicGlue
//
//  Created by Marek on 05/03/2015.
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import <ECSlidingViewController/ECSlidingViewController.h>
#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Settings.h"
#import "ItemManager.h"
#import "SubscriptionManager.h"
#import "UserManager.h"
#import "User.h"
#import "OnboardingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "InstagramService.h"
#import "ProductHuntService.h"
#import "RedditService.h"
#import "SubscriptionClient.h"
#import "UIColor+EG.h"
#import "ARAnalytics.h"


@interface AppDelegate ()
{
    UIStoryboard *storyboard;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    // TODO: use helper
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.137 green:0.347 blue:0.559 alpha:1.000]];

    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ItemCollectionViewController"];

    _rightViewController = [storyboard instantiateViewControllerWithIdentifier:@"RightMenuViewController"];

    // Initialize managers
    [ItemManager instance];
    [SubscriptionManager instance];
    UserManager *um = [UserManager instance];

    [self navigateToItemsScreens];

//    if ([um hasCompletedOnboarding]) {
//        if ([um isLoggedIn]) {
//        [self navigateToItemsScreens];
//        }
//        else {
//            [self navigateToHomeScreen];
//        }
//    } else {
//        self.window.rootViewController = [self setUpNormalRootViewController];
//    }

    // Logout
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToHomeScreen) name:ENLogout object:nil];

    // If logged in
    if ([um isLoggedIn]) {
        [[SubscriptionManager instance] fetch];
    }

    [ARAnalytics setupWithAnalytics:@{
#ifdef DEBUG
            ARGoogleAnalyticsID : @"UA-50201363-4",
            ARAmplitudeAPIKey : @"ae40177224be872b49cd30a3736f28f5",
#else
    ARGoogleAnalyticsID : @"UA-50201363-5",
    ARAmplitudeAPIKey : @"7edf37d3065bbbc0a7710ec312dbcde0",
#endif
    }];

    if ([um isLoggedIn]) {
        NSString *userId = [NSString stringWithFormat:@"%ld", (long) um.user.userId];
        [ARAnalytics identifyUserWithID:userId andEmailAddress:um.user.email];
    }

    [ARAnalytics event:EVAppOpen];

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
    [ARAnalytics event:EVAppReopen];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];

    [ARAnalytics event:EVAppClose];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "OnlyEpicApps.EpicGlue" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EpicGlue" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EpicGlue.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DDLogInfo(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DDLogInfo(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - iPad and iPhone

- (void)navigateToItemsScreens
{
    _rootViewController.view.layer.shadowOpacity = 1.0f;
    _rootViewController.view.layer.shadowRadius = 50.0f;
    _rootViewController.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // For iPad Only...
        UISplitViewController *splitController = [[UISplitViewController alloc] init];
        splitController.viewControllers = @[_rootViewController, _rightViewController];
        if ([splitController respondsToSelector:@selector(setPreferredDisplayMode:)])
            splitController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.window.rootViewController = splitController;
    }
    else {
        // For iphone Only..
        _slidingController = [ECSlidingViewController slidingWithTopViewController:_rootViewController];
        _slidingController.underRightViewController = _rightViewController;

        _rootViewController.view.layer.shadowOpacity = 1.0f;
        _rootViewController.view.layer.shadowRadius = 10.0f;
        _rootViewController.view.layer.shadowColor = [UIColor menuDarkFont].CGColor;

        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            _slidingController.anchorLeftRevealAmount = _slidingController.view.frame.size.width - (_slidingController.view.frame.size.width / 4);
        }
        else {
            _slidingController.anchorLeftRevealAmount = _slidingController.view.frame.size.width - (_slidingController.view.frame.size.width / 4);
        }
        // configure anchored layout

        [_rootViewController.view addGestureRecognizer:_slidingController.panGesture];
        self.window.rootViewController = _slidingController;
    }
}

- (void)navigateToHomeScreen
{
    UIStoryboard *uiStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *rootViewController = [uiStoryboard instantiateInitialViewController];
    self.window.rootViewController = rootViewController;
}

#pragma mark - UserOnboard

- (OnboardingViewController *)setUpNormalRootViewController
{
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Welcome ! \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit " body:@"" image:[UIImage imageNamed:@"onboarding"] buttonText:@"First Page" action:^{

        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions, providing them useful information about why you'd like those permissions to enhance their experience, increasing your chances they will grant those permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    firstPage.underIconPadding = 5;
    firstPage.titleFontSize = 16;

    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit" body:@"" image:[UIImage imageNamed:@"onboarding"] buttonText:@"Second Page" action:^{

        [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup. As you can see, hitting the action button on the prior page brought you automatically to the next page. Cool, huh?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    secondPage.underIconPadding = 5;
    secondPage.titleFontSize = 16;
    secondPage.movesToNextViewController = YES;

    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Seriously Though" body:@"" image:[UIImage imageNamed:@"onboarding"] buttonText:@"Done" action:^{
        [self navigateToHomeScreen];
        [[UserManager instance] onboardingComplete];
    }];
    thirdPage.underIconPadding = 5;


    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;

    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
//        [self navigateToHomeScreen];
        [self navigateToItemsScreens];

        [[UserManager instance] onboardingComplete];
    };

    return onboardingVC;
}

#pragma mark - openURL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"epicglue"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        id <ConnectableService> serviceToConnect = nil;
        if ([url.host isEqualToString:Instagram]) {
            serviceToConnect = [[InstagramService alloc] init];
        } else if ([url.host isEqualToString:ProductHunt]) {
            serviceToConnect = [[ProductHuntService alloc] init];
        } else if ([url.host isEqualToString:Reddit]) {
            serviceToConnect = [[RedditService alloc] init];
        } else {
            DDLogError(@"%@ is not supported yet", url.host);
            return NO;
        }

        NSDictionary *params = nil;

        if ([url.host isEqualToString:Reddit]) {
            params = @{
                    @"grant_type" : @"authorization_code",
                    @"redirect_uri" : [serviceToConnect callbackUrl],
                    @"code" : [self parseCode:url]
            };

            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[serviceToConnect clientId] password:[serviceToConnect clientSecret]];
        } else {
            params = @{
                    @"client_id" : [serviceToConnect clientId],
                    @"client_secret" : [serviceToConnect clientSecret],
                    @"grant_type" : @"authorization_code",
                    @"redirect_uri" : [serviceToConnect callbackUrl],
                    @"code" : [self parseCode:url]
            };
        }

        [manager POST:[[serviceToConnect accessTokenUrl] absoluteString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DDLogDebug(@"JSON: %@", responseObject);

            [serviceToConnect processResponse:responseObject];

            [[SubscriptionClient instance] connect:serviceToConnect];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DDLogDebug(@"%@", params);
            DDLogError(@"%@ %@", error.localizedDescription, error.localizedFailureReason);
        }];

        return YES;
    }

    return YES;
}

- (NSString *)parseCode:(NSURL *)url
{
    NSArray *queryParams = [[url query] componentsSeparatedByString:@"&"];
    NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
    NSString *codeQuery = codeParam[0];
    NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];

    return code;
}

@end

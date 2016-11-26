//
//  AppDelegate.h
//  EpicGlue
//
//  Created by Marek on 05/03/2015.
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import <CoreData/CoreData.h>
#import <ECSlidingViewController/ECSlidingViewController.h>
#import "RightMenuViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *rootViewController;

@property(strong, nonatomic) RightMenuViewController *rightViewController;
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(strong, nonatomic) ECSlidingViewController *slidingController;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;


@end


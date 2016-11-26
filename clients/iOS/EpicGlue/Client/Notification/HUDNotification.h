//
// Created by Marek Mikuliszyn on 19/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Settings.h"
#import "Notification.h"

@class UIView;
@class MBProgressHUD;


@interface HUDNotification : NSObject <Notification>

+ (instancetype)instance;

- (void)display;

- (void)displayMessage:(NSString *)msg;

- (void)hide;

- (void)displayNotificationMessage:(NSString *)msg;

- (void)displayErrorMessage:(NSString *)msg;
@end
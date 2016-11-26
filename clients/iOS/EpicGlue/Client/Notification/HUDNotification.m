//
// Created by Marek Mikuliszyn on 19/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "HUDNotification.h"
#import "MBProgressHUD.h"


@interface HUDNotification ()
@property(nonatomic) UIWindow *window;
@property(atomic) NSInteger inProgress;
@end

@implementation HUDNotification

+ (instancetype)instance
{
    static HUDNotification *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        _instance.window = [[[UIApplication sharedApplication] windows] lastObject];
        _instance.inProgress = 0;
    });

    return _instance;
}

- (void)display
{
    if (self.inProgress == 0) {
        [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    }
    self.inProgress++;
}

- (void)displayMessage:(NSString *)msg
{
//    DDLogInfo(@"HUD inProgress=%ld (show)", (long) self.inProgress);

    if (self.inProgress == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = msg;
        [hud show:YES];
    }

    self.inProgress++;
}

- (void)hide
{
//    DDLogInfo(@"HUD inProgress=%ld (hide)", (long) self.inProgress);

    self.inProgress--;

    if (self.inProgress < 0) {
        self.inProgress = 0;
    }

    if (self.inProgress == 0) {
//        [UIView animateWithDuration:1.0 animations:^{
        [MBProgressHUD hideHUDForView:self.window animated:YES];
//        }];
    }
}

- (void)displayNotificationMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;

    [hud show:YES];
    [hud hide:YES afterDelay:2.f];
}

- (void)displayErrorMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;

    [hud show:YES];
    [hud hide:YES afterDelay:2.f];
}

@end
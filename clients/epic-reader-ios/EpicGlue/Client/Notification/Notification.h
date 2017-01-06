//
// Created by Marek Mikuliszyn on 19/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class APIError;

@protocol Notification <NSObject>

- (void)display;

- (void)hide;

@optional
- (void)displayMessage:(NSString *)msg;

- (void)displayError:(APIError *)error;

@end
//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Service.h"

@class Counter;

@interface Source : Model

@property(readonly) NSInteger sourceId;
@property(readonly) NSArray *subscriptions;
@property(readonly) NSString *name;
@property(readonly) NSString *sourceDescription;
@property(readonly) NSString *icon;
@property(readonly) BOOL valueAllowed;
@property(readonly) NSString *valueHint;
@property(readonly) NSString *value;
@property(readonly) BOOL isLocked;

@property(atomic) Counter *counter;

@end
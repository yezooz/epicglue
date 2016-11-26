//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "ServiceCategory.h"
#import "Model.h"

@class SubscriptionList;
@class Counter;

@interface Service : Model

@property(readonly) NSInteger serviceId;
@property(readonly) ServiceCategory *category;
@property(readonly) NSArray *sources;
@property(readonly) NSString *shortName;
@property(readonly) NSString *name;
@property(readonly) NSString *serviceDescription;
@property(readonly) NSString *icon;
@property(readonly) BOOL isLocked;
@property(readonly) BOOL isLockedOriginally;
@property(readonly) NSString *unlockURL;
@property(readonly) NSString *userId;
@property(readonly) NSString *username;

@property(atomic) Counter *counter;

@end
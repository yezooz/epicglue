//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class Source;
@class ServiceProfile;
@class Counter;


@interface Subscription : Model

@property(readonly) NSInteger subscriptionId;
@property(readonly) NSString *icon;
@property(readonly) NSString *value;
@property(readonly) NSDate *lastRefreshAt;
@property(readonly) NSString *status;
@property(readonly) BOOL hasSubscribed;

@property(atomic) Counter *counter;

- (instancetype)initWithSubscriptionId:(NSInteger)subscriptionId;

+ (instancetype)subscriptionWithSubscriptionId:(NSInteger)subscriptionId;


@end
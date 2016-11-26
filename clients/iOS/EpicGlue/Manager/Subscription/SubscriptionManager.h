//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class SubscriptionList;
@class Counter;
@class JSONResponse;
@class SubscribeRequest;


@interface SubscriptionManager : NSObject

@property(atomic) SubscriptionList *everythingList;
@property(atomic) SubscriptionList *usersList;

@property(atomic) Counter *counter;

+ (instancetype)instance;

- (void)subscribe:(SubscribeRequest *)request;

- (void)setNotifications;

- (void)fetch;

- (void)parseSubscriptions:(JSONResponse *)json;

- (void)fetchCounters;

- (void)parseCounters:(NSDictionary *)json;

@end
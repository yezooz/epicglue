// Get subscriptions. In future also take care of sub/unsub actions.
//
// Created by Marek Mikuliszyn on 29/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "APIClient.h"

@class SubscriptionList;
@class Counter;
@class Source;
@class ServiceProfile;
@protocol ConnectableService;


@interface SubscriptionClient : APIClient

+ (instancetype)instance;

- (void)getLists;

- (void)getCounters;

- (void)subscribeTo:(NSInteger)source;

- (void)subscribeTo:(NSInteger)source withValue:(NSString *)value;

- (void)subscribeTo:(NSInteger)source withValue:(NSString *)value andProfile:(NSInteger)profile;

- (void)unsubscribe:(NSInteger)userSubId;

- (void)connect:(id <ConnectableService>)service;

- (void)disconnect:(id <ConnectableService>)service;
@end
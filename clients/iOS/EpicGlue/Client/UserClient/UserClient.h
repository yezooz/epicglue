//
// Created by Marek Mikuliszyn on 19/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "APIClient.h"

@class Plan;


@interface UserClient : APIClient

+ (instancetype)instance;

- (void)me;

- (void)registerDeviceId:(NSString *)deviceId;

//- (void)payForPlan:(Plan *)plan usingTransaction:(SKPaymentTransaction *)transaction;

- (void)submitFeedback:(NSString *)message;

@end
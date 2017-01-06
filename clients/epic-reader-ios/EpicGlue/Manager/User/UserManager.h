//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class User;
@class Plan;
@class JSONResponse;
@class APIError;
@class SKPaymentTransaction;

@interface UserManager : NSObject

+ (instancetype)instance;

- (bool)isLoggedIn;

- (void)logout;

- (User *)user;

- (NSString *)token;

- (void)setNotifications;

- (BOOL)hasCompletedOnboarding;

- (void)onboardingComplete;

- (NSArray *)getPlans;

- (void)payForPlan:(Plan *)plan;

- (void)paidForPlan:(Plan *)plan withTransaction:(SKPaymentTransaction *)transaction;

- (void)failedToPayForPlan:(Plan *)plan;

- (void)setSelectedSourceId:(NSInteger)sourceId
                    service:(NSString *)service
          andSubscriptionId:(NSInteger)subscriptionId;

@end
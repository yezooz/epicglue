//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "UserManager.h"
#import "Plan.h"
#import "User.h"

#import "Settings.h"
#import "CurrentSession.h"
#import "UserClient.h"
#import "LoginByEmailResponse.h"
#import "RefreshProfileResponse.h"
#import "IAPHelper.h"
#import "IAPShare.h"
#import "HUDNotification.h"
#import "NSDateFormatter+Custom.h"
#import "RegisterByDeviceIdResponse.h"
#import "ARAnalytics.h"


@implementation UserManager

+ (instancetype)instance
{
    static UserManager *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];

        [_instance setNotifications];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([_instance isLoggedIn]) {
                [[UserClient instance] me];
            } else {
                [[UserClient instance] registerDeviceId:[[NSUUID UUID] UUIDString]];
            }
        });
    });

    return _instance;
}

- (bool)isLoggedIn
{
    return [[[CurrentSession instance].currentUser allKeys] count] > 0;
}

- (void)logout
{
    [[CurrentSession instance] setCurrentUser:nil];
    [[CurrentSession instance] setUserToken:nil];
}

#pragma mark Onboarding

- (BOOL)hasCompletedOnboarding
{
    return [[CurrentSession instance] onboardingComplete];
}

- (void)onboardingComplete
{
    return [[CurrentSession instance] setOnboardingComplete:YES];
}

#pragma mark Payments

- (NSArray<Plan *> *)getPlans
{
    return @[
            [Plan fromJSON:@{
                    @"name": NSLocalizedString(@"PRO PLAN 1", nil),
                    @"price_1": @(2.99),
                    @"price_12": @(29.99),
                    @"product_id": @"com.epicglue.plan.pro.1",
                    @"benefits": @[
                            NSLocalizedString(@"pro benefit 1", nil),
                            NSLocalizedString(@"pro benefit 2", nil),
                    ]
            }],
            [Plan fromJSON:@{
                    @"name": NSLocalizedString(@"UNLIMITED PLAN 1", nil),
                    @"price_1": @(14.99),
                    @"price_12": @(149.99),
                    @"product_id": @"com.epicglue.plan.unlimited.1",
                    @"benefits": @[
                            NSLocalizedString(@"pro benefit 1", nil),
                            NSLocalizedString(@"pro benefit 2", nil),
                    ]
            }],
            [Plan fromJSON:@{
                    @"name": NSLocalizedString(@"FREE PLAN", nil),
                    @"price_1": @(0.0),
                    @"price_12": @(0.0),
                    @"product_id": @"",
                    @"benefits": @[
                            NSLocalizedString(@"free benefit 1", nil),
                            NSLocalizedString(@"free benefit 2", nil)
                    ]
            }]
    ];
}

- (void)payForPlan:(Plan *)plan
{
    [[HUDNotification instance] displayMessage:@"Purchasing"];

    if (![IAPShare sharedHelper].iap) {

        NSSet *dataSet = [[NSSet alloc] initWithObjects:plan.productId, nil];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }

    [IAPShare sharedHelper].iap.production = NO;

    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
//        for (SKProduct *product in response.products) {
//            DDLogInfo(@"Product %@ = %.2f", product.productIdentifier, [product.price floatValue]);
//        }

        [[IAPShare sharedHelper].iap buyProduct:response.products[0] onCompletion:^(SKPaymentTransaction *trans) {
            switch (trans.transactionState) {
                case SKPaymentTransactionStatePurchased:
                    [self paidForPlan:plan withTransaction:trans];

                    DDLogInfo(@"PAID");
                    break;
                case SKPaymentTransactionStateFailed:
                    [self failedToPayForPlan:plan];
                    [ARAnalytics event:EVPurchaseCancel];

                    DDLogInfo(@"FAILED");
                    break;
                case SKPaymentTransactionStateRestored:
                    [ARAnalytics event:EVPurchaseRestore];

                    DDLogInfo(@"RESTORED");
                    break;
                case SKPaymentTransactionStatePurchasing:
                case SKPaymentTransactionStateDeferred:
                    break;
            }

            [[HUDNotification instance] hide];
        }];
    }];
}

- (void)paidForPlan:(Plan *)plan withTransaction:(SKPaymentTransaction *)transaction
{
//    [[UserClient instance] payForPlan:plan usingTransaction:transaction];
}

- (void)failedToPayForPlan:(Plan *)plan
{

}

#pragma mark Others

- (void)setSelectedSourceId:(NSInteger)sourceId service:(NSString *)service andSubscriptionId:(NSInteger)subscriptionId
{
    CurrentSession *session = [CurrentSession instance];
    session.selectedSourceId = sourceId;
    session.selectedServiceShortName = service;
    session.selectedSubscriptionId = subscriptionId;
}

- (User *)user
{
    return [User fromJSON:[CurrentSession instance].currentUser];
}

- (NSString *)token
{
    return [[CurrentSession instance] userToken];
}

- (void)setNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ENRefreshedProfile
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      if ([notification.object isKindOfClass:[RefreshProfileResponse class]]) {
                                                          RefreshProfileResponse *res = notification.object;
                                                          [[CurrentSession instance] setCurrentUser:res.userJSON];

                                                          NSString *userId = [NSString stringWithFormat:@"%ld", (long) res.user.userId];
                                                          [ARAnalytics identifyUserWithID:userId andEmailAddress:res.user.email];
                                                      } else {
                                                          DDLogError(@"%@", @"Object is not RefreshProfileSuccess");
                                                      }
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ENRegisteredDevice
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      if ([notification.object isKindOfClass:[RegisterByDeviceIdResponse class]]) {
                                                          RegisterByDeviceIdResponse *res = notification.object;
                                                          [[CurrentSession instance] setUserToken:res.token];

                                                          [[UserClient instance] me];

                                                          [[NSNotificationCenter defaultCenter] postNotificationName:ENLoggedIn object:nil];

                                                          DDLogInfo(@"User logged in");
                                                      } else {
                                                          DDLogError(@"%@", @"Object is not RegisterByDeviceIdResponse");
                                                      }
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ENPaymentsAcknowledged
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      // Because it's not directly connected with backend, there is a risk
                                                      // that backend reads different list than SKPaymentQueue. It would result
                                                      // in payments server cannot acknowledge. Making another payment would potentially help

                                                      // TODO: Only valid while the queue has observers
                                                      for (SKPaymentTransaction *transaction in [SKPaymentQueue defaultQueue].transactions) {
                                                          [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                                                          [ARAnalytics event:EVPurchaseAcknowledged withProperties:@{
                                                                  @"product_id": transaction.payment.productIdentifier,
                                                                  @"transaction_id": transaction.transactionIdentifier,
                                                                  @"transaction_date": [[NSDateFormatter ISO8601] stringFromDate:transaction.transactionDate]
                                                          }];
                                                      }

                                                      [ARAnalytics event:EVPurchasesAcknowledged];
                                                  }];
}

@end
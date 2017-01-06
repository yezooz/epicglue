//
// Created by Marek Mikuliszyn on 29/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "SubscriptionClient.h"
#import "APIError.h"
#import "Settings.h"
#import "JSONResponse.h"
#import "SubscriptionManager.h"
#import "Payload.h"
#import "HUDNotification.h"
#import "ConnectableService.h"
#import "CurrentSession.h"
#import "ItemManager.h"
#import "ItemHashList.h"


@implementation SubscriptionClient

+ (instancetype)instance
{
    static SubscriptionClient *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (void)getLists
{
    [[HUDNotification instance] displayMessage:@"Get list of subscriptions"];

    [self GET:[self getURLWithSuffix:@"subscriptions"]
    onSuccess:^(JSONResponse *json) {
        [[SubscriptionManager instance] parseSubscriptions:json];

        [[HUDNotification instance] hide];
    }
    onFailure:^(APIError *error) {
        DDLogInfo(@"failed %@", error.localizedDescription);

        [[HUDNotification instance] hide];
    }];
}

- (void)getCounters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([CurrentSession instance].selectedTopBarOption == SelectedTabGlued) {
        params[@"is_glued"] = @(YES);
    } else {
        params[@"is_unread"] = @(YES);
    }

    if ([[[ItemManager instance].readItems getList] count] > 0) {
        params[@"blacklist"] = [[[ItemManager instance].readItems getList] componentsJoinedByString:@","];
    }

    [self POST:[self getURLWithSuffix:@"items/count"]
   withPayload:[Payload withDictionary:params]
     onSuccess:^(JSONResponse *json) {
         [[SubscriptionManager instance] parseCounters:json.dict];
     }
     onFailure:^(APIError *error) {
         DDLogInfo(@"failed %@", error.localizedDescription);
     }];
}

- (void)subscribeTo:(NSInteger)source
{
    [self subscribeTo:source withValue:nil andProfile:0];
}

- (void)subscribeTo:(NSInteger)source withValue:(NSString *)value
{
    [self subscribeTo:source withValue:value andProfile:0];
}

- (void)subscribeTo:(NSInteger)source withValue:(NSString *)value andProfile:(NSInteger)profile
{
    [[HUDNotification instance] displayMessage:@"Subscribing"];

    NSMutableDictionary *payloadDict = [@{@"source_id": @(source)} mutableCopy];
    if (value != nil) {
        payloadDict[@"value"] = value;
    }
    if (profile != 0) {
        payloadDict[@"profile_id"] = @(profile);
    }

    [self PUT:[self getURLWithSuffix:@"subscription"]
  withPayload:[Payload withDictionary:payloadDict]
    onSuccess:^(JSONResponse *json) {
        [[HUDNotification instance] hide];

        [[SubscriptionManager instance] fetch];

        if ([CurrentSession instance].neverHadSubscription) {
            [[CurrentSession instance] setNeverHadSubscription:NO];

            // TODO: analytics
        }
    }
    onFailure:^(APIError *error) {
        DDLogInfo(@"Subscribe failed: %@", error.localizedDescription);

        [[HUDNotification instance] hide];

        [[NSNotificationCenter defaultCenter] postNotificationName:ENSubscribed object:error];
    }];
}

- (void)unsubscribe:(NSInteger)userSubId
{
    [[HUDNotification instance] displayMessage:@"Unsubscribing"];

    [self DELETE:[self getURLWithSuffix:@"subscription"]
     withPayload:[Payload withDictionary:@{@"id": @(userSubId)}]
       onSuccess:^(JSONResponse *json) {
           [[HUDNotification instance] hide];

           [[SubscriptionManager instance] fetch];
       }
       onFailure:^(APIError *error) {
           DDLogInfo(@"Unsubscribe failed: %@", error.localizedDescription);

           [[HUDNotification instance] hide];
           [[HUDNotification instance] displayErrorMessage:@"Request Failed"];

           [[NSNotificationCenter defaultCenter] postNotificationName:ENUnsubscribed object:error];
       }];
}

- (void)connect:(id <ConnectableService>)service
{
    [[HUDNotification instance] displayMessage:@"Registering service"];

    [service getUserInfo:^(ServiceUserInfo *userInfo) {
        [self PUT:[self getURLWithSuffix:@"me/service"]
      withPayload:[Payload withDictionary:[service toPayload]]
        onSuccess:^(JSONResponse *json) {
            [[HUDNotification instance] hide];

            [[SubscriptionManager instance] fetch];
            [[ItemManager instance] load];
        }
        onFailure:^(APIError *error) {
            DDLogError(@"Connect Error %@", error.localizedDescription);

            [[HUDNotification instance] hide];
        }];
    }];
}

- (void)disconnect:(id <ConnectableService>)service
{
    [[HUDNotification instance] displayMessage:@"Deregistering service"];

    [self DELETE:[self getURLWithSuffix:@"me/service"]
     withPayload:[Payload withDictionary:service.user]
       onSuccess:^(JSONResponse *json) {
           [[HUDNotification instance] hide];

           [[SubscriptionManager instance] fetch];
           [[ItemManager instance] load];
       }
       onFailure:^(APIError *error) {
           DDLogError(@"Connect Error %@", error.localizedDescription);

           [[HUDNotification instance] hide];
       }];
}

@end
//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "SubscriptionManager.h"
#import "SubscriptionList.h"
#import "SubscriptionClient.h"
#import "Counter.h"
#import "Service.h"
#import "Source.h"
#import "Subscription.h"
#import "JSONResponse.h"
#import "DDLogMacros.h"
#import "SubscribeRequest.h"
#import "HUDNotification.h"


@implementation SubscriptionManager

+ (instancetype)instance
{
    static SubscriptionManager *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        _instance.everythingList = [[SubscriptionList alloc] init];
        _instance.usersList = [[SubscriptionList alloc] init];
        _instance.counter = [[Counter alloc] initWithValue:0];

        [_instance setNotifications];
    });

    return _instance;
}

#pragma mark - Subscribe

- (void)subscribe:(SubscribeRequest *)request
{
    [[SubscriptionClient instance] subscribeTo:request.sourceId withValue:request.value andProfile:request.profileId];
}

- (void)setNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ENLoggedIn
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      [self fetch];
                                                  }];
}

#pragma mark - Fetch Subscriptions

- (void)fetch
{
    [[SubscriptionClient instance] getLists];
}

- (void)removeCurrentKVO
{
    for (Service *service in self.everythingList.list) {
        @try {
            [service.counter removeObserver:[SubscriptionManager instance] forKeyPath:@"value"];
        }
        @catch (id anException) {}

        for (Source *source in service.sources) {
            @try {
                [source.counter removeObserver:[SubscriptionManager instance] forKeyPath:@"value"];
            }
            @catch (id anException) {}

            for (Subscription *subscription in source.subscriptions) {
                @try {
                    [subscription.counter removeObserver:[SubscriptionManager instance] forKeyPath:@"value"];
                }
                @catch (id anException) {}
            }
        }
    }
}

- (void)parseSubscriptions:(JSONResponse *)json
{
    // TODO: refactor, make it one filtered-on-demand list
    SubscriptionList *everythingList = [[SubscriptionList alloc] init];
    SubscriptionList *usersList = [[SubscriptionList alloc] init];
    Counter *counter = [[Counter alloc] initWithValue:0];

    for (NSDictionary *dict in json.array) {
        Service *service = [Service fromJSON:dict];
        NSInteger emptyCount = 0;

        for (Source *source in [service sources]) {
            if ([source.subscriptions count] == 0) {
                emptyCount++;
            }
        }

        if (emptyCount != [[service sources] count]) {
//            [service.counter addObserver:[SubscriptionManager instance] forKeyPath:@"value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [usersList addService:service];
        }
        [everythingList addService:service];
    }

    // Replace current values
    [self removeCurrentKVO];

    self.usersList = usersList;
    self.everythingList = everythingList;
    self.counter = counter;

    [[NSNotificationCenter defaultCenter] postNotificationName:ENSubscriptionList object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"value"]) {
        NSInteger old = 0;
        if (change[NSKeyValueChangeOldKey] != [NSNull null]) {
            old = [change[NSKeyValueChangeOldKey] integerValue];
        }
        NSInteger new = [change[NSKeyValueChangeNewKey] integerValue];

        if (old == new) {
            return;
        }

        if (self.counter.value == 0) {
            self.counter.value = new;
        } else {
            self.counter.value = self.counter.value + (new - old);
        }
    }
}

#pragma mark - Counters

- (void)fetchCounters
{
    [[SubscriptionClient instance] getCounters];
}

- (void)parseCounters:(NSDictionary *)json
{
    BOOL hasUpdated = NO;

    for (NSString *key in [json allKeys]) {
        NSInteger value = [json[key] integerValue];

        for (Service *service in [[[SubscriptionManager instance] usersList] list]) {
            for (Source *source in service.sources) {
                for (Subscription *subscription in source.subscriptions) {
                    if (subscription.subscriptionId == [key integerValue]) {
                        if (subscription.counter.value != value) {
                            subscription.counter.value = value;

                            hasUpdated = YES;
                        }

                        break;
                    }
                }
            }
        }
    }

    if (hasUpdated) {
        NSInteger total = 0;
        for (Service *service in self.usersList.list) {
            long serviceTotal = 0;
            for (Source *src in service.sources) {
                long sourceTotal = 0;
                for (Subscription *sub in src.subscriptions) {
                    sourceTotal += sub.counter.value;
                }
                src.counter.value = sourceTotal;
                serviceTotal += sourceTotal;
            }
            service.counter.value = serviceTotal;
            total += serviceTotal;
        }
        self.counter.value = total;

        [[NSNotificationCenter defaultCenter] postNotificationName:ENCounters object:nil];
    }
}

@end
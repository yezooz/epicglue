//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "KWValue.h"
#import "Subscription.h"
#import "Counter.h"


@implementation Subscription

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super self];
    _subscriptionId = [json[@"id"] integerValue];
    _icon = json[@"icon"];
    _value = json[@"value"];
//    _lastRefreshAt = [DateParser dateFromString:[json objectForKey:@"last_refresh_at"]];

    // TODO: fix
//    _hasSubscribed = (BOOL) json[@"has_subscribed"];
    _hasSubscribed = YES;

    // Assigned to 0 to trigger KV observer later
    _counter = [[Counter alloc] initWithValue:@0];

    return self;
}

- (instancetype)initWithSubscriptionId:(NSInteger)subscriptionId
{
    self = [super init];
    if (self) {
        _subscriptionId = subscriptionId;
    }

    return self;
}

+ (instancetype)subscriptionWithSubscriptionId:(NSInteger)subscriptionId
{
    return [[self alloc] initWithSubscriptionId:subscriptionId];
}


@end
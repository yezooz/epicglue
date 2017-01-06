//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "SubscriptionList.h"
#import "Subscription.h"
#import "Service.h"


@implementation SubscriptionList

- (id)init
{
    self = [super init];
    if (self) {
        self.list = [NSMutableArray array];
    }

    return self;
}

- (Service *)serviceAtIndex:(NSInteger)index
{
    return self.list[(NSUInteger) index];
}

- (void)addService:(Service *)service
{
    [self.list addObject:service];
}

- (NSInteger)count
{
    return [self.list count];
}

@end
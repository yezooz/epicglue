//
// Created by Marek Mikuliszyn on 12/03/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "SelectedService.h"
#import "Subscription.h"
#import "Source.h"


@implementation SelectedService
+ (instancetype)selectedServiceWithService:(Service *)service source:(Source *)source subscription:(Subscription *)subscription
{
    return [[self alloc] initWithService:service source:source subscription:subscription];
}

- (instancetype)initWithService:(Service *)service source:(Source *)source subscription:(Subscription *)subscription
{
    if (self = [super init]) {
        _service = service;
        _source = source;
        _subscription = subscription;
    }

    return self;
}

@end
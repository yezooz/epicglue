//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class Service;


@interface SubscriptionList : NSObject

@property(atomic) NSMutableArray *list;

//@property (atomic) NSNumber *count;

- (Service *)serviceAtIndex:(NSInteger)index;

- (void)addService:(Service *)service;

- (NSInteger)count;

@end
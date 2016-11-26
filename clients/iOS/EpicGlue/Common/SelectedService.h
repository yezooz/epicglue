//
// Created by Marek Mikuliszyn on 12/03/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//



@class Subscription;
@class Source;
@class Service;

@interface SelectedService : NSObject

@property(readonly) Service *service;
@property(readonly) Source *source;
@property(readonly) Subscription *subscription;

- (instancetype)initWithService:(Service *)service source:(Source *)source subscription:(Subscription *)subscription;

+ (instancetype)selectedServiceWithService:(Service *)service source:(Source *)source subscription:(Subscription *)subscription;


@end
//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class Service;
@class User;


@interface UserSocialProfile : Model

@property(readonly) User *user;
@property(readonly) Service *service;
@property(readonly) NSDictionary *jsonProfile;
@property(readonly) BOOL isActive;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;

@end
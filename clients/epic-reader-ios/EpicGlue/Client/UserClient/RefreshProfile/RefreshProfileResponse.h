//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Response.h"

@class User;


@interface RefreshProfileResponse : NSObject <Response>

@property(readonly) User *user;
@property(readonly) NSDictionary *userJSON;

@end
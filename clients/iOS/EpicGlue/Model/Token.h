//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class ServiceProfile;


@interface Token : Model

@property(readonly) ServiceProfile *profile;
@property(readonly) NSString *token;
@property(readonly) NSString *tokenSecret;
@property(readonly) NSString *refreshToken;
@property(readonly) NSDate *resetAt;
@property(readonly) BOOL isActive;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;

@end
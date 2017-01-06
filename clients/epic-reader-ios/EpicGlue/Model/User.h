//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class Plan;


@interface User : Model

@property(readonly) NSInteger userId;
@property(readonly) NSString *username;
@property(readonly) NSString *email;
@property(readonly) NSString *facebookId;
@property(readonly) NSString *twitterId;
@property(readonly) NSString *instagramId;
@property(readonly) Plan *plan;

@end
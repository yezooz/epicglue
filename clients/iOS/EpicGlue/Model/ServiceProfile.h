//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class Service;
@class User;


@interface ServiceProfile : Model

@property(readonly) NSInteger profileId;
@property(readonly) NSString *identifier;
@property(readonly) NSString *friendlyName;

@end
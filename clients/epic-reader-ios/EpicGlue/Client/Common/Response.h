//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class JSONResponse;
@class APIError;

@protocol Response <NSObject>

+ (id)fromJSON:(JSONResponse *)json;

- (id)initWithJSON:(JSONResponse *)json;

@end
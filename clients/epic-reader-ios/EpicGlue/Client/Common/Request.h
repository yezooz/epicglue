//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@protocol Request <NSObject>

+ (id)fromJSON:(NSDictionary *)json;

- (id)initWithJSON:(NSDictionary *)json;

- (BOOL)isValid;

@end
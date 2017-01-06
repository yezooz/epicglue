//
// Created by Marek Mikuliszyn on 19/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Model.h"


@implementation Model

+ (instancetype)fromJSON:(NSDictionary *)json
{
    return [[self alloc] initWithJSON:json];
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    return nil;
}

@end
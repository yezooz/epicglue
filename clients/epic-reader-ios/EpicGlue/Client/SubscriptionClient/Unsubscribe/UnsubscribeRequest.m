//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "UnsubscribeRequest.h"


@implementation UnsubscribeRequest

+ (id)fromJSON:(NSDictionary *)json
{
    return [[UnsubscribeRequest alloc] initWithJSON:json];
}

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _userSubId = json[@"id"];

    return self;
}

- (BOOL)isValid
{
    return YES;
}


@end
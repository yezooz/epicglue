//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "ServiceProfile.h"


@implementation ServiceProfile

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _profileId = (NSInteger) json[@"id"];
    _identifier = json[@"identifier"];
    _friendlyName = json[@"friendly_name"];

    return self;
}

@end
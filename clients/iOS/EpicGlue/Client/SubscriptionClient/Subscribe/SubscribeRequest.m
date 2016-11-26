//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "KWValue.h"
#import "SubscribeRequest.h"


@implementation SubscribeRequest

+ (id)fromJSON:(NSDictionary *)json
{
    return [[SubscribeRequest alloc] initWithJSON:json];
}

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _sourceId = [json[@"source_id"] integerValue];
    _profileId = [json[@"profile_id"] integerValue];
    _value = json[@"value"];

    return self;
}

- (BOOL)isValid
{
    return self.sourceId != 0;
}


@end
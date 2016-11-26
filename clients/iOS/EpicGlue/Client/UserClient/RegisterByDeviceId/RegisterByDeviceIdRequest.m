//
// Created by Marek Mikuliszyn on 04/11/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RegisterByDeviceIdRequest.h"


@implementation RegisterByDeviceIdRequest

+ (instancetype)fromJSON:(NSDictionary *)json
{
    return [[RegisterByDeviceIdRequest alloc] initWithJSON:json];
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _deviceId = json[@"device_id"];

    return self;
}

- (BOOL)isValid
{
    return [self.deviceId length] < 100;
}

@end
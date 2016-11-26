//
// Created by Marek Mikuliszyn on 04/11/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RegisterByDeviceIdResponse.h"
#import "JSONResponse.h"


@implementation RegisterByDeviceIdResponse

+ (instancetype)fromJSON:(JSONResponse *)json
{
    return [[RegisterByDeviceIdResponse alloc] initWithJSON:json];
}

- (instancetype)initWithJSON:(JSONResponse *)json
{
    self = [super init];
    _token = json.dict[@"token"];
    return self;
}

- (BOOL)isValid
{
    return [self.token length] == 32;
}

@end
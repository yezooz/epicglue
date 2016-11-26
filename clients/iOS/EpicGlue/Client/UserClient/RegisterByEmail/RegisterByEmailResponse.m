//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RegisterByEmailResponse.h"
#import "JSONResponse.h"


@implementation RegisterByEmailResponse

+ (instancetype)fromJSON:(JSONResponse *)json
{
    return [[RegisterByEmailResponse alloc] initWithJSON:json];
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
//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "LoginByEmailResponse.h"
#import "JSONResponse.h"


@implementation LoginByEmailResponse

+ (id)fromJSON:(JSONResponse *)json
{
    return [[LoginByEmailResponse alloc] initWithJSON:json];
}

- (id)initWithJSON:(JSONResponse *)json
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
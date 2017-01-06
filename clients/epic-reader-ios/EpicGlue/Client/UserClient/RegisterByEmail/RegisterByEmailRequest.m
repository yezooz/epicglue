//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RegisterByEmailRequest.h"


@implementation RegisterByEmailRequest

+ (instancetype)fromJSON:(NSDictionary *)json
{
    return [[RegisterByEmailRequest alloc] initWithJSON:json];
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _email = json[@"email"];
    _password = json[@"password"];

    return self;
}

- (BOOL)isValid
{
    return [self.email length] > 0 && [self.password length] > 0;
}

@end
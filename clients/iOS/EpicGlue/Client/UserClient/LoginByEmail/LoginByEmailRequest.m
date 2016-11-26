//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "LoginByEmailRequest.h"


@implementation LoginByEmailRequest

+ (id)fromJSON:(NSDictionary *)json
{
    return [[LoginByEmailRequest alloc] initWithJSON:json];
}

- (id)initWithJSON:(NSDictionary *)json
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
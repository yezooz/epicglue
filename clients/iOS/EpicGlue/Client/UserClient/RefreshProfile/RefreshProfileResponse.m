//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "RefreshProfileResponse.h"
#import "User.h"
#import "JSONResponse.h"


@implementation RefreshProfileResponse

+ (id)fromJSON:(JSONResponse *)json
{
    return [[RefreshProfileResponse alloc] initWithJSON:json];
}

- (id)initWithJSON:(JSONResponse *)json
{
    self = [super init];

    @try {
        _user = [User fromJSON:json.dict];
        _userJSON = json.dict;
    }
    @catch (NSException *ex) {

    }

    return self;
}

- (BOOL)isValid
{
    return _user != nil;
}

@end
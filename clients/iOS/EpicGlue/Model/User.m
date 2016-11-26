//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "User.h"
#import "Plan.h"


@implementation User

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];

    _userId = [json[@"id"] integerValue];
    _username = json[@"username"];
    _email = json[@"email"];
    _facebookId = json[@"facebook_id"];
    _twitterId = json[@"twitter_id"];
    _instagramId = json[@"instagram_id"];
    _plan = [Plan fromJSON:json[@"plan"]];

    return self;
}

@end
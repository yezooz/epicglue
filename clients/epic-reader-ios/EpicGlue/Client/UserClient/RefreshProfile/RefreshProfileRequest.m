//
// Created by Marek Mikuliszyn on 23/10/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RefreshProfileRequest.h"


@implementation RefreshProfileRequest

+ (id)fromJSON:(NSDictionary *)json
{
    return [[RefreshProfileRequest alloc] init];
}

- (id)initWithJSON:(NSDictionary *)json
{
    return nil;
}

- (BOOL)isValid
{
    return YES;
}

@end
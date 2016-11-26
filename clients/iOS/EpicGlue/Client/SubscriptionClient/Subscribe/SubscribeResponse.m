//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "SubscribeResponse.h"


@implementation SubscribeResponse

+ (id)fromJSON:(JSONResponse *)json
{
    return [[SubscribeResponse alloc] init];
}

- (id)initWithJSON:(JSONResponse *)json
{
    return nil;
}

- (BOOL)isValid
{
    return NO;
}

@end
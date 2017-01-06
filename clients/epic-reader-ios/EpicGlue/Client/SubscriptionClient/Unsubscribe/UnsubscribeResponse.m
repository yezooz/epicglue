//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "UnsubscribeResponse.h"


@implementation UnsubscribeResponse

+ (id)fromJSON:(JSONResponse *)json
{
    return [[UnsubscribeResponse alloc] init];
}

- (id)initWithJSON:(JSONResponse *)json
{
    return nil;
}

- (BOOL)isValid
{
    return YES;
}

@end
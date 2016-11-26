//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Payload.h"


@implementation Payload

+ (Payload *)withDictionary:(NSDictionary *)dict
{
    Payload *payload = [[self alloc] init];
    payload.dict = dict;
    return payload;
}

@end
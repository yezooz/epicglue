//
// Created by Marek Mikuliszyn on 25/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Location.h"
#import "KWValue.h"


@implementation Location

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];

    _lat = (CGFloat) [json[@"lat"] floatValue];
    _lon = (CGFloat) [json[@"lon"] floatValue];
    _name = json[@"location_name"];

    return self;
}

@end
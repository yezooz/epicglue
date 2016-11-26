//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Video.h"
#import "Helpers.h"


@implementation Video

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];

    _sizeName = [Helpers mediaSizeByString:json[@"size_name"]];
    _URL = json[@"url"];
    _width = (NSInteger) json[@"width"];
    _height = (NSInteger) json[@"height"];

    return self;
}

- (CGFloat)ratio
{
    if (_width == 0 || _height == 0) {
        return 0;
    }
    return (CGFloat) _height / (CGFloat) _width;
}

@end
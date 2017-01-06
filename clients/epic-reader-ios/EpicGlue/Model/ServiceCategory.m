//
// Created by Marek Mikuliszyn on 02/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "ServiceCategory.h"


@implementation ServiceCategory

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _categoryId = (NSInteger) json[@"id"];
    _name = json[@"name"];
    _icon = json[@"icon"];

    return self;
}

@end
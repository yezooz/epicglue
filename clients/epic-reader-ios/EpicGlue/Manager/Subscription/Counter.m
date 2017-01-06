//
// Created by Marek Mikuliszyn on 26/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Counter.h"


@implementation Counter

- (instancetype)initWithValue:(NSInteger)value
{
    self = [super init];
    if (self) {
        self.value = value;
    }

    return self;
}

+ (instancetype)counterWithValue:(NSInteger)value
{
    return [[self alloc] initWithValue:value];
}

@end
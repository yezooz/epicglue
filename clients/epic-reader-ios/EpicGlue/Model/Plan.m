//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Plan.h"


@implementation Plan

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];

    _name = json[@"name"];
    _planDescription = json[@"description"];
    _productId = json[@"product_id"];
    _benefits = json[@"benefits"];
    _pricePerMonth = json[@"price_1"];
    _pricePerYear = json[@"price_12"];
    _ttl = (NSInteger) json[@"ttl"];
    _ttlDescription = json[@"ttl_description"];

    return self;
}

- (BOOL)isFree
{
    return [_pricePerMonth isEqualToNumber:@(0.0)];
}

- (BOOL)isPurchasable
{
    return [_productId isEqualToString:@""];
}

- (NSString *)pricePerMonthString
{
    if (_pricePerMonth == nil) {
        return @"Free";
    }

    return [NSString stringWithFormat:@"$%.2f per month", [_pricePerMonth floatValue]];
}

- (NSString *)pricePerYearString
{
    if (_pricePerYear == nil) {
        return @"Free";
    }

    return [NSString stringWithFormat:@"$%.2f per year", [_pricePerYear floatValue]];
}

@end
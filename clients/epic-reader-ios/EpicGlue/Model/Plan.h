//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"


@interface Plan : Model

@property(readonly) NSString *name;
@property(readonly) NSString *planDescription;
@property(readonly) NSString *productId;
@property(readonly) NSArray<NSString *> *benefits;
@property(readonly) NSNumber *pricePerMonth;
@property(readonly) NSNumber *pricePerYear;
@property(readonly) NSInteger ttl;
@property(readonly) NSString *ttlDescription;

- (BOOL)isFree;

- (BOOL)isPurchasable;

- (NSString *)pricePerMonthString;

- (NSString *)pricePerYearString;
@end
//
// Created by Marek Mikuliszyn on 29/12/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@interface Filter : NSObject

@property(nonatomic) NSString *key;
@property(nonatomic) NSMutableArray *values;

- (id)getValue;

- (void)setValues:(id)values;

- (void)setValue:(id)value;

@end
//
// Created by Marek Mikuliszyn on 26/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@interface Counter : NSObject

@property(atomic) NSInteger value;

- (instancetype)initWithValue:(NSInteger)value;

+ (instancetype)counterWithValue:(NSInteger)value;

@end
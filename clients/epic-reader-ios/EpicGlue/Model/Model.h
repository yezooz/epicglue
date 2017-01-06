//
// Created by Marek Mikuliszyn on 19/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@interface Model : NSObject

+ (instancetype)fromJSON:(NSDictionary *)json;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
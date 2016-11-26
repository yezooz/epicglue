//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@interface Payload : NSObject

@property(nonatomic, copy) NSDictionary *dict;

+ (Payload *)withDictionary:(NSDictionary *)dict;

@end
//
// Created by Marek Mikuliszyn on 19/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@interface JSONResponse : NSObject

@property(nonatomic, readonly) NSArray *array;
@property(nonatomic, readonly) NSDictionary *dict;

+ (JSONResponse *)fromJSON:(id)json;

- (JSONResponse *)initWithArray:(NSArray *)array;

- (JSONResponse *)initWithDict:(NSDictionary *)dict;

@end
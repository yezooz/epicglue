// Holds hash list
//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@interface ItemHashList : NSObject

@property(nonatomic) NSMutableArray *array;

- (void)addHash:(NSString *)hash;

- (BOOL)hasHash:(NSString *)hash;

- (void)addHashList:(NSArray *)list;

- (void)removeHash:(NSString *)hash;

- (NSArray *)getList;

- (int)count;

@end
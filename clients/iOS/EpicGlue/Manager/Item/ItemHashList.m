//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "ItemHashList.h"


@implementation ItemHashList

- (id)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }

    return self;
}

- (void)addHash:(NSString *)hash
{
    if (hash != nil) {
        [self.array addObject:hash];
    }
}

- (BOOL)hasHash:(NSString *)hash
{
    return [self.array indexOfObject:hash] != NSNotFound;
}

- (void)addHashList:(NSArray *)list
{
    [self.array addObjectsFromArray:list];
}

- (void)removeHash:(NSString *)hash
{
    [self.array removeObject:hash];
}

- (NSArray *)getList
{
    return self.array;
}

- (int)count
{
    return (int) [self.array count];
}

@end
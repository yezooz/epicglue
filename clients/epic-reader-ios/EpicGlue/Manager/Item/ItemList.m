//
// Created by Marek Mikuliszyn on 19/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "ItemList.h"
#import "Item.h"
#import "Settings.h"
#import "ItemManager.h"
#import "ItemHashList.h"


@implementation ItemList

- (ItemList *)init
{
    self = [super init];
    self.list = [NSMutableArray array];
    return self;
}

- (void)addItem:(NSDictionary *)item
{
    [self.list addObject:item];
}

- (void)setItems:(NSArray *)items
{
    self.list = [NSMutableArray arrayWithArray:items];
}

- (NSUInteger)findIndex:(Item *)item
{
    NSUInteger index = 0;
    for (NSDictionary *dict in self.list) {
        if ([dict[@"id"] isEqualToString:item.itemId]) {
            return index;
        }
        index++;
    }

    DDLogInfo(@"Failed to find hash");
    return 0;
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.list removeObjectAtIndex:index];
}

- (Item *)getItemAtIndex:(NSInteger)index
{
    if ([self.list count] <= index) {
        return [[Item alloc] init];
    }

    Item *item = [Item fromJSON:self.list[(NSUInteger) index]];
    item.isRead = [[[ItemManager instance] readItems] hasHash:item.itemId];

    return item;
}

- (NSArray *)getList
{
    return self.list;
}

- (Item *)firstItem
{
    if ([self count] == 0) {
        return nil;
    }

    return [self getItemAtIndex:0];
}

- (Item *)lastItem
{
    if ([self count] == 0) {
        return nil;
    }

    return [self getItemAtIndex:[self count] - 1];
}

- (NSInteger)count
{
    return [self.list count];
}

- (void)prependItems:(ItemList *)items
{
    NSMutableArray *newList = items.list;
    [newList addObjectsFromArray:self.list];
    self.list = newList;
}

- (void)appendItems:(ItemList *)items
{
    [self.list addObjectsFromArray:items.list];
}

@end

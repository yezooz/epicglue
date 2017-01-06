// List of items
//
// Created by Marek Mikuliszyn on 19/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class FilterList;
@class Item;


@interface ItemList : NSObject

@property(nonatomic) NSMutableArray *list;

- (void)addItem:(NSDictionary *)item;

- (void)setItems:(NSArray *)items;

- (NSUInteger)findIndex:(Item *)item;

- (void)removeItemAtIndex:(NSUInteger)index;

- (NSArray *)getList;

- (NSInteger)count;

- (Item *)getItemAtIndex:(NSInteger)index;

- (Item *)firstItem;

- (Item *)lastItem;

- (void)prependItems:(ItemList *)items;

- (void)appendItems:(ItemList *)items;

@end
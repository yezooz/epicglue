//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class Item;
@class Service;
@class Subscription;


@interface DataSource : NSObject

@property(nonatomic) NSMutableArray *filters;

@property(nonatomic) NSMutableArray *itemIDs;
@property(nonatomic) NSMutableArray *blacklistItemIDs;
@property(nonatomic) NSMutableArray *services;
@property(nonatomic) NSMutableArray *subscriptions;
@property(nonatomic) NSMutableArray *tags;
@property(nonatomic) NSMutableArray *authors;
@property(nonatomic) NSMutableArray *mediaTypes;
@property(nonatomic) NSMutableArray *searchQueries;
@property(nonatomic) NSDate *before;
@property(nonatomic) NSDate *after;
@property(nonatomic) BOOL onlyRead;
@property(nonatomic) BOOL onlyNotRead;
@property(nonatomic) BOOL onlyPinned;
@property(nonatomic) BOOL onlyNotPinned;

- (void)addItem:(Item *)item;

- (void)addItemHash:(NSString *)hash;

- (void)addItemToBlacklist:(Item *)item;

- (void)addItemHashToBlacklist:(NSString *)hash;

- (void)removeItemHashFromBlacklist:(NSString *)hash;

- (void)addService:(Service *)service;

- (void)addSubscription:(Subscription *)subscription;

- (void)addSearchQuery:(NSString *)query;

- (void)addTag:(NSString *)tag;

- (void)addAuthor:(NSString *)author;

- (void)addMediaType:(NSString *)mediaType;

- (NSString *)buildFilter;

@end
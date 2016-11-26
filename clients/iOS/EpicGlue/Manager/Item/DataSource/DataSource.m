// Build queries for the API
//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "DataSource.h"
#import "Item.h"
#import "Service.h"
#import "Subscription.h"
#import "Settings.h"


@implementation DataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemIDs = [NSMutableArray array];
        _blacklistItemIDs = [NSMutableArray array];
        _services = [NSMutableArray array];
        _subscriptions = [NSMutableArray array];
        _tags = [NSMutableArray array];
        _authors = [NSMutableArray array];
        _mediaTypes = [NSMutableArray array];
        _searchQueries = [NSMutableArray array];

        _before = nil;
        _after = nil;

        _onlyRead = NO;
        _onlyNotRead = NO;
        _onlyPinned = NO;
        _onlyNotPinned = NO;
    }

    return self;
}

- (void)addItem:(Item *)item
{
    [self addItemHash:item.itemId];
}

- (void)addItemHash:(NSString *)hash
{
    [self.itemIDs addObject:hash];
}

- (void)addItemToBlacklist:(Item *)item
{
    [self addItemHashToBlacklist:item.itemId];
}

- (void)addItemHashToBlacklist:(NSString *)hash
{
    if (hash != nil) {
        [self.blacklistItemIDs addObject:hash];
    }
}

- (void)removeItemHashFromBlacklist:(NSString *)hash
{
    [self.blacklistItemIDs removeObject:hash];
}

- (void)addService:(Service *)service
{
    [self.services addObject:service.shortName];
}

- (void)addSubscription:(Subscription *)subscription
{
    [self.subscriptions addObject:[NSString stringWithFormat:@"%ld", (long) subscription.subscriptionId]];
}

- (void)addSearchQuery:(NSString *)query
{
    [self.searchQueries addObject:query];
}

- (void)addTag:(NSString *)tag
{
    [self.tags addObject:tag];
}

- (void)addAuthor:(NSString *)author
{
    [self.authors addObject:author];
}

- (void)addMediaType:(NSString *)mediaType
{
    [self.mediaTypes addObject:mediaType];
}

- (NSString *)buildFilter
{
    NSMutableArray *filters = [NSMutableArray array];

    if ([self.itemIDs count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"id:%@", [self.itemIDs componentsJoinedByString:@","]]];
    }
    if ([self.blacklistItemIDs count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"blacklist:%@", [self.blacklistItemIDs componentsJoinedByString:@","]]];
    }
    if ([self.services count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"service:%@", [self.services componentsJoinedByString:@","]]];
    }
    if ([self.subscriptions count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"sub:%@", [self.subscriptions componentsJoinedByString:@","]]];
    }
    if ([self.searchQueries count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"search:%@", [self.searchQueries componentsJoinedByString:@","]]];
    }
    if ([self.tags count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"tag:%@", [self.tags componentsJoinedByString:@","]]];
    }
    if ([self.authors count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"author:%@", [self.authors componentsJoinedByString:@","]]];
    }
    if ([self.mediaTypes count] > 0) {
        [filters addObject:[NSString stringWithFormat:@"media:%@", [self.mediaTypes componentsJoinedByString:@","]]];
    }

    if (self.before != nil) {
        [filters addObject:[NSString stringWithFormat:@"before:%d", (int) [self.before timeIntervalSince1970]]];
    } else if (self.after != nil) {
        [filters addObject:[NSString stringWithFormat:@"after:%d", (int) [self.after timeIntervalSince1970]]];
    }

    if (self.onlyRead) {
        [filters addObject:@"read"];
    }
    if (self.onlyNotRead) {
        [filters addObject:@"unread"];
    }
    if (self.onlyPinned) {
        [filters addObject:@"glue"];
    }
    if (self.onlyNotPinned) {
        [filters addObject:@"no_glue"];
    }

    DDLogInfo(@"DataSource: %@", [filters componentsJoinedByString:@"|"]);

    return [filters componentsJoinedByString:@"%7C"];
}

@end
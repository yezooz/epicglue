//
// Created by Marek Mikuliszyn on 19/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class UIColor;
@class Media;
@class Location;

@interface Item : Model

@property(readonly) NSString *itemId;
@property(readonly) NSString *author;
@property(readonly) Media *authorMedia;
@property(readonly) Media *media;
@property(readonly) NSString *itemType;
@property(readonly) NSString *mediaType;
@property(readonly) NSString *service;
@property(readonly) NSString *title;
@property(readonly) NSString *itemDescription;
@property(readonly) NSString *url;
@property(readonly) NSString *urlIn;
@property(readonly) NSString *urlExt;
@property(readonly) NSArray *tags;
@property(nonatomic) BOOL isRead;
@property(nonatomic) BOOL isGlued;
@property(readonly) Location *location;
@property(readonly) NSInteger points;
@property(readonly) NSInteger comments;
@property(readonly) NSArray *subs;
@property(readonly) NSDate *contentCreatedAt;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;

- (NSString *)getSourceDescription;

@end
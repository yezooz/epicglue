//
// Created by Marek Mikuliszyn on 19/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Item.h"
#import "DateParser.h"
#import "Media.h"
#import "Location.h"

@implementation Item

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _itemId = json[@"id"];
    _author = json[@"author"];
    _itemType = json[@"item_type"];
    _mediaType = json[@"media_type"];
    _service = [json[@"service"] objectForKey:@"short_name"];
    _title = json[@"title"];
    _itemDescription = json[@"description"];
    _url = json[@"url"];
    _urlIn = json[@"url_in"];
    _urlExt = json[@"url_ext"];
    _points = [json[@"point"] integerValue];
    _comments = [json[@"comments"] integerValue];
    _location = [Location fromJSON:json];
    _tags = json[@"tags"];
    _subs = json[@"subs"];
    _isRead = [json[@"is_read"] boolValue];
    _isGlued = [json[@"is_glued"] boolValue];
    _createdAt = [DateParser dateFromString:json[@"created_at"]];
    _updatedAt = [DateParser dateFromString:json[@"updated_at"]];

    if (json[@"media"] != nil) {
        _media = [Media fromJSON:json[@"media"]];
    }

    if (json[@"author_media"] != nil) {
        _authorMedia = [Media fromJSON:json[@"author_media"]];
    }

    return self;
}

- (NSString *)getSourceDescription
{
    return @"Some Source Description";
}


@end
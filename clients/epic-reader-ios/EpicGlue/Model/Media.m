//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Media.h"
#import "Image.h"
#import "Video.h"


@implementation Media

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];

    NSMutableArray *images = [NSMutableArray array];
    for (NSDictionary *image in json[@"images"]) {
        [images addObject:[Image fromJSON:image]];
    }
    _images = images;

    NSMutableArray *videos = [NSMutableArray array];
    for (NSDictionary *video in json[@"videos"]) {
        [videos addObject:[Video fromJSON:video]];
    }
    _videos = videos;

    return self;
}

- (NSInteger)numberOfImages
{
    return [self.images count];
}

- (NSInteger)numberOfVideos
{
    return [self.videos count];
}

- (Image *)largeImage
{
    for (Image *img in self.images) {
        if (img.sizeName == MediaSizeLarge) {
            return img;
        }
    }

    return [self mediumImage];
}

- (Image *)mediumImage
{
    for (Image *img in self.images) {
        if (img.sizeName == MediaSizeMedium) {
            return img;
        }
    }

    return [self smallImage];
}

- (Image *)smallImage
{
    for (Image *img in self.images) {
        if (img.sizeName == MediaSizeSmall) {
            return img;
        }
    }

    return nil;
}

- (Video *)largeVideo
{
    for (Video *vid in self.videos) {
        if (vid.sizeName == MediaSizeLarge) {
            return vid;
        }
    }

    return [self mediumVideo];
}

- (Video *)mediumVideo
{
    for (Video *vid in self.videos) {
        if (vid.sizeName == MediaSizeMedium) {
            return vid;
        }
    }

    return [self smallVideo];
}

- (Video *)smallVideo
{
    for (Video *vid in self.videos) {
        if (vid.sizeName == MediaSizeSmall) {
            return vid;
        }
    }

    return nil;
}

@end
//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"

@class Image;
@class Video;


@interface Media : Model

@property(nonatomic) NSArray *images;
@property(nonatomic) NSArray *videos;

- (NSInteger)numberOfImages;

- (NSInteger)numberOfVideos;

- (Image *)largeImage;

- (Image *)mediumImage;

- (Image *)smallImage;

- (Video *)largeVideo;

- (Video *)mediumVideo;

- (Video *)smallVideo;

@end
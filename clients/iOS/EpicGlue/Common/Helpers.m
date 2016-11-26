//
// Created by Marek Mikuliszyn on 03/02/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "Helpers.h"


@implementation Helpers

+ (MediaSize)mediaSizeByString:(NSString *)name
{
    if ([name isEqualToString:@"large"]) {
        return MediaSizeLarge;
    }

    if ([name isEqualToString:@"medium"]) {
        return MediaSizeMedium;
    }

    if ([name isEqualToString:@"small"]) {
        return MediaSizeSmall;
    }

    return MediaSizeUnknown;
}

@end
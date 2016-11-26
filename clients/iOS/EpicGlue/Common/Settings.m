//
// Created by Marek Mikuliszyn on 10/07/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Settings.h"
#import "ItemColors.h"
#import "UIColor+RGB.h"

@implementation Settings

+ (ItemColors *)colorForServiceName:(NSString *)name
{
    NSDictionary *colors;
    colors = @{
            Instagram: [UIColor fromIntegerRed:18 Green:86 Blue:136],
            HackerNews: [UIColor fromIntegerRed:255 Green:102 Blue:0],
            Twitter: [UIColor fromIntegerRed:29 Green:161 Blue:242],
            ProductHunt: [UIColor fromIntegerRed:255 Green:85 Blue:47],
            Kickstarter: [UIColor fromIntegerRed:43 Green:222 Blue:115],
            Reddit: [UIColor fromIntegerRed:255 Green:69 Blue:0],
            Facebook: [UIColor fromIntegerRed:59 Green:89 Blue:153],
            YouTube: [UIColor fromIntegerRed:230 Green:33 Blue:23],
            Tumblr: [UIColor fromIntegerRed:54 Green:70 Blue:93],
            RSS: [UIColor fromIntegerRed:255 Green:162 Blue:0]
    };

    UIColor *baseColor = [UIColor whiteColor];
    if (colors[name] != nil) {
        baseColor = colors[name];
    }

    ItemColors *itemColors = [[ItemColors alloc] init];
    itemColors.background = [baseColor colorWithAlphaComponent:0.1];
    itemColors.detailsBackground = [baseColor colorWithAlphaComponent:0.75];
    itemColors.buttonNormal = [baseColor colorWithAlphaComponent:1.0];
    itemColors.buttonActive = [baseColor colorWithAlphaComponent:1.0];

    return itemColors;
}

@end
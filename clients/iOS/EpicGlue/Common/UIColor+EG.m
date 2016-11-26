//
// Created by Marek Mikuliszyn on 21/05/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "UIColor+EG.h"
#import "UIColor+RGB.h"


@implementation UIColor (EG)


#pragma mark - Menu

+ (UIColor *)menuDarkFont
{
    return [UIColor fromIntegerRed:38 Green:38 Blue:38];
}

+ (UIColor *)menuLightFont
{
    return [UIColor fromIntegerRed:153 Green:153 Blue:153];
}

+ (UIColor *)showEverythingHeader
{
    return [UIColor fromIntegerRed:255 Green:229 Blue:127];
}

+ (UIColor *)subscribeHeader
{
    return [UIColor fromIntegerRed:2 Green:200 Blue:83];
}

+ (UIColor *)oddCell
{
    return [UIColor fromIntegerRed:91 Green:105 Blue:111];
}

+ (UIColor *)evenCell
{
    return [UIColor fromIntegerRed:74 Green:86 Blue:90];
}

+ (UIColor *)oddHeader
{
    return [UIColor fromIntegerRed:255 Green:255 Blue:255];
}

+ (UIColor *)evenHeader
{
    return [UIColor fromIntegerRed:230 Green:233 Blue:235];
}

+ (UIColor *)yellowHeader
{
    return [UIColor fromIntegerRed:255 Green:225 Blue:108];
}

@end
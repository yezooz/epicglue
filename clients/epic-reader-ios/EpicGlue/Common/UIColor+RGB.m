//
// Created by Marek Mikuliszyn on 13/03/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//

#import "UIColor+RGB.h"


@implementation UIColor (RGB)
+ (instancetype)fromIntegerRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue
{
    return [self fromIntegerRed:red Green:green Blue:blue Alpha:1.0];
}

+ (instancetype)fromIntegerRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue Alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(CGFloat) ((CGFloat) red / 255.0) green:(CGFloat) ((CGFloat) green / 255.0) blue:(CGFloat) ((CGFloat) blue / 255.0) alpha:alpha];
}

@end
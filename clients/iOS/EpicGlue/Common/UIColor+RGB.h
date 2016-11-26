//
// Created by Marek Mikuliszyn on 13/03/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//




@interface UIColor (RGB)
+ (instancetype)fromIntegerRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue;

+ (instancetype)fromIntegerRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue Alpha:(CGFloat)alpha;
@end
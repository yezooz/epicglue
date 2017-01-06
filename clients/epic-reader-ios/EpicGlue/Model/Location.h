//
// Created by Marek Mikuliszyn on 25/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import <CoreGraphics/CoreGraphics.h>
#import "Model.h"


@interface Location : Model

@property(readonly) CGFloat lat;
@property(readonly) CGFloat lon;
@property(readonly) NSString *name;

@end
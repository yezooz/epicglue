//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import <CoreGraphics/CoreGraphics.h>
#import "Model.h"


@interface Video : Model

@property(readonly) MediaSize sizeName;
@property(readonly) NSString *URL;
@property(readonly) NSInteger width;
@property(readonly) NSInteger height;

- (CGFloat)ratio;

@end
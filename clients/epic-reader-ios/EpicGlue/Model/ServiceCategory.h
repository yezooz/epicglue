//
// Created by Marek Mikuliszyn on 02/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Model.h"


@interface ServiceCategory : Model

@property(readonly) NSInteger categoryId;
@property(readonly) NSString *name;
@property(readonly) NSString *icon;

@end
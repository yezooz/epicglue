//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Request.h"


@interface UnsubscribeRequest : NSObject <Request>

@property(nonatomic, copy) NSNumber *userSubId;

@end
//
// Created by Marek Mikuliszyn on 10/09/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Request.h"

@interface SubscribeRequest : NSObject <Request>

@property(nonatomic) NSInteger sourceId;
@property(nonatomic) NSInteger profileId;
@property(nonatomic) NSString *value;

@end
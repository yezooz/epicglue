//
// Created by Marek Mikuliszyn on 04/11/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Request.h"


@interface RegisterByDeviceIdRequest : NSObject <Request>

@property(nonatomic, copy) NSString *deviceId;

@end
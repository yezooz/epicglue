//
// Created by Marek Mikuliszyn on 04/11/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Response.h"


@interface RegisterByDeviceIdResponse : NSObject <Response>

@property(readonly) NSString *token;

@end
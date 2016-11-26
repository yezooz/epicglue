// App settings
//
// Created by Marek Mikuliszyn on 10/07/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



#import "CocoaLumberjack.h"

@class UIColor;
@class ItemColors;

static const DDLogLevel ddLogLevel =
#ifdef DEBUG
        DDLogLevelAll;
#else
DDLogLevelError;
#endif

@interface Settings : NSObject

+ (ItemColors *)colorForServiceName:(NSString *)name;

@end
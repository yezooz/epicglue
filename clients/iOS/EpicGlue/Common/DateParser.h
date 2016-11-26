// Converting "2013-04-18T08:49:58.157+0000" to NSDate
//
// Created by Marek Mikuliszyn on 19/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//




@interface DateParser : NSObject

+ (NSDate *)dateFromString:(NSString *)string;

@end
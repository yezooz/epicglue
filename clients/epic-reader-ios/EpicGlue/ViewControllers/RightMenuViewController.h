//
//  RightMenuViewController.h
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "FHSTwitterEngine.h"

@class SubscriptionList;
@class RightMenuViewController;

@protocol RightViewControllerDelegate <NSObject>

@end

@interface RightMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FHSTwitterEngineAccessTokenDelegate>
@property(assign) BOOL selectedShowAll;
@property(nonatomic, copy) NSIndexPath *selected;

@property(unsafe_unretained) id <RightViewControllerDelegate> delegate;

@end

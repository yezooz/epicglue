//
//  ArrowPopViewController.h
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class ArrowPopViewControllerDelegate;

@protocol ArrowPopViewDelegate <NSObject>

- (void)clickedSelectedIndex:(NSInteger)index;

@end

@interface ArrowPopViewController : UITableViewController

@property(strong, nonatomic) NSArray *arrayData;
@property(unsafe_unretained) id <ArrowPopViewDelegate> delegate;
@property(assign, nonatomic) NSInteger selectedIndex;
@end

//
//  PopViewController.h
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class PopViewController;

@protocol PopViewControllerDelegate <NSObject>

- (void)popViewController;

@end

@interface PopViewController : UITableViewController

@property(strong, nonatomic) IBOutlet UITableView *tablePop;
@property(strong, nonatomic) NSString *popOverUrl;
@property(strong, nonatomic) UILabel *labelUrl;
@property(unsafe_unretained) id <PopViewControllerDelegate> delegate;
@property(strong, nonatomic) NSArray *tableData;
@end

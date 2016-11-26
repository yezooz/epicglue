//
//  RightMenuViewCell.h
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@interface RightMenuViewCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UILabel *labelArrowData;
@property(strong, nonatomic) IBOutlet UIImageView *uiImageView;

@property(strong, nonatomic) IBOutlet UILabel *labelName;
@property(strong, nonatomic) IBOutlet UILabel *labelCount;

@property(strong, nonatomic) IBOutlet UILabel *labelDescription;
@property(strong, nonatomic) IBOutlet UIImageView *imageIcon;
@property(strong, nonatomic) IBOutlet UIView *colorView;
@property(strong, nonatomic) IBOutlet UIView *cellBackgroundView;
@property(strong, nonatomic) IBOutlet UIView *colorViewOnDescription;

@end

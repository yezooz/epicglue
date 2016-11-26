//
//  CommonHeader.h
//  EpicGlue
//
//  Created by Marek Mikuliszyn on 12/03/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.



@protocol HeaderCommonTableViewDelegate <NSObject>

@end

@interface CommonHeader : UITableViewHeaderFooterView

@property(strong, nonatomic) IBOutlet UILabel *labelName;
@property(strong, nonatomic) IBOutlet UIImageView *icon;

@property(unsafe_unretained) id <HeaderCommonTableViewDelegate> delegate;

@end

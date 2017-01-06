//
//  ServiceHeader.h
//  EpicGlue
//
//  Created by Marek Mikuliszyn on 12/03/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//



@protocol HeaderServiceTableViewDelegate <NSObject>

@end

@interface ServiceHeader : UITableViewHeaderFooterView
@property(strong, nonatomic) IBOutlet UILabel *labelName;
@property(strong, nonatomic) IBOutlet UIView *innerHeaderView;
@property(strong, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property(strong, nonatomic) IBOutlet UIView *colorView;
@property(strong, nonatomic) IBOutlet UILabel *labelCount;

@property(unsafe_unretained) id <HeaderServiceTableViewDelegate> delegate;
@end

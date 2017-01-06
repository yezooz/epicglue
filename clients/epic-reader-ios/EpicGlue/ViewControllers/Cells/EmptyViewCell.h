//
//  EmptyViewCell.h
//  EpicGlue
//
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//



@class EmptyViewCell;

@protocol EmptyCellDelegate <NSObject>

- (void)clickedAddSubscription:(EmptyViewCell *)cell;

@end

@interface EmptyViewCell : UICollectionViewCell

@property(strong, nonatomic) IBOutlet UIButton *buttonAdd;
@property(unsafe_unretained) id <EmptyCellDelegate> delegate;

- (void)setViewLabels;
@end

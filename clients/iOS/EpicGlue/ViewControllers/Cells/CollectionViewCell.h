//
//  CollectionViewCell.h
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "Item.h"
#import "TTTAttributedLabel.h"

@class CollectionViewCell;

@protocol CollectionViewCellDelegate <NSObject>

- (void)clickedVideoPlay:(CollectionViewCell *)cell item:(Item *)item;

- (void)clickedURLLink:(NSURL *)url title:(NSString *)title;

- (void)clickedArrowDown:(CollectionViewCell *)cell;

- (void)clickedHashTagAndMention:(NSString *)tagString;

- (void)clickAuthor:(NSString *)name;

- (void)clickedServiceName:(NSString *)service;

- (void)clickedAtBottomMenu:(CollectionViewCell *)cell isOpen:(BOOL)isOpen;

- (void)actionForShareButton:(CollectionViewCell *)cell;

- (void)gluedCodeButtonAction:(CollectionViewCell *)cell;

- (void)collectionViewCell:(CollectionViewCell *)cell didExpand:(BOOL)expand;

@end

@interface CollectionViewCell : UICollectionViewCell
@property(strong, nonatomic) NSIndexPath *indexPath;
@property(strong, nonatomic) IBOutlet UIView *viewInternalContentView;
@property(strong, nonatomic) IBOutlet UIButton *buttonPlayVideo;
@property(strong, nonatomic) IBOutlet UIButton *buttonArrow;

@property(strong, nonatomic) IBOutlet UIButton *buttonAvatarName;
@property(strong, nonatomic) IBOutlet UIImageView *imageView;

@property(strong, nonatomic) IBOutlet UIButton *unGlueButtonImage;

@property(strong, nonatomic) IBOutlet UIImageView *blurImageView;


@property(strong, nonatomic) IBOutlet UIView *viewImageContentView;
@property(strong, nonatomic) IBOutlet TTTAttributedLabel *labelDescription;
@property(strong, nonatomic) IBOutlet TTTAttributedLabel *labelTitle;

@property(nonatomic, strong) Item *item;
@property(strong, nonatomic) IBOutlet UIImageView *likeImageView;
@property(strong, nonatomic) IBOutlet UIView *colorView;
@property(strong, nonatomic) IBOutlet UIButton *buttonGlueIt;
@property(strong, nonatomic) IBOutlet UILabel *labelTime;
@property(weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property(strong, nonatomic) IBOutlet UIView *bottomView;
@property(strong, nonatomic) IBOutlet UIView *bottomHideView;

@property(strong, nonatomic) IBOutlet UIView *linkView;
@property(strong, nonatomic) IBOutlet UIView *likeView;

@property(strong, nonatomic) IBOutlet UIView *commentView;


@property(strong, nonatomic) IBOutlet UIButton *buttonLink;
@property(strong, nonatomic) IBOutlet UIButton *buttonLike;
@property(strong, nonatomic) IBOutlet UIButton *buttonComment;


@property(strong, nonatomic) IBOutlet UIButton *buttonShare;
@property(strong, nonatomic) IBOutlet UIView *shareView;

@property(unsafe_unretained) id <CollectionViewCellDelegate> delegate;

- (void)expand:(BOOL)shouldExpand;

+ (CGSize)cellSizeWithItem:(Item *)item forCellWidth:(CGFloat)cellWidth isExpanded:(BOOL)isExpanded;

@end
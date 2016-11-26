//
//  ItemCollectionViewController.h
//  EpicGlue
//
//  Created by Marek on 14/03/2015.
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class ItemManager;

@interface ItemCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

- (BOOL)isViewInTransition;

- (void)viewIsInTransition;

- (void)viewIsNotInTransition;
@end

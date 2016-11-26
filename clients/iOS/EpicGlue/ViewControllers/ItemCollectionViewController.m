//
//  ItemCollectionViewController.m
//  EpicGlue
//
//  Created by Marek on 14/03/2015.
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "ItemCollectionViewController.h"
#import "ItemList.h"
#import "ItemManager.h"
#import "CollectionViewCell.h"
#import "Settings.h"
#import "WebViewController.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "AppDelegate.h"
#import "WYPopoverController.h"
#import "ArrowPopViewController.h"
#import "HUDNotification.h"
#import "Media.h"
#import "Image.h"
#import "Video.h"
#import "SubscriptionManager.h"
#import "CurrentSession.h"
#import "ItemHashList.h"
#import "ItemColors.h"
#import "UIImage+Color.h"
#import "NSDate+TimeAgo.h"
#import "EmptyViewCell.h"
#import "UIColor+RGB.h"
#import "PlanCollectionViewCell.h"
#import "UserManager.h"
#import "SubscriptionList.h"

@interface ItemCollectionViewController () <CollectionViewCellDelegate, UISplitViewControllerDelegate, WYPopoverControllerDelegate, ArrowPopViewDelegate, EmptyCellDelegate, RightViewControllerDelegate>
{
    AppDelegate *appDelegate;
    WYPopoverController *popOver;
    UISearchBar *searchBarNav;
    UIView *viewSearch;
    UIRefreshControl *refreshControl;
    Item *_item;
    CGRect rectButton;
    CGRect rectButtonPopUPIPad;
    BOOL isGlue, isTeeth, isFirstTimeShow;

    UIImageView *imageViewCrocodileTeeth, *imageViewGlued;

    NSMutableDictionary *dictExpanded;
}

@property(strong, nonatomic) IBOutlet UIBarButtonItem *buttonMagnifying;
@property(strong, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property(strong, nonatomic) IBOutlet UIButton *unreadButton;
@property(strong, nonatomic) IBOutlet UIButton *gluedButton;

@property(nonatomic) NSTimer *timer;
@property(nonatomic) BOOL viewInTransition;
@property(nonatomic) CGFloat lastContentOffset;

@end

@implementation ItemCollectionViewController

#pragma mark ItemListManager

- (void)viewDidLoad
{
    [super viewDidLoad];

    isFirstTimeShow = NO;

    dictExpanded = [NSMutableDictionary dictionary];

    //navigation bar item
    {
        {
            imageViewGlued = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glued"]];
            imageViewGlued.tintColor = [UIColor fromIntegerRed:5 Green:195 Blue:84];
            imageViewGlued.translatesAutoresizingMaskIntoConstraints = NO;
            [self.navigationController.navigationBar addSubview:imageViewGlued];

            int glueXPosition = 34;
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {glueXPosition = 42;}

            NSLayoutConstraint *constraintLeading = [NSLayoutConstraint constraintWithItem:imageViewGlued attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:glueXPosition];

            NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:imageViewGlued attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

//            if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) {
            [self.navigationController.navigationBar addConstraints:@[constraintLeading, constraintTop]];
//            }
        }

        {
            UIView *crocodileTeethContainerView = [[UIView alloc] init];
            crocodileTeethContainerView.translatesAutoresizingMaskIntoConstraints = NO;
            crocodileTeethContainerView.layer.masksToBounds = YES;
            [self.navigationController.navigationBar addSubview:crocodileTeethContainerView];

            UIImage *image = [[UIImage imageNamed:@"tooth"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
            imageViewCrocodileTeeth = [[UIImageView alloc] initWithImage:image];
            imageViewCrocodileTeeth.translatesAutoresizingMaskIntoConstraints = NO;

            imageViewCrocodileTeeth.tintColor = [UIColor redColor];

            [crocodileTeethContainerView addSubview:imageViewCrocodileTeeth];

            // CrocodileTeethContainerView
            {
                NSLayoutConstraint *constraintLeading = [NSLayoutConstraint constraintWithItem:crocodileTeethContainerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
                NSLayoutConstraint *constraintTrailing = [NSLayoutConstraint constraintWithItem:crocodileTeethContainerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
                NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:crocodileTeethContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:crocodileTeethContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10];

                [crocodileTeethContainerView addConstraint:constraintHeight];
//                if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) {
                [self.navigationController.navigationBar addConstraints:@[constraintLeading, constraintTrailing, constraintTop]];
//                }
            }

            // ImageViewCrocodileTeeth
            {
                NSLayoutConstraint *constraintLeading = [NSLayoutConstraint constraintWithItem:imageViewCrocodileTeeth attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:crocodileTeethContainerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-20];
                NSLayoutConstraint *constraintTrailing = [NSLayoutConstraint constraintWithItem:imageViewCrocodileTeeth attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:crocodileTeethContainerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:20];
                NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:imageViewCrocodileTeeth attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:crocodileTeethContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:imageViewCrocodileTeeth attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:crocodileTeethContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

                [crocodileTeethContainerView addConstraints:@[constraintLeading, constraintTrailing, constraintTop, constraintBottom]];
            }
        }

        // Initial selection
        {
            if ([CurrentSession instance].selectedTopBarOption == SelectedTabUnread) {
                imageViewGlued.hidden = YES;
                imageViewCrocodileTeeth.hidden = NO;

                isGlue = NO;
                isTeeth = YES;
                [self.gluedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.unreadButton setTitleColor:[UIColor fromIntegerRed:255 Green:229 Blue:127] forState:UIControlStateNormal];
                self.unreadButton.userInteractionEnabled = NO;
                self.gluedButton.userInteractionEnabled = YES;

                [ItemManager instance].selectedTab = SelectedTabUnread;

                [self refresh];
            } else {
                imageViewGlued.hidden = NO;
                imageViewCrocodileTeeth.hidden = YES;

                isGlue = YES;
                isTeeth = NO;

                [self.unreadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.gluedButton setTitleColor:[UIColor fromIntegerRed:255 Green:229 Blue:127] forState:UIControlStateNormal];
                self.unreadButton.userInteractionEnabled = YES;
                self.gluedButton.userInteractionEnabled = NO;

                [ItemManager instance].selectedTab = SelectedTabGlued;

                [self refresh];
            }
        }
    }

    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    // SearchBar..
    {
        viewSearch = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height + 20)];
        viewSearch.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        viewSearch.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

        searchBarNav = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 20, viewSearch.frame.size.width - 10, 44)];
        searchBarNav.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [searchBarNav setPlaceholder:@"Enter text here"];
        searchBarNav.barTintColor = viewSearch.backgroundColor;
        searchBarNav.layer.borderColor = viewSearch.backgroundColor.CGColor;
        searchBarNav.layer.borderWidth = 1;
        // TODO: use helper
        [searchBarNav setTintColor:[UIColor colorWithRed:0.216 green:0.506 blue:0.690 alpha:1.000]];
        searchBarNav.delegate = self;
        [viewSearch addSubview:searchBarNav];

        viewSearch.hidden = YES;
        [self.navigationController.navigationBar addSubview:viewSearch];
    }

    {
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }

    // Refresh Control
    {
        refreshControl = [[UIRefreshControl alloc] init];
        [self.collectionView addSubview:refreshControl];
        [refreshControl addTarget:self action:@selector(loadLatest) forControlEvents:UIControlEventValueChanged];
    }

    // Cells
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EmptyViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([EmptyViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PlanCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PlanCollectionViewCell class])];

    [self setNotifications];

    [self onTimer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:15
                                                  target:self
                                                selector:@selector(onTimer)
                                                userInfo:nil
                                                 repeats:YES
    ];

    rectButtonPopUPIPad = CGRectMake(445, 100, 10, 10);
    [popOver presentPopoverFromRect:rectButtonPopUPIPad
                             inView:self.view
           permittedArrowDirections:WYPopoverArrowDirectionNone
                           animated:YES
                            options:WYPopoverAnimationOptionFadeWithScale];
}

// new code of show crocodileTeeth and show image
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        appDelegate.slidingController.anchorLeftRevealAmount = appDelegate.slidingController.view.frame.size.width - (appDelegate.slidingController.view.frame.size.width / 4);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // For Orientation.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            // portrait
            self.splitViewController.preferredPrimaryColumnWidthFraction = 0.65;
            self.splitViewController.maximumPrimaryColumnWidth = self.splitViewController.view.frame.size.width;
        } else {
            //  landscape
            self.splitViewController.preferredPrimaryColumnWidthFraction = 0.74;
            self.splitViewController.maximumPrimaryColumnWidth = self.splitViewController.view.frame.size.width;
        }
        self.navigationItem.rightBarButtonItem = nil;
    }

    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    DDLogDebug(@"viewDidAppear");

    [self viewIsNotInTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    DDLogDebug(@"viewWillDisappear");

    [self viewIsInTransition];
}

- (void)onTimer
{
    if (![[UserManager instance] isLoggedIn]) {
        return;
    }

    if ([[[SubscriptionManager instance].usersList list] count] == 0) {
        return;
    }

    [self syncReadItems];

    [[SubscriptionManager instance] fetchCounters];
}

- (void)clickedSelectedIndex:(NSInteger)index
{

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollToTop
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)refresh
{
    if (![[UserManager instance] isLoggedIn]) {
        return;
    }

    if ([[[SubscriptionManager instance].usersList list] count] == 0) {
        return;
    }

    [[ItemManager instance] load];
}

- (void)loadLatest
{
    [refreshControl beginRefreshing];

    [[ItemManager instance] loadEarlier];
}

- (void)syncReadItems
{
    [[ItemManager instance] syncReadItems];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX([[[ItemManager instance] currentItemList] count], 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20.0, 0.0, self.view.frame.size.height, 0.0);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[ItemManager instance] currentItemList] count] == 0) {
        EmptyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EmptyViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.buttonAdd.tag = indexPath.item;
        [cell setViewLabels];
        return cell;
    }

    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];

    cell.item = [[ItemManager instance].currentItemList getItemAtIndex:indexPath.item];
    cell.delegate = self;
    cell.tag = indexPath.item;
    cell.buttonPlayVideo.tag = indexPath.item;
    cell.buttonArrow.tag = indexPath.item;
    cell.buttonAvatarName.tag = indexPath.item;
    cell.indexPath = indexPath;

    ItemColors *color = [Settings colorForServiceName:cell.item.service];
    cell.viewInternalContentView.backgroundColor = color.background;
    cell.colorView.backgroundColor = color.buttonNormal;
    cell.linkView.backgroundColor = color.buttonNormal;
    cell.shareView.backgroundColor = color.buttonNormal;

    [cell.buttonGlueIt setBackgroundImage:[UIImage cl_imageWithColor:color.buttonNormal] forState:UIControlStateNormal];
    [cell.buttonGlueIt setBackgroundImage:[UIImage cl_imageWithColor:color.buttonActive] forState:UIControlStateSelected];

    if (isTeeth) {
        [cell.buttonGlueIt setTitle:NSLocalizedString(@"GLUE IT", nil) forState:UIControlStateNormal];
        cell.unGlueButtonImage.hidden = YES;

        cell.blurImageView.image = nil;
        if (isFirstTimeShow) {
            if (cell.item.isRead && !cell.item.isGlued) {
                cell.blurImageView.image = [UIImage imageNamed:@"blurImage.png"];
                cell.blurImageView.clipsToBounds = YES;
            }
        }
    } else if (isGlue) {
        cell.unGlueButtonImage.hidden = NO;
        [cell.buttonGlueIt setTitle:NSLocalizedString(@"UNGLUE", nil) forState:UIControlStateNormal];
        [cell.unGlueButtonImage setTintColor:color.buttonNormal];

        cell.blurImageView.image = nil;
    }

    [cell.buttonLike setBackgroundImage:[UIImage cl_imageWithColor:color.buttonNormal] forState:UIControlStateNormal];
    [cell.buttonLike setBackgroundImage:[UIImage cl_imageWithColor:color.buttonActive] forState:UIControlStateSelected];

    [cell.buttonLink setBackgroundImage:[UIImage cl_imageWithColor:color.buttonNormal] forState:UIControlStateNormal];
    [cell.buttonLink setBackgroundImage:[UIImage cl_imageWithColor:color.buttonActive]
                               forState:UIControlStateSelected];

    [cell.buttonComment setBackgroundImage:[UIImage cl_imageWithColor:color.buttonNormal] forState:UIControlStateNormal];
    [cell.buttonComment setBackgroundImage:[UIImage cl_imageWithColor:color.buttonActive] forState:UIControlStateSelected];


    [cell.buttonArrow setBackgroundImage:[UIImage cl_imageWithColor:color.buttonNormal] forState:UIControlStateNormal];
    [cell.buttonArrow setBackgroundImage:[UIImage cl_imageWithColor:color.buttonActive] forState:UIControlStateSelected];

    cell.bottomHideView.backgroundColor = color.background;

    [cell expand:[dictExpanded[cell.item.itemId] boolValue]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load more if less then X items left
        // TODO: Fix bug first that is causing view to constantly reload itself
//        if ([[ItemManager instance].currentItemList count] - LoadMoreWhenLessThan == (int) indexPath.row) {
//            [[ItemManager instance] loadLater];
//        }

        if (self.lastContentOffset > self.collectionView.contentOffset.y) {
            return;
        }

        // Shredding
        if ([self isViewInTransition]) {
            return;
        }

        Item *item = [[ItemManager instance].currentItemList getItemAtIndex:(int) indexPath.row];

        [[ItemManager instance] addReadItem:item];
    });

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

#pragma mark Set pre read

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isTeeth) {
        if ([[[ItemManager instance] currentItemList] count] > 0) {
            isFirstTimeShow = YES;
        }
    }
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [[ItemManager instance].currentItemList getItemAtIndex:indexPath.item];

    CGFloat cellWidth = self.view.frame.size.width - 20;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        cellWidth = self.view.frame.size.width - 40;
    } else {
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            cellWidth = self.view.frame.size.width - 40;
        } else {
            cellWidth = self.view.frame.size.width - 20;
        }
    }

    BOOL isExpand = [dictExpanded[item.itemId] boolValue];
    CGSize itemCellSize;
    if ([[[ItemManager instance] currentItemList] count] > 0) {
        // Getting ImageView Height
        CGFloat imageContentRatio;

        if ([item.media numberOfVideos] > 0) {
            Image *img = [item.media largeImage];
            imageContentRatio = img.ratio;

        } else if ([item.media numberOfImages] > 0) {
            Image *img = [item.media largeImage];
            imageContentRatio = img.ratio;
        } else {
            imageContentRatio = 0;
        }

        {
            /************************************/
            CGFloat buttonGlueItTop = 15;       // Button Glue It Top Constraint
            CGFloat buttonGlueItHeight = 40;    // Button Glue It Height Constraint

            /************************************/
            CGFloat imageContentViewTop = 15;   // imageContentView Top Constraint
            CGFloat imageHeight = imageContentRatio * cellWidth;

            /************************************/
            CGFloat titleLabelTop = 0;          // TitleLabel Top Constraint

            // Title Height...
            CGFloat titleHeight = 0;

            NSMutableAttributedString *titleAttributedString = nil;

            if (![item.title isEqual:[NSNull null]]) {
                UIFont *font = [UIFont fontWithName:@"AvenirNext-Bold" size:24];

                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.alignment = NSTextAlignmentLeft;
                paragraphStyle.lineSpacing = 0;
                paragraphStyle.minimumLineHeight = font.lineHeight;
                paragraphStyle.maximumLineHeight = font.lineHeight;
                paragraphStyle.lineHeightMultiple = 1;
                paragraphStyle.firstLineHeadIndent = 0;
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                // adding by me
                paragraphStyle.paragraphSpacingBefore = 0;
                paragraphStyle.headIndent = 0;
                paragraphStyle.tailIndent = 0;
                paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
                paragraphStyle.hyphenationFactor = 0;
                paragraphStyle.defaultTabInterval = 0;

                titleAttributedString = [[NSMutableAttributedString alloc] initWithString:item.title attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName: @(0)}];


                CGSize requireTitleHeight = [TTTAttributedLabel sizeThatFitsAttributedString:titleAttributedString withConstraints:CGSizeMake(cellWidth - 20, CGFLOAT_MAX) limitedToNumberOfLines:0];
                titleHeight = requireTitleHeight.height;

                // For LabelTitle
                NSMutableDictionary *linkAttributedTitle = [NSMutableDictionary dictionary];
                linkAttributedTitle[(NSString *) kCTForegroundColorAttributeName] = [UIColor fromIntegerRed:0 Green:122 Blue:255];
                linkAttributedTitle[(NSString *) kCTUnderlineStyleAttributeName] = @YES;

                linkAttributedTitle[(NSString *) kCTFontAttributeName] = [UIFont boldSystemFontOfSize:15];
                NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                NSArray *results = [linkDetector matchesInString:item.title options:0 range:NSMakeRange(0, [item.title length])];

                for (NSTextCheckingResult *result in results) {

                    if ([result resultType] == NSTextCheckingTypeLink) {
                        [titleAttributedString setAttributes:linkAttributedTitle range:result.range];
                    }
                }

                NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)|#(\\w+)" options:NO error:nil];
                NSArray *matches = [mentionExpression matchesInString:item.title options:0 range:NSMakeRange(0, [item.title length])];

                for (NSTextCheckingResult *result in matches) {
                    NSArray *keys = @[(id) kCTForegroundColorAttributeName, (id) kCTUnderlineStyleAttributeName];
                    NSArray *objects = @[[UIColor redColor], @(kCTUnderlineStyleNone)];
                    NSDictionary *linkAttributes = @{keys: objects};
                    [titleAttributedString setAttributes:linkAttributes range:result.range];
                }


                if ([item.title length]) {
                    titleLabelTop = 5;
                }
            }

            /************************************/
            CGFloat timeLabelTop = 5;           // TimeLabel Bottom Constraint

            NSString *timeString = [NSString stringWithFormat:@"POSTED %@ BY %@", [item.createdAt dateTimeAgo], [item author]];

            CGFloat timeHeight = [timeString boundingRectWithSize:CGSizeMake(cellWidth - 20, CGFLOAT_MAX) options:0 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:12]} context:NULL].size.height;
            /************************************/
            CGFloat descriptionLabelTop = 0;        // descriptionLabelTop Top  Constraint

            // Description height...
            CGFloat descriptionHeight = 0;

            NSMutableAttributedString *descAttributedString = nil;

            if (![item.itemDescription isEqual:[NSNull null]]) {
                UIFont *font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];

                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.alignment = NSTextAlignmentLeft;
                paragraphStyle.lineSpacing = 0;
                paragraphStyle.minimumLineHeight = font.lineHeight;
                paragraphStyle.maximumLineHeight = font.lineHeight;
                paragraphStyle.lineHeightMultiple = 1;
                paragraphStyle.firstLineHeadIndent = 0;
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                // adding by me
                paragraphStyle.paragraphSpacingBefore = 0;
                paragraphStyle.headIndent = 0;
                paragraphStyle.tailIndent = 0;
                paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
                paragraphStyle.hyphenationFactor = 0;
                paragraphStyle.defaultTabInterval = 0;

                descAttributedString = [[NSMutableAttributedString alloc] initWithString:item.itemDescription attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName: @(0)}];

                CGSize requiredDescHeight = [TTTAttributedLabel sizeThatFitsAttributedString:descAttributedString withConstraints:CGSizeMake(cellWidth - 20, CGFLOAT_MAX) limitedToNumberOfLines:0];
                descriptionHeight = requiredDescHeight.height;

                {
                    // For Description link
                    NSMutableDictionary *linkAttributedDesc = [NSMutableDictionary dictionary];
                    // TODO: use helper
                    linkAttributedDesc[(NSString *) kCTForegroundColorAttributeName] = [UIColor fromIntegerRed:0 Green:122 Blue:255];
                    linkAttributedDesc[(NSString *) kCTUnderlineStyleAttributeName] = @YES;
                    linkAttributedDesc[(NSString *) kCTFontAttributeName] = [UIFont boldSystemFontOfSize:12];

                    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                    NSArray *results = [linkDetector matchesInString:item.itemDescription options:0 range:NSMakeRange(0, [item.itemDescription length])];

                    for (NSTextCheckingResult *result in results) {

                        if ([result resultType] == NSTextCheckingTypeLink) {
                            [descAttributedString setAttributes:linkAttributedDesc range:result.range];
                        }
                    }
                }

                if ([item.itemDescription length]) {
                    descriptionLabelTop = 5;
                }
            }

            /************************************/
            CGFloat expandViewTop = 10; // expandViewButton Top  Constraint

            CGFloat expandView = 0;
            if (isExpand) {
                expandView = 80;
            }

            CGFloat expandViewButtonHeight = 30; // ExpandArrow Button Height Constraint

            CGFloat height = buttonGlueItTop + buttonGlueItHeight + imageContentViewTop + imageHeight + titleLabelTop + titleHeight + timeLabelTop + timeHeight + descriptionLabelTop + descriptionHeight + expandViewTop + expandView + expandViewButtonHeight;

            itemCellSize = CGSizeMake(cellWidth, height);
        }
    } else {
        itemCellSize = CGSizeMake(cellWidth, 340);
    }

    return itemCellSize;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            self.splitViewController.preferredPrimaryColumnWidthFraction = 0.74;
            self.splitViewController.maximumPrimaryColumnWidth = self.splitViewController.view.frame.size.width;
        } else {
            self.splitViewController.preferredPrimaryColumnWidthFraction = 0.65;
            self.splitViewController.maximumPrimaryColumnWidth = self.splitViewController.view.frame.size.width;
        }
    }
    [self.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView reloadData];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
            // portrait
            rectButtonPopUPIPad = CGRectMake(445, 100, 10, 10);
        } else {
            // landscape
            rectButtonPopUPIPad = CGRectMake(700, 100, 10, 10);
        }
    }
}

#pragma mark - CollectionViewDelegate Method

- (void)clickedVideoPlay:(CollectionViewCell *)cell item:(Item *)item
{
    Video *vid = [item.media largeVideo];

    NSURL *urlVideo = [NSURL URLWithString:vid.URL];

    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    NSArray *viewController = navController.viewControllers;

    WebViewController *webController = [viewController firstObject];
    webController.webUrl = urlVideo;

    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)clickedURLLink:(NSURL *)url title:(NSString *)title
{
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    NSArray *viewController = navController.viewControllers;

    WebViewController *webController = [viewController firstObject];
    webController.webUrl = url;
    webController.strTitle = title;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)clickedHashTagAndMention:(NSString *)tagString
{
//    [self setShowSearchBar];
//    searchBarNav.text = tagString;
}

- (void)clickAuthor:(NSString *)name
{
    [self setShowSearchBar];
    searchBarNav.text = name;
}

- (void)clickedServiceName:(NSString *)service
{
    [self setShowSearchBar];
    searchBarNav.text = service;
}

- (void)clickedArrowDown:(CollectionViewCell *)cell
{
    _item = cell.item;

    ArrowPopViewController *arrowPopView = [[self storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ArrowPopViewController class])];
    arrowPopView.delegate = self;

    arrowPopView.preferredContentSize = CGSizeMake(250, 115);
    WYPopoverTheme *theme = [WYPopoverTheme theme];
    [theme setArrowHeight:10];
    [theme setArrowBase:20];
    [theme setFillTopColor:[UIColor whiteColor]];
    [theme setFillBottomColor:[UIColor whiteColor]];
    [theme setOverlayColor:[UIColor colorWithWhite:0 alpha:0.5]];

    popOver = [[WYPopoverController alloc] initWithContentViewController:arrowPopView];
    popOver.delegate = self;
    popOver.theme = theme;
    popOver.popoverLayoutMargins = UIEdgeInsetsMake(5, 5, 5, 5);
    popOver.wantsDefaultContentAppearance = NO;

    rectButton = [cell convertRect:cell.buttonArrow.frame toView:self.view];
    [popOver presentPopoverFromRect:rectButton
                             inView:self.view
           permittedArrowDirections:WYPopoverArrowDirectionUp | WYPopoverArrowDirectionDown
                           animated:YES
                            options:WYPopoverAnimationOptionFadeWithScale];
}

- (void)clickedAtBottomMenu:(CollectionViewCell *)cell isOpen:(BOOL)isOpen
{
    [self.collectionViewLayout invalidateLayout];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastContentOffset < scrollView.contentOffset.y) {
        self.lastContentOffset = scrollView.contentOffset.y;
    }
}

#pragma mark new code for glue it action

- (void)gluedCodeButtonAction:(CollectionViewCell *)cell
{
    if ([ItemManager instance].selectedTab == SelectedTabGlued) {
        [[ItemManager instance] unglueItem:cell.item onComplete:^(APIError *error) {
            if (error != nil) {
                return;
            }

            NSUInteger i = [[ItemManager instance].currentItemList findIndex:cell.item];

            [[ItemManager instance].currentItemList removeItemAtIndex:i];

            if ([[ItemManager instance].currentItemList count] > 0) {
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
            } else {
                [self.collectionView reloadData];
            }
        }];
    } else {
        [[ItemManager instance] addReadItem:cell.item];
        [[ItemManager instance] glueItem:cell.item onComplete:^(APIError *error) {
            if (error != nil) {
                return;
            }

            NSUInteger i = [[ItemManager instance].currentItemList findIndex:cell.item];

            [[ItemManager instance].currentItemList removeItemAtIndex:i];

            if ([[ItemManager instance].currentItemList count] > 0) {
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
            } else {
                [self.collectionView reloadData];
            }
        }];
    }
}

#pragma mark - ShareButton Action

- (void)actionForShareButton:(CollectionViewCell *)cell
{

    NSArray *activityItems = @[cell.item.url];
    NSArray *excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = excludeActivities;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    } else {
        UIPopoverController *popUp = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popUp presentPopoverFromRect:rectButton inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - EmptyCell Actions

- (void)clickedAddSubscription:(EmptyViewCell *)cell
{
    [self menuButton:nil];

    // TODO: measure action
}

#pragma mark - Notifications

- (void)setNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ENItems
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogDebug(@"%@", notification.name);

                                                      [self viewIsInTransition];

                                                      ItemList *itemList = [notification object];
                                                      [[ItemManager instance] setCurrentItemList:itemList];

                                                      [refreshControl endRefreshing];

                                                      [self.collectionView reloadData];

                                                      if ([itemList count] > 0) {
                                                          [self scrollToTop];
                                                      }

                                                      self.lastContentOffset = 0;
                                                      [self viewIsNotInTransition];

                                                      [[HUDNotification instance] hide];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ENNewerItems
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogDebug(@"%@", notification.name);

                                                      // Check object type and send errors if connection failed
                                                      ItemList *itemList = [notification object];
                                                      [[ItemManager instance].currentItemList prependItems:itemList];

                                                      [refreshControl endRefreshing];

                                                      [self.collectionView reloadData];

                                                      [[HUDNotification instance] hide];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ENOlderItems
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogDebug(@"%@", notification.name);

                                                      ItemList *itemList = [notification object];
                                                      [[ItemManager instance].currentItemList appendItems:itemList];

                                                      [refreshControl endRefreshing];

                                                      [self.collectionView reloadData];

                                                      [[HUDNotification instance] hide];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncReadItems)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncReadItems)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];

//    [[NSNotificationCenter defaultCenter]
//            addObserverForName:UIApplicationWillEnterForegroundNotification
//                        object:nil
//                         queue:nil
//                    usingBlock:^(NSNotification *notification) {
//                        DDLogVerbose(@"%@", notification.name);
//
//                        [self viewIsNotInTransition];
//                    }];

    [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification) {
                        DDLogDebug(@"%@", notification.name);

                        [self viewIsInTransition];

                        if ([[[ItemManager instance] currentItemList] count] > 0) {
                            [self refresh];
                            [self scrollToTop];
//                            [self.collectionView reloadData];
                        }

                        [self viewIsNotInTransition];
                    }];

    [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidEnterBackgroundNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification) {
                        DDLogDebug(@"%@", notification.name);

                        [self viewIsInTransition];
                    }];

    [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationWillResignActiveNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification) {
                        DDLogDebug(@"%@", notification.name);

                        [self viewIsInTransition];

                        [[CurrentSession instance] setReadItemIds:[[[ItemManager instance] readItems] getList]];

                        [self syncReadItems];
                        [self.collectionView reloadData];
                    }];
}

#pragma mark - Menu Button Actions

- (IBAction)menuButton:(UIBarButtonItem *)sender
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    } else {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

#pragma mark - Actions

- (IBAction)unReadButtonAction:(UIButton *)sender
{
    imageViewGlued.hidden = YES;
    imageViewCrocodileTeeth.hidden = NO;
    isGlue = NO;
    isTeeth = YES;
    [self.gluedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.unreadButton setTitleColor:[UIColor fromIntegerRed:255 Green:229 Blue:127] forState:UIControlStateNormal];
    self.unreadButton.userInteractionEnabled = NO;
    self.gluedButton.userInteractionEnabled = YES;

    // TODO: Use CurrentSession in both instances? Unify!
    [CurrentSession instance].selectedTopBarOption = SelectedTabUnread;
    [self hideSearchBar];
    [ItemManager instance].selectedTab = SelectedTabUnread;
    [self refresh];
    [self scrollToTop];
}

- (IBAction)gluedButtonAction:(UIButton *)sender
{
    imageViewGlued.hidden = NO;
    imageViewCrocodileTeeth.hidden = YES;
    isGlue = YES;
    isTeeth = NO;

    [self.unreadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.gluedButton setTitleColor:[UIColor fromIntegerRed:255 Green:229 Blue:127] forState:UIControlStateNormal];
    self.unreadButton.userInteractionEnabled = YES;
    self.gluedButton.userInteractionEnabled = NO;

    // TODO: Use CurrentSession in both instances? Unify!
    [CurrentSession instance].selectedTopBarOption = SelectedTabGlued;
    [self hideSearchBar];
    [ItemManager instance].selectedTab = SelectedTabGlued;
    [self refresh];
    [self scrollToTop];
}

- (IBAction)markAllAsRead:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Confirmation", nil) message:NSLocalizedString(@"Mark all as read", nil) preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[ItemManager instance] readAll];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        DDLogDebug(@"Cancel");
    }];

    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setShowSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        viewSearch.hidden = NO;
        _buttonMenu.enabled = NO;
        [searchBarNav becomeFirstResponder];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)hideSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        viewSearch.hidden = YES;
        _buttonMagnifying.enabled = YES;
        _buttonMenu.enabled = YES;

    }];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navigationItem.leftBarButtonItem = _buttonMagnifying;
    } else {
        self.navigationItem.rightBarButtonItem = _buttonMenu;
        self.navigationItem.leftBarButtonItem = _buttonMagnifying;
    }
}

#pragma mark - SearchBarDelegate Method

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Any data CONTAINS[c] %@", searchText];
    //DDLogInfo(@"STRING - %@", predicate);

    [self.collectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hideSearchBar];
    [searchBar resignFirstResponder];
}

- (void)collectionViewCell:(CollectionViewCell *)cell
                 didExpand:(BOOL)expand
{
    dictExpanded[cell.item.itemId] = @(expand);

    [self.collectionView performBatchUpdates:^{
                [self.collectionView.collectionViewLayout invalidateLayout];
            }
                                  completion:^(BOOL finished) {

                                  }];

    [UIView animateWithDuration:0.3 animations:^{
        [cell expand:expand];
        [cell.viewInternalContentView setNeedsLayout];
        [cell.viewInternalContentView layoutIfNeeded];
    }];
}

#pragma mark ViewInTransition

- (BOOL)isViewInTransition
{
    return self.viewInTransition;
}

- (void)viewIsInTransition
{
    self.viewInTransition = YES;
}

- (void)viewIsNotInTransition
{
    self.viewInTransition = NO;
}

@end
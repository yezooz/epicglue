//
//  CollectionViewCell.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "CollectionViewCell.h"
#import "NSDate+TimeAgo.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "UIImageView+XLProgressIndicator.h"
#import "Settings.h"
#import "Media.h"
#import "Image.h"
#import "ItemColors.h"
#import "UIColor+EG.h"


@interface CollectionViewCell () <TTTAttributedLabelDelegate, UIActionSheetDelegate, MHFacebookImageViewerDatasource, UIGestureRecognizerDelegate>

@property(strong, nonatomic) IBOutlet UILabel *labelComment;
@property(strong, nonatomic) IBOutlet UILabel *labelLike;
@property(strong, nonatomic) IBOutlet UIButton *buttonRetry;

@end

@implementation CollectionViewCell
{
    IBOutlet NSLayoutConstraint *constraintAspectRatio;
    NSLayoutConstraint *constraintImageContainerZeroHeight;

    IBOutlet NSLayoutConstraint *constraintHeightBottomView;

    IBOutlet NSLayoutConstraint *constraintTitleTop;
    IBOutlet NSLayoutConstraint *constraintDescriptionTop;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    constraintImageContainerZeroHeight = [NSLayoutConstraint constraintWithItem:self.viewImageContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];

    self.viewInternalContentView.layer.cornerRadius = 10.0;
    self.blurImageView.clipsToBounds = YES;

    self.labelDescription.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.labelDescription.delegate = self;
    if (self.item != nil) {
        self.labelDescription.linkAttributes = [[self class] linkAttributedDescription:self.item];
    }

    self.labelTitle.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.labelTitle.delegate = self;
    if (self.item != nil) {
        self.labelTitle.linkAttributes = [[self class] linkAttributedTitle:self.item];
    }

    self.linkView.layer.cornerRadius = self.linkView.frame.size.height / 2;
    self.linkView.clipsToBounds = YES;

    self.likeView.layer.cornerRadius = self.likeView.frame.size.height / 2;
    self.likeView.layer.masksToBounds = YES;
    self.likeImageView.tintColor = [UIColor whiteColor];

    self.commentView.layer.cornerRadius = self.commentView.frame.size.height / 2;
    self.commentView.layer.masksToBounds = YES;

    self.buttonComment.layer.cornerRadius = self.buttonComment.frame.size.height / 2;
    self.buttonComment.clipsToBounds = YES;

    self.shareView.layer.cornerRadius = self.shareView.frame.size.height / 2;
    self.shareView.clipsToBounds = YES;

    self.colorView.layer.cornerRadius = self.colorView.frame.size.height / 2;

    self.buttonGlueIt.layer.cornerRadius = self.buttonGlueIt.frame.size.height / 2;
    self.buttonGlueIt.layer.masksToBounds = YES;

    UITapGestureRecognizer *linkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLinkAction:)];
    [self.linkView addGestureRecognizer:linkTap];

    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonShareAction:)];
    [self.shareView addGestureRecognizer:shareTap];
}

- (void)setItem:(Item *)item
{
    _item = item;

    [self.labelComment setText:[NSString stringWithFormat:@"(%ld)", (long) item.comments]];
    [self.labelLike setText:[NSString stringWithFormat:@"(%ld)", (long) item.points]];

    if (![item.title isEqual:[NSNull null]]) {
        [self.labelTitle setText:item.title];
    } else {
        [self.labelTitle setText:@""];
    }

    if (![item.itemDescription isEqual:[NSNull null]]) {
        [self.labelDescription setText:item.itemDescription];
    } else {
        [self.labelDescription setText:@""];
    }

    [self.buttonAvatarName setTitle:item.author forState:UIControlStateNormal];
    self.labelTime.text = [CollectionViewCell timeString:item];

    if (![item.title isEqual:[NSNull null]]) {
        NSError *error = nil;

        NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)|#(\\w+)" options:NO error:&error];
        NSArray *matches = [mentionExpression matchesInString:item.title options:0 range:NSMakeRange(0, [item.title length])];

        for (NSTextCheckingResult *match in matches) {
            NSArray *keys = @[(id) kCTForegroundColorAttributeName, (id) kCTUnderlineStyleAttributeName];
            NSArray *objects = @[[UIColor redColor], @(kCTUnderlineStyleNone)];
            NSDictionary *linkAttributes = @{keys: objects};
            [self.labelTitle addLinkWithTextCheckingResult:match attributes:linkAttributes];
        }
    }

    __weak typeof(self) weakSelf = self;

    // for Image URL and Video URL
    if ([item.media numberOfVideos] > 0) {
        Image *img = [item.media largeImage];
        NSURL *urlImage = [NSURL URLWithString:img.URL];

        // XlImageView
        [self.imageView setImageWithProgressIndicatorAndURL:urlImage];

        self.buttonRetry.hidden = YES;

        [self.imageView setImageWithProgressIndicatorAndURL:urlImage
                                                    success:^(UIImage *image) {
                                                        weakSelf.buttonPlayVideo.hidden = NO;
                                                    }
                                                    failure:^(NSError *error) {
                                                        DDLogError(@"Fail: %@\nError: %@", urlImage, error);

                                                        weakSelf.buttonRetry.hidden = NO;
                                                        weakSelf.buttonPlayVideo.hidden = YES;
                                                    }];

        [self.viewImageContentView removeConstraint:constraintAspectRatio];
        [self.imageView setUserInteractionEnabled:NO];

        constraintAspectRatio = [NSLayoutConstraint constraintWithItem:self.viewImageContentView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.viewImageContentView
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:((CGFloat) img.height / (CGFloat) img.width)
                                                              constant:0];

        [self.viewImageContentView removeConstraint:constraintImageContainerZeroHeight];
        [self.viewImageContentView addConstraint:constraintAspectRatio];
    } else if ([item.media numberOfImages] > 0) {
        Image *img = [item.media largeImage];

        if (img.height == 0 || img.width == 0) {
            self.imageView.image = nil;
            [self.viewImageContentView removeConstraint:constraintAspectRatio];
            [self.viewImageContentView addConstraint:constraintImageContainerZeroHeight];
            self.buttonPlayVideo.hidden = YES;
        } else {
            NSURL *urlImage = [NSURL URLWithString:img.URL];

            self.buttonRetry.hidden = YES;
            [self.imageView setImageWithProgressIndicatorAndURL:urlImage
                                                        success:^(UIImage *image) {

                                                        }
                                                        failure:^(NSError *error) {
                                                            weakSelf.buttonRetry.hidden = NO;

                                                            DDLogError(@"Fail: %@\nError: %@", urlImage, error);
                                                        }];

            [self.imageView setUserInteractionEnabled:YES];

            // MHFaceBook ImageView
            [self.imageView setupImageViewer];
            [self.imageView setupImageViewerWithCompletionOnOpen:^{
            }                                            onClose:^{
            }];

            [self.viewImageContentView removeConstraint:constraintAspectRatio];

            constraintAspectRatio = [NSLayoutConstraint constraintWithItem:self.viewImageContentView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.viewImageContentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:[img ratio]
                                                                  constant:0];

            [self.viewImageContentView removeConstraint:constraintImageContainerZeroHeight];
            [self.viewImageContentView addConstraint:constraintAspectRatio];
        }

        self.buttonPlayVideo.hidden = YES;
    } else {
        self.imageView.image = nil;
        self.blurImageView.image = nil;
        [self.viewImageContentView removeConstraint:constraintAspectRatio];
        [self.viewImageContentView addConstraint:constraintImageContainerZeroHeight];
        self.buttonRetry.hidden = YES;
        self.buttonPlayVideo.hidden = YES;
    }

    constraintTitleTop.constant = ([self.labelTitle.text length]) ? 5 : 0;
    constraintDescriptionTop.constant = ([self.labelDescription.text length]) ? 5 : 0;

    self.labelTitle.linkAttributes = [[self class] linkAttributedTitle:item];
    self.labelDescription.linkAttributes = [[self class] linkAttributedDescription:item];
}

#pragma mark - Actions Buttons

- (IBAction)retryAction:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;

    if ([_item.media numberOfVideos] > 0) {
        Image *img = [_item.media largeImage];
        NSURL *urlImage = [NSURL URLWithString:img.URL];

        self.buttonRetry.hidden = YES;
        [self.imageView setImageWithProgressIndicatorAndURL:urlImage
                                                    success:^(UIImage *image) {
                                                        weakSelf.buttonRetry.hidden = YES;
                                                        weakSelf.buttonPlayVideo.hidden = NO;
                                                    }
                                                    failure:^(NSError *error) {
                                                        weakSelf.buttonRetry.hidden = NO;
                                                        weakSelf.buttonPlayVideo.hidden = YES;
                                                    }];

    } else if ([_item.media numberOfImages] > 0) {
        Image *img = [_item.media largeImage];

        NSURL *urlImage = [NSURL URLWithString:img.URL];

        self.buttonRetry.hidden = YES;
        [self.imageView setImageWithProgressIndicatorAndURL:urlImage
                                                    success:^(UIImage *image) {
                                                        weakSelf.buttonRetry.hidden = YES;
                                                    }
                                                    failure:^(NSError *error) {
                                                        weakSelf.buttonRetry.hidden = NO;
                                                    }];
    } else {
        self.buttonRetry.hidden = YES;
    }
}

- (IBAction)videoPlayButton:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedVideoPlay:item:)]) {
        [self.delegate clickedVideoPlay:self item:self.item];
    }
}

#pragma mark - TTTextAttributedLabelText Delegate Method

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    NSRange range = [result rangeAtIndex:0];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedHashTagAndMention:)]) {
        [self.delegate clickedHashTagAndMention:[self.item.title substringWithRange:range]];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedURLLink:title:)]) {
        [self.delegate clickedURLLink:url title:self.item.title];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSURL *url = [NSURL URLWithString:self.item.url];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma Buttons Action

- (IBAction)buttonGlueIt:(id)sender
{
    [self.delegate gluedCodeButtonAction:self];
}

- (IBAction)buttonShareAction:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(actionForShareButton:)]) {
        [self.delegate actionForShareButton:self];
    }
}

- (IBAction)buttonLinkAction:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedURLLink:title:)]) {
        NSURL *url = [NSURL URLWithString:self.item.url];

        [self.delegate clickedURLLink:url title:self.item.title];
    }
}

- (IBAction)buttonLikeAction:(id)sender
{

}

- (IBAction)buttonCommentAction:(id)sender
{

}

- (void)expand:(BOOL)shouldExpand
{
    if (shouldExpand) {
        constraintHeightBottomView.constant = 80;
        [self.buttonArrow setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
    } else {
        constraintHeightBottomView.constant = 0;
        [self.buttonArrow setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonBottomAction:(id)sender
{
    BOOL isExpand;

    isExpand = constraintHeightBottomView.constant == 0;

    if ([self.delegate respondsToSelector:@selector(collectionViewCell:didExpand:)]) {
        [self.delegate collectionViewCell:self didExpand:isExpand];
    }
}

- (IBAction)buttonAvatarName:(UIButton *)sender
{
    //    NSString *avatarNameStr = [NSString stringWithFormat:@"@%@", self.item.author];
    //    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickAuthor:)])
    //    {
    //        [self.delegate clickAuthor:avatarNameStr];
    //    }
}

- (IBAction)buttonServiceName:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedServiceName:)]) {
        [self.delegate clickedServiceName:self.item.service];
    }
}

- (NSInteger)numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer
{
    return 0;
}

- (NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return nil;
}

- (UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return nil;
}

#pragma mark - Class Method Starts

+ (UIFont *)AvenirNextBold_24
{
    return [UIFont fontWithName:@"AvenirNext-Bold" size:24];
}

+ (UIFont *)AvenirNext_Regular_16
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:16];
}

+ (UIFont *)AvenirNext_Regular_12
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:12];
}

+ (NSMutableParagraphStyle *)paragraphStyleFormat:(UIFont *)font
{
    static NSMutableParagraphStyle *paragraphStyle = nil;
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 0;
        paragraphStyle.minimumLineHeight = font.lineHeight;
        paragraphStyle.maximumLineHeight = font.lineHeight;
        paragraphStyle.lineHeightMultiple = 1;
        paragraphStyle.firstLineHeadIndent = 0;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return paragraphStyle;
}

+ (CGFloat)imageContentRatio:(Item *)item
{
    CGFloat imageContentRatio = 0;

    if ([item.media numberOfVideos] > 0 || [item.media numberOfImages] > 0) {
        imageContentRatio = [[item.media largeImage] ratio];
    }

    return imageContentRatio;
}

// Time String

+ (NSString *)timeString:(Item *)item
{
    return [NSString stringWithFormat:@"Posted %@ on %@", [[item.createdAt dateTimeAgo] lowercaseString], [[item.service stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString]];
}

+ (NSMutableDictionary *)linkAttributedTitle:(Item *)item
{
    NSMutableDictionary *linkAttributedTitle = [NSMutableDictionary dictionary];
    linkAttributedTitle[(NSString *) kCTForegroundColorAttributeName] = [UIColor menuDarkFont];
    linkAttributedTitle[(NSString *) kCTUnderlineStyleAttributeName] = @YES;

    ItemColors *colors = [Settings colorForServiceName:item.service];
    linkAttributedTitle[NSUnderlineColorAttributeName] = colors.buttonNormal;
    linkAttributedTitle[NSUnderlineStyleAttributeName] = @3;

    return linkAttributedTitle;
}

// Title String
+ (CGFloat)titleHeight:(NSMutableAttributedString *)titleAttributedString item:(Item *)item cellWidth:(CGFloat)width
{
    // For LabelTitle
    NSMutableAttributedString *attributedString = titleAttributedString;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *results = [linkDetector matchesInString:item.title options:0 range:NSMakeRange(0, [item.title length])];

    for (NSTextCheckingResult *result in results) {

        if ([result resultType] == NSTextCheckingTypeLink) {
            [attributedString setAttributes:[self linkAttributedTitle:item] range:result.range];
        }
    }

    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)|#(\\w+)" options:NO error:nil];
    NSArray *matches = [mentionExpression matchesInString:item.title options:0 range:NSMakeRange(0, [item.title length])];

    for (NSTextCheckingResult *result in matches) {
        NSArray *keys = @[(id) kCTForegroundColorAttributeName, (id) kCTUnderlineStyleAttributeName];
        NSArray *objects = @[[UIColor redColor], @(kCTUnderlineStyleNone)];

        NSDictionary *linkAttributes = @{keys: objects};
        [attributedString setAttributes:linkAttributes range:result.range];
    }

    CGSize requireTitleHeight = [TTTAttributedLabel sizeThatFitsAttributedString:titleAttributedString withConstraints:CGSizeMake(width - 20, CGFLOAT_MAX) limitedToNumberOfLines:0];

    return requireTitleHeight.height;
}

+ (NSMutableDictionary *)linkAttributedDescription:(Item *)item
{
    NSMutableDictionary *linkAttributedDesc = [NSMutableDictionary dictionary];
    linkAttributedDesc[(NSString *) kCTForegroundColorAttributeName] = [UIColor menuDarkFont];
    linkAttributedDesc[(NSString *) kCTUnderlineStyleAttributeName] = @YES;

    ItemColors *colors = [Settings colorForServiceName:item.service];
    linkAttributedDesc[NSUnderlineColorAttributeName] = colors.buttonNormal;
    linkAttributedDesc[NSUnderlineStyleAttributeName] = @3;

    return linkAttributedDesc;
}

+ (CGFloat)descriptionHeight:(NSMutableAttributedString *)descriptionAttributedString item:(Item *)item cellWidth:(CGFloat)width
{
    {   // For Description link
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *results = [linkDetector matchesInString:item.itemDescription options:0 range:NSMakeRange(0, [item.itemDescription length])];

        for (NSTextCheckingResult *result in results) {

            if ([result resultType] == NSTextCheckingTypeLink) {
                [descriptionAttributedString setAttributes:[self linkAttributedDescription:item] range:result.range];
            }
        }
    }

    CGSize requiredDescHeight = [TTTAttributedLabel sizeThatFitsAttributedString:descriptionAttributedString withConstraints:CGSizeMake(width - 20, CGFLOAT_MAX) limitedToNumberOfLines:0];
    return requiredDescHeight.height;
}

+ (CGSize)cellSizeWithItem:(Item *)item forCellWidth:(CGFloat)cellWidth isExpanded:(BOOL)isExpanded
{
    // Getting ImageView Height
    CGFloat imageContentRatio = [self imageContentRatio:item];

    /************************************/
    CGFloat buttonGlueItTop = 15;       // Button Glue It Top Constraint
    CGFloat buttonGlueItHeight = 40;    // Button Glue It Height Constraint

    /************************************/
    CGFloat imageContentViewTop = 15;   // imageContentView Top Constraint
    CGFloat imageHeight = imageContentRatio * cellWidth;

    /************************************/
    CGFloat titleLabelTop = 0;          // TitleLabel Top Constraint

    CGFloat titleHeight = 0;

    NSMutableAttributedString *titleAttributedString = nil;

    if (![item.title isEqual:[NSNull null]]) {
        UIFont *font = [self AvenirNextBold_24];
        NSMutableParagraphStyle *paragraphStyle = [self paragraphStyleFormat:font];

        titleAttributedString = [[NSMutableAttributedString alloc] initWithString:item.title attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName: @(0)}];
        titleHeight = [self titleHeight:titleAttributedString item:item cellWidth:cellWidth];

        if ([item.title length]) {
            titleLabelTop = 5;
        }
    }

    /************************************/
    CGFloat timeLabelTop = 5;           // TimeLabel Bottom Constraint

    NSString *timeString = [self timeString:item];

    CGFloat timeHeight = [timeString boundingRectWithSize:CGSizeMake(cellWidth - 20, CGFLOAT_MAX) options:0 attributes:@{NSFontAttributeName: [self AvenirNext_Regular_12]} context:NULL].size.height;

    /************************************/
    CGFloat descriptionLabelTop = 0;        // descriptionLabelTop Top  Constraint

    CGFloat descriptionHeight = 0;

    NSMutableAttributedString *descAttributedString = nil;

    if (![item.itemDescription isEqual:[NSNull null]]) {
        UIFont *font = [self AvenirNext_Regular_16];
        NSMutableParagraphStyle *paragraphStyle = [self paragraphStyleFormat:font];

        descAttributedString = [[NSMutableAttributedString alloc] initWithString:item.itemDescription attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName: @(0)}];
        descriptionHeight = [self descriptionHeight:descAttributedString item:item cellWidth:cellWidth];

        if ([item.itemDescription length]) {
            descriptionLabelTop = 5;
        }
    }

    /************************************/
    CGFloat expandViewTop = 10;      // expandViewButton Top  Constraint

    CGFloat expandView = 0;
    if (isExpanded) {
        expandView = 80;
    }

    CGFloat expandViewButtonHeight = 30;      // ExpandArrow Button Height Constraint

    CGFloat height = buttonGlueItTop + buttonGlueItHeight + imageContentViewTop + imageHeight + titleLabelTop + titleHeight + timeLabelTop + timeHeight + descriptionLabelTop + descriptionHeight + expandViewTop + expandView + expandViewButtonHeight;

    return CGSizeMake(cellWidth, height);
}

@end

//
//  RightMenuViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RightMenuViewController.h"
#import "RightMenuViewCell.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "SubscriptionList.h"
#import "Settings.h"
#import "SubscriptionManager.h"
#import "Service.h"
#import "Source.h"
#import "Subscription.h"
#import "ItemManager.h"
#import "Counter.h"
#import "UserManager.h"
#import "User.h"
#import "Plan.h"
#import "FeedbackViewController.h"
#import "CurrentSession.h"
#import "ItemColors.h"
#import "PlanListCollectionViewController.h"
#import "SelectedService.h"
#import "ServiceHeader.h"
#import "CommonHeader.h"
#import "UpgradeHeader.h"
#import "SubscriptionClient.h"
#import "InstagramService.h"
#import "TwitterService.h"
#import "ProductHuntService.h"
#import "RedditService.h"
#import "RefreshProfileResponse.h"
#import "UIColor+EG.h"
#import "ARAnalytics.h"


@interface RightMenuViewController () <HeaderServiceTableViewDelegate, HeaderCommonTableViewDelegate, HeaderUpgradeTableViewDelegate, UIAlertViewDelegate>
@property(strong, nonatomic) IBOutlet UILabel *labelUsername;
@property(strong, nonatomic) IBOutlet UILabel *labelCurrentPlan;
@property(strong, nonatomic) IBOutlet UIButton *buttonUpgrade;
@property(strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) IBOutlet UISegmentedControl *segmentAllAndUnread;
@property(strong, nonatomic) IBOutlet UIButton *buttonLogout;
@property(nonatomic) SubscriptionListMode listMode;
@property(nonatomic) SelectedService *currentlySelectedService;
@property(nonatomic) SelectedServiceAction currentlySelectedServiceAction;
@property(nonatomic) NSArray *specialHeaders;
@property(nonatomic) NSArray *specialFooters;

- (void)updateMenu;

- (IBAction)buttonUpgrade:(UIButton *)sender;

- (void)showEverything:(UIGestureRecognizer *)sender;

- (void)showSubscribe:(UIGestureRecognizer *)sender;

- (void)showManage:(UIGestureRecognizer *)sender;

- (void)showFeedback:(UIGestureRecognizer *)sender;

- (void)setup;

- (void)registerClasses;

- (void)loadDefaultSettings;

- (void)setNotifications;

- (UITableViewHeaderFooterView *)headerForServiceAtSection:(NSInteger)section;

- (UITableViewHeaderFooterView *)headerForShowEverything;

- (UITableViewHeaderFooterView *)headerForUpgrade;

- (UITableViewHeaderFooterView *)headerForSubscribe;

- (UITableViewHeaderFooterView *)headerForManage;

- (UITableViewHeaderFooterView *)headerForFeedback;

- (void)setCounterByService:(Service *)service forHeaderView:(ServiceHeader *)headerView;

- (NSArray *)currentListOfServicesToDisplay;

- (SelectedService *)selectedServiceByIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifier;
@end

@implementation RightMenuViewController

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];

    self.buttonLogout.hidden = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self updateMenu];
}

#pragma mark - Setup

- (void)setup
{
    [self loadDefaultSettings];
    [self registerClasses];
    [self setNotifications];

    self.specialHeaders = @[@"headerForUpgrade", @"headerForSubscribe", @"headerForShowEverything"];
    self.specialFooters = @[@"headerForManage", @"headerForFeedback"];
}

- (void)registerClasses
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CommonHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServiceHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ServiceHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UpgradeHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"UpgradeHeader"];
}

- (void)loadDefaultSettings
{
    // All/Unread
    self.segmentAllAndUnread.selectedSegmentIndex = [[CurrentSession instance] selectedSideBarOption];
    self.selectedShowAll = [[CurrentSession instance] selectedSideBarOption] == 0;

    // Username
//    NSString *username = [UserManager instance].user.username;
//    NSMutableAttributedString *userNameString = [[NSMutableAttributedString alloc] initWithString:[@"Hello," stringByAppendingString:username]];
    NSMutableAttributedString *userNameString = [[NSMutableAttributedString alloc] initWithString:@"Hello,"];
    [userNameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:13.0] range:NSMakeRange(0, 6)];
    self.labelUsername.attributedText = userNameString;

    // Current Plan
    NSString *currentPlan = [UserManager instance].user.plan.name;
    NSMutableAttributedString *currentPlanString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You're on %@ plan", currentPlan]];
    [currentPlanString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:13.0] range:NSMakeRange(10, [currentPlan length])];
    self.labelCurrentPlan.attributedText = currentPlanString;

    // List display mode
    self.listMode = [[CurrentSession instance] subscriptionListMode];
}

- (void)setNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ENRefreshedProfile
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      if ([notification.object isKindOfClass:[RefreshProfileResponse class]]) {
                                                          RefreshProfileResponse *res = notification.object;

                                                          self.labelUsername.text = [NSString stringWithFormat:@"%@ Plan", res.user.plan.name];
                                                          self.labelCurrentPlan.text = res.user.plan.planDescription;
                                                      } else if ([notification.object isKindOfClass:[NSError class]]) {
                                                          DDLogError(@"%@ error: %@", notification.name, ((NSError *) notification.object).localizedDescription);
                                                      } else {
                                                          DDLogError(@"Unknown error in %@", notification.name);
                                                      }
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ENSubscriptionList
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      [self.tableView reloadData];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ENCounters
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      DDLogVerbose(@"%@", notification.name);

                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          NSIndexPath *path = [self.tableView indexPathForSelectedRow];
                                                          [self.tableView reloadData];
                                                          [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                      });
                                                  }];
}

#pragma mark - Sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.listMode) {
        case SubscriptionListModeManage:
        case SubscriptionListModeAdd:
            return [[self currentListOfServicesToDisplay] count] + 1;
        default:
            return [[self currentListOfServicesToDisplay] count] + [self.specialHeaders count] + [self.specialFooters count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (self.listMode) {
        case SubscriptionListModeManage:
            return [self headerForManageModeInSection:section];
        case SubscriptionListModeAdd:
            return [self headerForSubscribeModeInSection:section];
        default:
            return [self headerInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.listMode == SubscriptionListModeUnread && section == 0) {
        return 100;
    }

    return 50;
}

#pragma mark Sections Helpers

- (void)sectionSelected:(UIGestureRecognizer *)sender
{
    Service *service = [self currentListOfServicesToDisplay][(NSUInteger) sender.view.tag];

    if (self.listMode == SubscriptionListModeAdd) {
        if (service.isLocked) {
            [self unlockService:service];
        }
        return;
    }
    if (self.listMode == SubscriptionListModeManage) {
        if (service.userId == nil) {
            return;
        }
        for (Source *source in service.sources) {
            if ([source.subscriptions count] > 0) {
                return;
            }
        }

        // Disconnect service
        _currentlySelectedServiceAction = SelectedServiceActionDisconnect;
        _currentlySelectedService = [[SelectedService alloc] initWithService:service source:nil subscription:nil];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Disconnect" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];

        return;
    }

    if (self.selected != nil) {
        [self.tableView deselectRowAtIndexPath:self.selected animated:YES];
    }

    [[ItemManager instance] setNewDataSourceWithService:service];
    [[ItemManager instance] load];

    [self.slidingViewController resetTopViewAnimated:YES];

    [[UserManager instance] setSelectedSourceId:0
                                        service:service.shortName
                              andSubscriptionId:0];

    [ARAnalytics event:EVSelectService withProperties:@{
            @"service": service.name,
    }];
}

- (UIView *)headerInSection:(NSInteger)section
{
    // TODO: refactor this shit

    if ([self.specialHeaders count] >= 1 && section == 0) {
        return [self performSelector:NSSelectorFromString(self.specialHeaders[0])];
    }
    if ([self.specialHeaders count] >= 2 && section == 1) {
        return [self performSelector:NSSelectorFromString(self.specialHeaders[1])];
    }
    if ([self.specialHeaders count] >= 3 && section == 2) {
        return [self performSelector:NSSelectorFromString(self.specialHeaders[2])];
    }
    if ([self.specialFooters count] >= 1 && section == [self.specialHeaders count] + [[self currentListOfServicesToDisplay] count]) {
        return [self performSelector:NSSelectorFromString(self.specialFooters[0])];
    }
    if ([self.specialFooters count] >= 2 && section == [self.specialHeaders count] + [[self currentListOfServicesToDisplay] count] + 1) {
        return [self performSelector:NSSelectorFromString(self.specialFooters[1])];
    }

    return [self headerForServiceAtSection:section - [self.specialHeaders count]];
}

- (UIView *)headerForManageModeInSection:(NSInteger)section
{
    if (section == 0) {
        return [self headerForManage];
    }

    return [self headerForServiceAtSection:section - 1];
}

- (UIView *)headerForSubscribeModeInSection:(NSInteger)section
{
    if (section == 0) {
        return [self headerForSubscribe];
    }

    return [self headerForServiceAtSection:section - 1];
}

- (UITableViewHeaderFooterView *)headerForServiceAtSection:(NSInteger)section
{
    Service *service = [self currentListOfServicesToDisplay][(NSUInteger) section];

    ServiceHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ServiceHeader"];
    headerView.delegate = self;
    headerView.labelName.text = service.name;
    if (section % 2 == 0) {
        headerView.innerHeaderView.backgroundColor = [UIColor evenHeader];
    } else {
        headerView.innerHeaderView.backgroundColor = [UIColor oddHeader];
    }

    if (self.listMode == SubscriptionListModeAdd) {
        headerView.labelCount.text = @"";
        headerView.imageViewIcon.hidden = YES;
    } else if (self.listMode == SubscriptionListModeManage) {
        headerView.labelCount.text = @"";
        headerView.imageViewIcon.hidden = YES;
    } else {
        [self setCounterByService:service forHeaderView:headerView];
    }

    ItemColors *color = [Settings colorForServiceName:service.shortName];
    headerView.colorView.backgroundColor = [color buttonActive];

    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionSelected:)]];
    [headerView setTag:section];

    return headerView;
}

- (UITableViewHeaderFooterView *)headerForShowEverything
{
    CommonHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommonHeader"];
    headerView.delegate = self;
    headerView.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor showEverythingHeader];
        view;
    });
    headerView.labelName.textColor = [UIColor menuDarkFont];
    headerView.labelName.text = NSLocalizedString(@"Everything", nil);
    headerView.icon.hidden = YES;

    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEverything:)]];

    return headerView;
}

- (UITableViewHeaderFooterView *)headerForUpgrade
{
    UpgradeHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UpgradeHeader"];
    headerView.delegate = self;
    headerView.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor yellowHeader];
        view;
    });
    headerView.planName.textColor = [UIColor menuDarkFont];

    NSString *currentPlan = @"Free";

    NSMutableAttributedString *currentPlanString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You're on %@ plan", currentPlan]];
    [currentPlanString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0] range:NSMakeRange(10, [currentPlan length])];
    headerView.planName.attributedText = currentPlanString;

    [headerView.upgradeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonUpgrade:)]];

    return headerView;
}

- (UITableViewHeaderFooterView *)headerForSubscribe
{
    CommonHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommonHeader"];
    headerView.delegate = self;
    headerView.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor subscribeHeader];
        view;
    });
    headerView.labelName.textColor = [UIColor whiteColor];
    headerView.labelName.text = NSLocalizedString(@"Subscribe", nil);
    headerView.icon.hidden = NO;
    if (self.listMode == SubscriptionListModeAdd) {
        headerView.icon.image = [UIImage imageNamed:@"cancel"];
    } else if (self.listMode == SubscriptionListModeManage) {
        headerView.icon.image = [UIImage imageNamed:@"cancel"];
    } else {
        headerView.icon.image = [UIImage imageNamed:@"add"];
    }

    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSubscribe:)]];

    return headerView;
}

- (UITableViewHeaderFooterView *)headerForManage
{
    CommonHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommonHeader"];
    headerView.delegate = self;
    headerView.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor oddHeader];
        view;
    });
    headerView.labelName.textColor = [UIColor menuDarkFont];
    headerView.labelName.text = NSLocalizedString(@"Manage", nil);
    headerView.icon.hidden = NO;

    if (self.listMode == SubscriptionListModeManage) {
        headerView.icon.image = [UIImage imageNamed:@"cancel"];
    } else {
        headerView.icon.image = [UIImage imageNamed:@"manage"];
    }

    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showManage:)]];

    return headerView;
}

- (UITableViewHeaderFooterView *)headerForFeedback
{
    CommonHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommonHeader"];
    headerView.delegate = self;
    headerView.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor evenHeader];
        view;
    });
    headerView.labelName.textColor = [UIColor menuDarkFont];
    headerView.labelName.text = NSLocalizedString(@"Feedback", nil);
    headerView.icon.hidden = NO;
    headerView.icon.image = [UIImage imageNamed:@"send"];

    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFeedback:)]];

    return headerView;
}

#pragma mark - Rows

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *visibleServices = [self currentListOfServicesToDisplay];
    NSInteger row = 0;

    // TODO: refactor
    if (self.listMode == SubscriptionListModeAdd) {
        if (section == 0) {
            return 0;
        } else {
            row = section - 1;
        }
    } else if (self.listMode == SubscriptionListModeManage) {
        if (section == 0) {
            return 0;
        } else {
            row = section - 1;
        }
    } else {
        row = section - [self.specialHeaders count];

        // Headers
        if (row < 0) {
            return 0;
        }

        // Footers
        if (row >= [visibleServices count]) {
            return 0;
        }
    }

    int count = 0;
    Service *s = visibleServices[(NSUInteger) row];

    for (Source *source in s.sources) {
        if (self.listMode == SubscriptionListModeAdd) {
            // Already subscribed to that source
            if (!source.valueAllowed && [source.subscriptions count] > 0) {
                continue;
            }

            count++;
            continue;
        }

        for (Subscription *subscription in source.subscriptions) {
            if (self.selectedShowAll || self.listMode == SubscriptionListModeManage) {
                count++;
            } else {
                if (subscription.counter.value > 0) {
                    count++;
                }
            }
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedService *selectedService = [self selectedServiceByIndexPath:indexPath];

    RightMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];

    if (self.listMode == SubscriptionListModeAdd) {
        cell.labelName.text = selectedService.source.name;
        cell.labelDescription.text = @"";
        cell.labelCount.text = @"";

        if (selectedService.source.isLocked) {
            cell.imageIcon.image = [UIImage imageNamed:@"lockWhite"];
        } else {
            cell.imageIcon.image = [UIImage imageNamed:@"add"];
        }
    } else if (self.listMode == SubscriptionListModeManage) {
        if ([selectedService.subscription.value length] > 0) {
            cell.labelName.text = selectedService.subscription.value;
        } else {
            cell.labelName.text = selectedService.source.name;
        }

        cell.labelDescription.text = @"";
        cell.labelCount.text = @"";
        cell.imageIcon.image = [UIImage imageNamed:@"binWhite"];
    } else {
        if ([selectedService.subscription.value length] > 0) {
            cell.labelName.text = selectedService.subscription.value;
            cell.labelDescription.text = @"";
        } else {
            cell.labelName.text = selectedService.source.name;
            cell.labelDescription.text = @"";
        }

        if (selectedService.subscription.counter.value > 1000) {
            cell.labelCount.text = @"(999+)";
        } else {
            cell.labelCount.text = [NSString stringWithFormat:@"(%li)", (long) selectedService.subscription.counter.value];
        }

        if ([[CurrentSession instance] selectedSubscriptionId] == selectedService.subscription.subscriptionId) {
            self.selected = indexPath;
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }

    if (indexPath.row % 2 == 0) {
        cell.cellBackgroundView.backgroundColor = [UIColor evenCell];
    } else {
        cell.cellBackgroundView.backgroundColor = [UIColor oddCell];
    }

    cell.colorView.backgroundColor = [Settings colorForServiceName:selectedService.service.shortName].buttonActive;
    cell.colorViewOnDescription.backgroundColor = [Settings colorForServiceName:selectedService.service.shortName].buttonActive;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedService *selectedService = [self selectedServiceByIndexPath:indexPath];

    if (self.listMode == SubscriptionListModeAdd) {
        if (selectedService.source.isLocked) {
            if ([self unlockService:selectedService.service]) {
                DDLogInfo(@"Unlocked service");
            } else {
                DDLogError(@"Failed to unlock service");
            }
        } else {
            _currentlySelectedService = selectedService;
            _currentlySelectedServiceAction = SelectedServiceActionSubscribe;

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Subscribe" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            if (selectedService.source.valueAllowed) {
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [[alert textFieldAtIndex:0] setPlaceholder:selectedService.source.valueHint];
            } else {
                alert.alertViewStyle = UIAlertViewStyleDefault;
            }
            [alert show];
        }
    } else if (self.listMode == SubscriptionListModeManage) {
        _currentlySelectedService = selectedService;
        _currentlySelectedServiceAction = SelectedServiceActionUnsubscribe;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unsubscribe" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    } else {
        [[ItemManager instance] setNewDataSourceWithSubscription:selectedService.subscription];
        [[ItemManager instance] load];

        self.selected = indexPath;

        [self.slidingViewController resetTopViewAnimated:YES];

        [[UserManager instance] setSelectedSourceId:selectedService.source.sourceId
                                            service:selectedService.service.shortName
                                  andSubscriptionId:selectedService.subscription.subscriptionId];

        [ARAnalytics event:EVSelectSubscription withProperties:@{
                @"service": selectedService.service.name,
                @"source": selectedService.source.name,
                @"subscription": @(selectedService.subscription.subscriptionId)
        }];
    }
}

#pragma mark - Row Helpers

- (void)setCounterByService:(Service *)service forHeaderView:(ServiceHeader *)headerView
{
    if (service.counter.value >= 1000) {
        headerView.labelCount.textAlignment = NSTextAlignmentLeft;
        headerView.labelCount.text = @"(999+)";
    } else {
        headerView.labelCount.text = [NSString stringWithFormat:@"(%li)", (long) service.counter.value];
    }
}

- (NSArray *)currentListOfServicesToDisplay
{
    switch (self.listMode) {
        case SubscriptionListModeUnread:
        case SubscriptionListModeGlued:
            return [self listOfServicesWithList:[SubscriptionManager instance].usersList];
        case SubscriptionListModeManage:
        case SubscriptionListModeAdd:
            return [self listOfServicesWithList:[SubscriptionManager instance].everythingList];
    }

    return nil;
}

- (NSArray *)listOfServicesWithList:(SubscriptionList *)list
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < list.count; ++i) {
        Service *s = [list serviceAtIndex:i];

        if (self.listMode == SubscriptionListModeAdd) {
            if (![self hasNothingToSubscribeTo:s]) {
                [arr addObject:s];
            }
        } else if (self.listMode == SubscriptionListModeManage) {
            if ((!s.isLocked && s.isLockedOriginally) || !s.isLockedOriginally) {
                if (![self hasNoSubscriptions:s]) {
                    [arr addObject:s];
                }
            }
        } else {
            if (self.selectedShowAll) {
                [arr addObject:s];
            } else if (s.counter.value > 0) {
                [arr addObject:s];
            }
        }
    }

    return arr;
}

// ??? check if works
- (BOOL)hasNothingToSubscribeTo:(Service *)service
{
    NSInteger nothing = 0;
    for (Source *source in service.sources) {
        if (!source.valueAllowed && [source.subscriptions count] > 0) {
            nothing++;
        }
    }

    return nothing == [service.sources count];
}

// ??? check if works
- (BOOL)hasNoSubscriptions:(Service *)service
{
    for (Source *source in service.sources) {
        if ([source.subscriptions count] > 0) {
            return NO;
        }
    }

    return YES;
}

- (SelectedService *)selectedServiceByIndexPath:(NSIndexPath *)indexPath
{
    // TODO: refactor
    NSInteger row = 0;
    if (self.listMode == SubscriptionListModeManage || self.listMode == SubscriptionListModeAdd) {
        row = indexPath.section - 1;
    } else {
        row = indexPath.section - [self.specialHeaders count];
    }

    Service *service = [self currentListOfServicesToDisplay][(NSUInteger) row];
    Source *source = nil;
    Subscription *subscription = nil;

    int currentRow = 0;
    for (Source *src in service.sources) {
        if (self.listMode == SubscriptionListModeAdd) {
            // Already subscribed to that source
            if (!src.valueAllowed && [src.subscriptions count] > 0) {
                continue;
            }

            if (currentRow++ == indexPath.row) {
                source = src;
                break;
            }
            continue;
        }

        for (Subscription *sub in src.subscriptions) {
            if (self.listMode != SubscriptionListModeManage && (!self.selectedShowAll && sub.counter.value == 0)) {
                continue;
            }

            if (currentRow++ == indexPath.row) {
                source = src;
                subscription = sub;

                break;
            }
        }
    }

    return [SelectedService selectedServiceWithService:service source:source subscription:subscription];
}

- (NSString *)cellIdentifier
{
    switch (self.listMode) {
        case SubscriptionListModeUnread:
        case SubscriptionListModeGlued:
            return @"NameCell";
        case SubscriptionListModeManage:
        case SubscriptionListModeAdd:
            // TODO: Fix
            return @"NameWithIconCell";
        default:
            return @"NameCell";
    }
}

#pragma mark - Helpers

- (void)updateMenu
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int widthValue = (int) screenWidth;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
            self.view.frame = CGRectMake((CGFloat) (screenWidth * .65), 0, (CGFloat) (screenWidth * .35), self.view.frame.size.height);
        } else {
            self.view.frame = CGRectMake((CGFloat) (screenWidth * .74), 0, (CGFloat) (screenWidth * .26), self.view.frame.size.height);
        }
    } else {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            self.view.frame = CGRectMake(widthValue / 4, 0, widthValue - (widthValue / 4), self.view.frame.size.height);
        } else {
            self.view.frame = CGRectMake(widthValue / 4, 0, widthValue - (widthValue / 4), self.view.frame.size.height);
        }

    }
    self.buttonUpgrade.layer.cornerRadius = self.buttonUpgrade.frame.size.height / 2;
}

#pragma mark - Actions

- (IBAction)buttonUpgrade:(UIButton *)sender
{
    DDLogInfo(@"UPGRADE");

    PlanListCollectionViewController *planList = [[self storyboard] instantiateViewControllerWithIdentifier:@"PlanListCollectionViewController"];
    [self presentViewController:planList animated:YES completion:nil];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpgradeNotify" object:nil];
}

- (void)showEverything:(UIGestureRecognizer *)sender
{
    DDLogInfo(@"showEverything");

    if (self.selected != nil) {
        [self.tableView deselectRowAtIndexPath:self.selected animated:YES];
    }

    [[ItemManager instance] setNewDataSource];
    [[ItemManager instance] load];

    [self.slidingViewController resetTopViewAnimated:YES];

    [[UserManager instance] setSelectedSourceId:0
                                        service:nil
                              andSubscriptionId:0];

    [ARAnalytics event:EVSelectAll];
}

- (void)showSubscribe:(UIGestureRecognizer *)sender
{
    DDLogDebug(@"showSubscribe");

    self.listMode = self.listMode == SubscriptionListModeAdd ? SubscriptionListModeUnread : SubscriptionListModeAdd;
}

- (void)showManage:(UIGestureRecognizer *)sender
{
    DDLogDebug(@"showManage");

    self.listMode = self.listMode == SubscriptionListModeManage ? SubscriptionListModeUnread : SubscriptionListModeManage;
}

- (void)showFeedback:(UIGestureRecognizer *)sender
{
    DDLogDebug(@"showFeedback");

    FeedbackViewController *feedController = [[self storyboard] instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self presentViewController:feedController animated:YES completion:nil];

    [ARAnalytics event:EVSelectAll];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (_currentlySelectedServiceAction == SelectedServiceActionSubscribe) {
            if ([[[alertView textFieldAtIndex:0] text] length] > 0) {
                [self subscribeToSource:_currentlySelectedService withValue:[[alertView textFieldAtIndex:0] text]];
            } else if (!_currentlySelectedService.source.valueAllowed) {
                [self subscribeToSource:_currentlySelectedService];
            }
        }
        if (_currentlySelectedServiceAction == SelectedServiceActionUnsubscribe && _currentlySelectedService.subscription != nil) {
            [self unsubscribeFromSource:_currentlySelectedService];
        }
        if (_currentlySelectedServiceAction == SelectedServiceActionDisconnect) {
            [self disconnectService:_currentlySelectedService.service];
        }
    }
}

- (BOOL)unsubscribeFromSource:(SelectedService *)selectedService
{
    DDLogInfo(@"Unsubscribe from source %@ %@", selectedService.source.name, selectedService.subscription.value);

    [[SubscriptionClient instance] unsubscribe:selectedService.subscription.subscriptionId];

    return YES;
}

- (BOOL)unsubscribeFromService:(SelectedService *)selectedService
{
    DDLogInfo(@"Unsubscribe from source %@", selectedService.source.name);

    return YES;
}

- (BOOL)subscribeToSource:(SelectedService *)selectedService
{
    DDLogInfo(@"Subscribe to source %@", selectedService.source.name);

    [[SubscriptionClient instance] subscribeTo:selectedService.source.sourceId];

    return YES;
}

- (BOOL)subscribeToSource:(SelectedService *)selectedService withValue:(NSString *)value
{
    DDLogInfo(@"Subscribe to source %@ with %@", selectedService.source.name, value);

    [[SubscriptionClient instance] subscribeTo:selectedService.source.sourceId withValue:value];

    return YES;
}

- (BOOL)unlockService:(Service *)service
{
    DDLogInfo(@"Unlock %@", service.name);

    id <ConnectableService> connectToService = nil;
    if ([service.shortName isEqualToString:Instagram]) {
        connectToService = [[InstagramService alloc] init];
    } else if ([service.shortName isEqualToString:ProductHunt]) {
        connectToService = [[ProductHuntService alloc] init];
    } else if ([service.shortName isEqualToString:Reddit]) {
        connectToService = [[RedditService alloc] init];
    } else if ([service.shortName isEqualToString:Twitter]) {
        connectToService = [[TwitterService alloc] init];

        [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:[connectToService clientId] andSecret:[connectToService clientSecret]];
        [[FHSTwitterEngine sharedEngine] setDelegate:self];

        UIViewController *loginController = [[FHSTwitterEngine sharedEngine] loginControllerWithCompletionHandler:nil];
        [self presentViewController:loginController animated:YES completion:nil];

        return YES;
    } else {
        DDLogWarn(@"%@ is not supported yet", service.shortName);
        return NO;
    }

    [[UIApplication sharedApplication] openURL:[connectToService authUrl]];

    return YES;
}

- (void)disconnectService:(Service *)service
{
    DDLogInfo(@"Disconnect %@", service.name);

    id <ConnectableService> connectToService = nil;
    if ([service.shortName isEqualToString:Instagram]) {
        connectToService = [[InstagramService alloc] init];
    } else if ([service.shortName isEqualToString:ProductHunt]) {
        connectToService = [[ProductHuntService alloc] init];
    } else if ([service.shortName isEqualToString:Reddit]) {
        connectToService = [[RedditService alloc] init];
    } else if ([service.shortName isEqualToString:Twitter]) {
        connectToService = [[TwitterService alloc] init];
    } else {
        DDLogWarn(@"%@ is not supported yet", service.shortName);
        return;
    }

    [connectToService setUser:@{
            @"service": service.shortName,
            @"id": service.userId,
            @"username": service.username
    }];
    [[SubscriptionClient instance] disconnect:connectToService];
}

- (IBAction)buttonLogout:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Confirmation", nil) message:NSLocalizedString(@"Are you Sure ?", nil) preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Logout", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UserManager instance] logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:ENLogout object:nil];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        DDLogDebug(@"Cancel");
    }];

    [alertController addAction:logoutAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)segmentAllAndUnread:(UISegmentedControl *)sender
{
    [[CurrentSession instance] setSelectedSideBarOption:(NSUInteger) self.segmentAllAndUnread.selectedSegmentIndex];

    self.selectedShowAll = self.segmentAllAndUnread.selectedSegmentIndex == 0;
    [self.tableView reloadData];
}

#pragma mark Setters

- (void)setListMode:(SubscriptionListMode)listMode
{
    _listMode = listMode;

    [[CurrentSession instance] setSubscriptionListMode:listMode];

    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark FHSTwitterEngineAccessTokenDelegate

- (NSString *)loadAccessToken
{
    return nil;
}

- (void)storeAccessToken:(NSString *)accessToken
{
    TwitterService *service = [[TwitterService alloc] init];
    [service processResponse:@{@"access_token": accessToken}];
    [[SubscriptionClient instance] connect:service];
}


@end

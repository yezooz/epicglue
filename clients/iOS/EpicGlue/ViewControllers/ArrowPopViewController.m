//
//  ArrowPopViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "ArrowPopViewController.h"
#import "RightMenuViewCell.h"

#import "ItemManager.h"

@interface ArrowPopViewController ()
{
    NSArray *arrayImage;
}
@end

@implementation ArrowPopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([ItemManager instance].selectedTab == SelectedTabGlued) {
        self.arrayData = @[NSLocalizedString(@"Unglue", nil), NSLocalizedString(@"Open in Safari", nil), NSLocalizedString(@"Share", nil)];
    } else {
        self.arrayData = @[NSLocalizedString(@"Glue", nil), NSLocalizedString(@"Open in Safari", nil), NSLocalizedString(@"Share", nil)];
    }
    arrayImage = @[@"Glue", @"Safari", @"share"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.labelArrowData.text = self.arrayData[(NSUInteger) indexPath.row];
    cell.uiImageView.image = [UIImage imageNamed:arrayImage[(NSUInteger) indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedSelectedIndex:)]) {
        [self.delegate clickedSelectedIndex:indexPath.row];
    }
}


@end

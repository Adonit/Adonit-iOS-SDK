//
//  ShortcutButtonsTableViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "ShortcutButtonsTableViewController.h"
#import "AdonitSDK.h"

@interface ShortcutButtonsTableViewController ()
@property JotShortcut *currentShortcut;
@end

@implementation ShortcutButtonsTableViewController

- (void)setButtonNumber:(NSUInteger)buttonNumber
{
    // TODO: update the image
    _buttonNumber = buttonNumber;
    JotStylusManager *stylusManager = [JotStylusManager sharedInstance];
    switch (buttonNumber) {
        case 1:
            self.currentShortcut = stylusManager.button1Shortcut;
            self.title = NSLocalizedString(@"Button 1", @"Button 1 shortcut screen title");
            break;
        case 2:
            self.currentShortcut = stylusManager.button2Shortcut;
            self.title = NSLocalizedString(@"Button 2", @"Button 2 shortcut screen title");
            break;
        default:
            self.currentShortcut = nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [JotStylusManager sharedInstance].shortcuts.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JotShortcut *shortcut = [JotStylusManager sharedInstance].shortcuts[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShortcutEntryCell"];
    cell.textLabel.text = shortcut.descriptiveText;
    
    if (shortcut == self.currentShortcut) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self applyColorSchemeToCell:cell];
    
    return cell;
}

- (void)applyColorSchemeToCell:(UITableViewCell *)cell
{
    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label isEqual:cell.detailTextLabel]) {
                label.textColor = [UIColor jotDetailTextColor];
            } else {
                label.textColor = [UIColor jotTextColor];
            }
        } else if ([subview isKindOfClass:[UISwitch class]]) {
            UISwitch *cellSwitch = (UISwitch *)subview;
            
//            if (self.switchOnStateColor) {
//                cellSwitch.onTintColor = self.switchOnStateColor;
//            }
            cellSwitch.tintColor = [UIColor jotSeparatorColor];
            // tinting the thumb switch also removes shadows, so abort for now.
            //cellSwitch.thumbTintColor = self.tertiaryColor;
        }
        subview.backgroundColor = [UIColor clearColor];
    }
    
    cell.tintColor = [UIColor jotPrimaryColor];
    cell.backgroundColor = [UIColor jotTableViewCellBackgroundColor];
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor jotSelectedTableViewCellColor];
    cell.selectedBackgroundView = selectedBackgroundView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentShortcut = [JotStylusManager sharedInstance].shortcuts[indexPath.row];
    

    switch (self.buttonNumber) {
        case 1:
            [JotStylusManager sharedInstance].button1Shortcut = self.currentShortcut;
            break;
        case 2:
            [JotStylusManager sharedInstance].button2Shortcut = self.currentShortcut;
            break;
        default:
            break;
    }

    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[self arrayOfIndexPathsForShortCuts] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (NSArray *) arrayOfIndexPathsForShortCuts
{
    NSMutableArray *arrayOfShortcuts = [NSMutableArray array];
    NSInteger numberOfShortcuts = [self.tableView numberOfRowsInSection:0];
    
    for (NSInteger counter = 0; counter < numberOfShortcuts; counter++) {
        [arrayOfShortcuts addObject:[NSIndexPath indexPathForRow:counter inSection:0]];
    }
    return arrayOfShortcuts;
}

@end

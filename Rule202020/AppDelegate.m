//
//  AppDelegate.m
//  Rule202020
//
//  Created by Mark Hall on 2015-12-15.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "AppDelegate.h"
#import "EventMonitor.h"
#import "MainViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover *popover;
@property (strong, nonatomic) EventMonitor *eventMonitor;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    _statusItem.title = @"";
    _statusItem.image = [NSImage imageNamed:@"MenuIcon"];
    _statusItem.highlightMode = YES;
    _statusItem.button.action = @selector(toggleMenu:);

    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
    _popover.behavior = NSPopoverBehaviorTransient;

    _eventMonitor = [[EventMonitor alloc] initWithMask:NSLeftMouseDownMask handler:^(NSEvent *event) {
        if ([event window] != self.window) {
            if (self.popover.shown) {
                [self hidePopover:event];
            }
        }
    }];
    [_eventMonitor start];
}

- (void)toggleMenu:(id)sender
{
    if (self.popover.shown) {
        [self hidePopover:sender];
    }
    else {
        [self showPopover:sender];
    }
}

- (void)showPopover:(id)sender
{
    if (sender == self.statusItem.button) {
        [self.popover showRelativeToRect:self.statusItem.button.bounds ofView:self.statusItem.button preferredEdge:NSMinYEdge];
    }
    [self.eventMonitor start];
}

- (void)hidePopover:(id)sender
{
    [self.popover performClose:sender];
    [self.eventMonitor stop];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end

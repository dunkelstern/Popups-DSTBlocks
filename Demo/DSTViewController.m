//
//  DSTViewController.m
//  Popups+Blocks
//
//  Created by Johannes Schriewer on 08.03.2013.
//  Copyright (c) 2013 Johannes Schriewer. All rights reserved.
//

#import "DSTViewController.h"
#import "Popups+DSTBlocks.h"

@interface DSTViewController () <UIAlertViewDelegate>
@end

@implementation DSTViewController

#pragma mark UIAlertView with blocks
- (IBAction)showAlertViewBlocks:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Title"
                               message:@"Some message body here"
                          cancelButton:
                            [DSTBlockButton buttonWithTitle:@"Cancel"
                                                      block:^{
                                                          NSLog(@"Cancel button pressed");
                                                      }]
                          otherButtons: @[
                            [DSTBlockButton buttonWithTitle:@"Button 1"
                                                      block:^{
                                                          NSLog(@"Button 1 pressed");
                                                      }],
                            [DSTBlockButton buttonWithTitle:@"Button 2"
                                                      block:^{
                                                          NSLog(@"Button 2 pressed");
                                                      }]
     ]] show];

}

#pragma mark - UIAlertView native
- (IBAction)showAlertView:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Title"
                                message:@"Some message body here"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Button 1", @"Button 2", nil] show];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    NSLog(@"Cancel called");
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        NSLog(@"Cancel button pressed");
        return;
    }
    switch (buttonIndex) {
        case 1:
            NSLog(@"Button 1 pressed");
            break;
        case 2:
            NSLog(@"Button 2 pressed");
            break;
        default:
            break;
    }
}

@end
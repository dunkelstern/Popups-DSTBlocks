//
//  UIAlertView+Blocks.m
//  Popups+Blocks
//
//  Created by Johannes Schriewer on 08.03.2013.
//  Copyright (c) 2013 Johannes Schriewer. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertView+DSTBlocks.h"

@interface DSTAlertViewProxyDelegate : NSObject <UIAlertViewDelegate>
@property (nonatomic, strong) DSTCancelButtonBlock cancelBlock;
@property (nonatomic, strong) DSTWillPresentPopupBlock willPresentBlock;
@property (nonatomic, strong) DSTPopupPresentedBlock presentedBlock;
@property (nonatomic, strong) NSMutableArray *buttonBlocks;
@property (nonatomic, weak) id<UIAlertViewDelegate>masterDelegate;
@end

@implementation DSTAlertViewProxyDelegate

- (DSTAlertViewProxyDelegate *)init {
    self = [super init];
    if (self) {
        _buttonBlocks = [NSMutableArray array];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (!_cancelBlock) {
            [_masterDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
        }
        return; // cancel button calls cancel action
    }

    // correct button index as original alert view uses one internal list for all buttons
    if ([alertView cancelButtonIndex] >= 0) {
        buttonIndex -= 1;
    }
    // try block first
    if ([_buttonBlocks count] > buttonIndex) {
        // if block for this button is NSNull instance skip to fallback, do not execute the block as dissmiss is called later on
        if (![_buttonBlocks[buttonIndex] isKindOfClass:[NSNull class]]) {
            return;
        }
    }
    // fallback to delegate
    [_masterDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (_cancelBlock) {
            _cancelBlock();
            return;
        }
        [_masterDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
        return;
    }

    // correct button index as original alert view uses one internal list for all buttons
    if ([alertView cancelButtonIndex] >= 0) {
        buttonIndex -= 1;
    }
    // try block first
    if ([_buttonBlocks count] > buttonIndex) {
        // if block for this button is NSNull instance skip to fallback
        if (![_buttonBlocks[buttonIndex] isKindOfClass:[NSNull class]]) {
            ((DSTButtonPressBlock)(_buttonBlocks[buttonIndex]))();
            return;
        }
    }
    // fallback to delegate
    [_masterDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    // only delegate
    [_masterDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    // try block first
    if (_cancelBlock) {
        _cancelBlock();
        return;
    }
    // no block, message delegate
    [_masterDelegate alertViewCancel:alertView];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    // only delegate
    return [_masterDelegate alertViewShouldEnableFirstOtherButton:alertView];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    // try block first
    if (_willPresentBlock) {
        _willPresentBlock();
        return;
    }
    // no block, message delegate
    [_masterDelegate willPresentAlertView:alertView];
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    // try block first
    if (_presentedBlock) {
        _presentedBlock();
        return;
    }
    // no block, message delegate
    [_masterDelegate didPresentAlertView:alertView];
}
@end

static char const * const internalDelegateKey = "DSTBlocksInternalDelegate";

@implementation UIAlertView (DSTBlocks)
- (UIAlertView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(DSTBlockButton *)cancelButton otherButtons:(NSArray *)otherButtons {
    // set up internal delegate
    DSTAlertViewProxyDelegate *internalDelegate = [self fetchInternalDelegate];
    self = [self initWithTitle:title
                       message:message
                      delegate:internalDelegate
             cancelButtonTitle:cancelButton.title
             otherButtonTitles:nil];
    if (self) {
        [internalDelegate setCancelBlock:cancelButton.block];
        for (DSTBlockButton *button in otherButtons) {
            [self addButton:button];
        }
    }
    return self;
}

- (void)addButton:(DSTBlockButton *)button {
    DSTAlertViewProxyDelegate *internalDelegate = [self fetchInternalDelegate];
    [internalDelegate.buttonBlocks addObject:button.block];
    [self addButtonWithTitle:button.title];
}

- (void)setWillPresentBlock:(DSTWillPresentPopupBlock)block {
    DSTAlertViewProxyDelegate *internalDelegate = [self fetchInternalDelegate];
    [internalDelegate setWillPresentBlock:block];
}

- (void)setDidPresentBlock:(DSTPopupPresentedBlock)block {
    DSTAlertViewProxyDelegate *internalDelegate = [self fetchInternalDelegate];
    [internalDelegate setPresentedBlock:block];
}

#pragma mark - Internal
- (DSTAlertViewProxyDelegate *)fetchInternalDelegate {
    DSTAlertViewProxyDelegate *internalDelegate = objc_getAssociatedObject(self, internalDelegateKey);
    if (internalDelegate == nil) {
        // well we got initialized with original initWithTitle, so rebuild internal state
        internalDelegate = [[DSTAlertViewProxyDelegate alloc] init];
        objc_setAssociatedObject(self, internalDelegateKey, internalDelegate, OBJC_ASSOCIATION_RETAIN);

        // bend the delegate to call our internal delegate class first
        [internalDelegate setMasterDelegate:self.delegate];
        [self setDelegate:internalDelegate];

        // add already existing buttons (if there are some) with empty blocks
        if ([self firstOtherButtonIndex] >= 0) {
            for (NSInteger i = [self firstOtherButtonIndex]; i < [self numberOfButtons]; i++) {
                [internalDelegate.buttonBlocks addObject:[NSNull null]];
            }
        }
    }
    return internalDelegate;
}
@end

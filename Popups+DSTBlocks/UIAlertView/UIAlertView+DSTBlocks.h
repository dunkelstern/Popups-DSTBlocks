//
//  UIAlertView+Blocks.h
//  Popups+Blocks
//
//  Created by Johannes Schriewer on 08.03.2013.
//  Copyright (c) 2013 Johannes Schriewer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Popups+DSTBlocks.h"

@interface UIAlertView (DSTBlocks)
- (UIAlertView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(DSTBlockButton *)cancelButton otherButtons:(NSArray *)otherButtons;
- (void)addButton:(DSTBlockButton *)button;

- (void)setWillPresentBlock:(DSTWillPresentPopupBlock)block;
- (void)setDidPresentBlock:(DSTPopupPresentedBlock)block;
@end

